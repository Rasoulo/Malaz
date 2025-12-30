import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/config/color/app_color.dart';
import '../../../../core/service_locator/service_locator.dart';
import '../../../../data/datasources/local/auth_local_datasource.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState  extends State<MyProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _isEditable = false;
  String? _tempLocalImagePath;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();

    final state = context.read<AuthCubit>().state;
    if (state is AuthAuthenticated) {
      _firstNameController.text = state.user.first_name;
      _lastNameController.text = state.user.last_name;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _tempLocalImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          String? profileImgUrl;
          dynamic currentUser;

          if (state is AuthAuthenticated) {
            profileImgUrl = state.user.profile_image_url;
            currentUser = state.user;
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primaryLight,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.surface),
                  onPressed: () => context.go('/home'),
                ),
                actions: [
                  if (_isEditable)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
                          await context.read<AuthCubit>().updateUserData(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            imagePath: _tempLocalImagePath,
                            existingImageUrl: currentUser.profile_image_url,
                          );
                          setState(() {
                            _isEditable = false;
                            _tempLocalImagePath = null;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(tr.profile_updated_success),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                          setState(() => _isEditable = false);
                        },
                        child: Text(tr.done, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(decoration: const BoxDecoration(gradient: AppColors.premiumGoldGradient2)),
                      Positioned(
                        top: -50,
                        right: -50,
                        child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.1)),
                      ),
                      _buildAvatar(profileImgUrl, colorScheme),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        _buildProfileName(colorScheme),
                        const SizedBox(height: 8),
                        Text(
                            tr.my_profile.toUpperCase(),
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2
                            )
                        ),
                        const SizedBox(height: 35),
                        _buildInfoCard(colorScheme, tr, state),
                        const SizedBox(height: 40),
                        if (!_isEditable) _buildPremiumEditButton(context, tr),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar(String? profileImgUrl, ColorScheme colorScheme) {
    return Positioned(
      bottom: 40,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
            ),
            child: Hero(
              tag: 'profile_pic',
              child: CircleAvatar(
                radius: 65,
                backgroundColor: colorScheme.surface,
                child: _tempLocalImagePath != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(65),
                  child: Image.file(File(_tempLocalImagePath!), width: 130, height: 130, fit: BoxFit.cover),
                )
                    : UserProfileImage(
                  imageUrl: profileImgUrl ?? "",
                  size: 130,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                ),
              ),
            ),
          ),
          if (_isEditable)
            Positioned(
              bottom: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _pickImage();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: AppColors.premiumGoldGradient2,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileName(ColorScheme colorScheme) {
    return _isEditable
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(child: TextField(controller: _firstNameController, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(child: TextField(controller: _lastNameController, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        ],
      ),
    )
        : Text("${_firstNameController.text} ${_lastNameController.text}", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorScheme.primary, letterSpacing: 0.5));
  }

  Widget _buildInfoCard(ColorScheme colorScheme, AppLocalizations tr, AuthState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _infoTile(Icons.person_outline, tr.first_name, _firstNameController, colorScheme),
                _customDivider(colorScheme),
                _infoTile(Icons.badge_outlined, tr.last_name, _lastNameController, colorScheme),
                _customDivider(colorScheme),
                _buildPasswordTile(tr, colorScheme, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, TextEditingController controller, ColorScheme colorScheme, {bool isEnabled = true}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: _isEditable && isEnabled ? colorScheme.primary.withOpacity(0.03) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: _isEditable && isEnabled ? AppColors.primaryLight : colorScheme.primary.withOpacity(0.5), size: 22),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)),
                TextField(
                  controller: controller,
                  enabled: _isEditable && isEnabled,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isEditable && isEnabled ? AppColors.primaryLight : colorScheme.onSurface
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTile(AppLocalizations tr, ColorScheme colorScheme, AuthState state) {
    return InkWell(
      onTap: () {
        if (state is AuthAuthenticated) {
          context.push('/reset-password', extra: state.user.phone);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User data not found"))
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Icon(Icons.lock_outline, color: colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.password, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 4),
                  const Text("••••••••", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _customDivider(ColorScheme colorScheme) {
    return Divider(height: 1, indent: 70, endIndent: 20, color: colorScheme.primary.withOpacity(0.05));
  }

  Widget _buildPremiumEditButton(BuildContext context, AppLocalizations tr) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.premiumGoldGradient2,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.primaryLight.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: ElevatedButton(
        onPressed: () => _showPasswordDialog(context),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
        child: Text(tr.edit_profile, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.lock_person_rounded, color: colorScheme.primary, size: 28),
                ),
                const SizedBox(height: 16),
                Text(
                  tr.identity_verification,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr.identity_verification_input,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  autofocus: true,
                  style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: tr.current_password,
                    hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.3), fontWeight: FontWeight.normal),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                    prefixIcon: Icon(Icons.password_rounded, size: 20, color: colorScheme.primary.withOpacity(0.5)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurface.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: Text(tr.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 0,
                  shadowColor: colorScheme.primary.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: isLoading ? null : () async {
                  setState(() => isLoading = true);
                  final bool isCorrect = await context.read<AuthCubit>().verifyPasswordSilently(passwordController.text);
                  if (isCorrect) {
                    Navigator.pop(context);
                    this.setState(() => _isEditable = true);
                  } else {
                    setState(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr.incorrect_password),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: colorScheme.error,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : Text(tr.verify, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class UserProfileImage extends StatelessWidget {
  final String imageUrl;
  final String? firstName;
  final String? lastName;
  final double size;

  const UserProfileImage({
    super.key,
    required this.imageUrl,
    this.firstName,
    this.lastName,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValidUrl = imageUrl.trim().startsWith('http');

    if (!isValidUrl) {
      return _buildInitialsPlaceholder();
    }

    return FutureBuilder<String?>(
      future: sl<AuthLocalDatasource>().getCachedToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(width: size, height: size, child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryLight));
        }

        final token = snapshot.data;
        return ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.network(
            imageUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            headers: {'Authorization': 'Bearer ${token?.trim()}'},
            errorBuilder: (context, error, stackTrace) => _buildInitialsPlaceholder(),
          ),
        );
      },
    );
  }

  Widget _buildInitialsPlaceholder() {
    final String initial1 = (firstName != null && firstName!.isNotEmpty) ? firstName![0].toUpperCase() : '';
    final String initial2 = (lastName != null && lastName!.isNotEmpty) ? lastName![0].toUpperCase() : '';

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.premiumGoldGradient2,
      ),
      alignment: Alignment.center,
      child: Text(
        "$initial1$initial2",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}