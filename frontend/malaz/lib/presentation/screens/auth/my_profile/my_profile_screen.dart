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
                elevation: 0,
                backgroundColor: AppColors.primaryLight,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back_ios_new, color: colorScheme.surface, size: 18),
                  ),
                  onPressed: () => context.go('/home'),
                ),
                actions: [
                  if (_isEditable)
                    _buildTopSaveButton(tr, currentUser, colorScheme),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: AppColors.premiumGoldGradient2,
                        ),
                      ),

                      _buildAnimatedBubble(top: -20, left: -30, size: 150, opacity: 0.1),
                      _buildAnimatedBubble(bottom: 40, right: -50, size: 200, opacity: 0.08),
                      _buildAnimatedBubble(top: 80, left: 150, size: 80, opacity: 0.05),

                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topLeft,
                            radius: 1.5,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 100, 25, 40),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildSideAvatar(profileImgUrl),
                            const SizedBox(width: 20),
                            Expanded(child: _buildProfileHeaderInfo(tr, colorScheme)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.background,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileActionsBar(colorScheme, tr),

                        const SizedBox(height: 35),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ProfileStats(),
                        ),

                        const SizedBox(height: 40),

                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 15),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                tr.my_profile.toUpperCase(),
                                style: TextStyle(
                                  color: colorScheme.primary.withOpacity(0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildModernInfoCard(colorScheme, tr, state),

                        const SizedBox(height: 100),
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

  Widget _buildAnimatedBubble({double? top, double? left, double? right, double? bottom, required double size, required double opacity}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }

  Widget _buildProfileActionsBar(ColorScheme colorScheme, AppLocalizations tr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(
              icon: Icons.favorite_border,
              label: tr.favorites,
              onTap: () => context.push('/favorites'),
              colorScheme: colorScheme,
            ),

            _verticalDivider(),
            _actionButton(
              icon: Icons.location_on_outlined,
              label: "Location",//tr.location,
              onTap: () {
                // TODO: open location picker
              },
              colorScheme: colorScheme,
            ),
            _verticalDivider(),
            _actionButton(
              icon: Icons.edit_outlined,
              label: tr.edit_profile,
              onTap: () => _requestEditProfile(context),
              colorScheme: colorScheme,
              isPrimary: true,
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTopSaveButton(AppLocalizations tr, dynamic currentUser, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        },
        child: Text(tr.done, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
      ),
    );
  }

  void _requestEditProfile(BuildContext context) {
    HapticFeedback.lightImpact();
    _showPasswordDialog(context);
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 30,
      color: Colors.grey.withOpacity(0.2),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isPrimary ? AppColors.primaryLight : colorScheme.primary,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isPrimary ? AppColors.primaryLight : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderInfo(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${_firstNameController.text} ${_lastNameController.text}",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2))],
          ),
        ),
        const SizedBox(height: 6),
        _buildMyLocation(colorScheme: colorScheme),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome, size: 12, color: Colors.amberAccent),
              const SizedBox(width: 6),
              Text(
                "PREMIUM MEMBER",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideAvatar(String? profileImgUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 105,
          height: 105,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),

        Container(
          width: 98,
          height: 98,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.5),
                AppColors.primaryLight.withOpacity(0.2),
              ],
            ),
          ),
        ),

        Hero(
          tag: 'profile_pic',
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey.shade100,
              child: _tempLocalImagePath != null
                  ? ClipOval(
                child: Image.file(
                  File(_tempLocalImagePath!),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              )
                  : UserProfileImage(
                imageUrl: profileImgUrl ?? "",
                size: 90,
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
              ),
            ),
          ),
        ),

        if (_isEditable)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
                  ],
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryLight),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildModernInfoCard(ColorScheme colorScheme, AppLocalizations tr, AuthState state) {
    return Column(
      children: [
        _buildGlassTile(
          icon: Icons.person_rounded,
          label: tr.first_name,
          controller: _firstNameController,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 12),
        _buildGlassTile(
          icon: Icons.badge_rounded,
          label: tr.last_name,
          controller: _lastNameController,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 12),
        _buildMagicalPasswordTile(tr, colorScheme, state),
      ],
    );
  }

  Widget _buildGlassTile({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _isEditable ? AppColors.primaryLight.withOpacity(0.3) : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryLight, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800)),
                TextField(
                  controller: controller,
                  enabled: _isEditable,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagicalPasswordTile(AppLocalizations tr, ColorScheme colorScheme, AuthState state) {
    return InkWell(
      onTap: () => state is AuthAuthenticated ? context.push('/reset-password', extra: state.user.phone) : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.lock_rounded, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.password.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800)),
                  const Text("••••••••", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
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

class _buildMyLocation extends StatelessWidget {
  final ColorScheme colorScheme;

  const _buildMyLocation({
    super.key,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: 14, color: colorScheme.surface,),
        const SizedBox(width: 4),
        Text(
          "Dubai, UAE",
          style: TextStyle(color: colorScheme.surface, fontSize: 13),
        ),
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  Widget _item(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item("24", "Favorites"),
          _item("12", "Bookings"),
          _item("5", "Reviews"),
        ],
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