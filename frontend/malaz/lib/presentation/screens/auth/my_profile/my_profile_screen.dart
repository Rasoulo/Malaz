import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';
import '../../../cubits/location/location_cubit.dart';
import '../../../global_widgets/user_profile_image/user_profile_image.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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

    context.read<LocationCubit>().loadSavedLocation();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleLocationUpdate() async {
    HapticFeedback.mediumImpact();
    final lang = Localizations.localeOf(context).languageCode;
    await context.read<LocationCubit>().getCurrentLocation(lang);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _tempLocalImagePath = image.path);
    }
  }

  void _requestEditProfile(BuildContext context) {
    HapticFeedback.lightImpact();
    _showModernPasswordDialog(context);
  }

  Future<void> _saveProfileChanges(dynamic user) async {
    HapticFeedback.mediumImpact();
    await context.read<AuthCubit>().updateUserData(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      imagePath: _tempLocalImagePath,
      existingImageUrl: user.profile_image_url,
    );
    setState(() {
      _isEditable = false;
      _tempLocalImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          dynamic currentUser = (state is AuthAuthenticated) ? state.user : null;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(tr, colorScheme, currentUser),
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -25),
                  child: _buildMainContainer(tr, colorScheme, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations tr, ColorScheme colorScheme, dynamic user) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppColors.primaryLight,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(Icons.arrow_back, color: colorScheme.surface, size: 18),
        ),
        onPressed: () => context.go('/home'),
      ),
      actions: [
        if (_isEditable)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryLight,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => _saveProfileChanges(user),
              child: Text(tr.done, style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(decoration: const BoxDecoration(gradient: AppColors.premiumGoldGradient2)),
            _buildAnimatedBubble(top: -20, left: -30, size: 150, opacity: 0.1),
            _buildAnimatedBubble(bottom: 40, right: -50, size: 200, opacity: 0.08),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 100, 25, 40),
              child: Row(
                children: [
                  _buildAvatarWrapper(user?.id),
                  const SizedBox(width: 20),
                  Expanded(child: _buildProfileHeaderInfo(tr, colorScheme)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContainer(AppLocalizations tr, ColorScheme colorScheme, AuthState state) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          const SizedBox(height: 60),
          _buildProfileActionsBar(colorScheme, tr),
          const SizedBox(height: 40),
          _buildModernInfoCard(colorScheme, tr, state),
          const SizedBox(height: 100),
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
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: colorScheme.surface),
        ),
        const SizedBox(height: 6),
        BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            String address = tr.unknown_location;
            if (state is LocationLoading) {
              address = 'Leading...';
            }
            if (state is LocationLoaded) {
              address = state.location.address;
            }
            return Row(
              children: [
                Icon(Icons.location_on, size: 14, color: colorScheme.surface),
                const SizedBox(width: 4),
                Expanded(child: Text(address, style: TextStyle(color: colorScheme.surface, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        _buildBadge(tr.verified_account, colorScheme),
      ],
    );
  }

  Widget _buildAvatarWrapper(int? userId) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 94, height: 94, decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, shape: BoxShape.circle)),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, shape: BoxShape.circle),
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade100,
            child: _tempLocalImagePath != null
                ? ClipOval(child: Image.file(File(_tempLocalImagePath!), width: 90, height: 90, fit: BoxFit.cover))
                : UserProfileImage(userId: userId ?? 0, radius: 45, firstName: _firstNameController.text, lastName: _lastNameController.text),
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
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: const Icon(Icons.camera_alt, size: 16, color: AppColors.primaryLight),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileActionsBar(ColorScheme colorScheme, AppLocalizations tr) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionItem(Icons.favorite_border, tr.favorites, () => context.push('/favorites'), colorScheme),
          _vDivider(),
          _actionItem(Icons.location_on_outlined, tr.location, _handleLocationUpdate, colorScheme),
          _vDivider(),
          _actionItem(Icons.edit_outlined, tr.edit_profile, () => _requestEditProfile(context), colorScheme, isPrimary: true),
        ],
      ),
    );
  }

  Widget _buildModernInfoCard(ColorScheme colorScheme, AppLocalizations tr, AuthState state) {
    return Column(
      children: [
        _buildInfoField(Icons.person_rounded, tr.first_name, _firstNameController, colorScheme),
        const SizedBox(height: 12),
        _buildInfoField(Icons.badge_rounded, tr.last_name, _lastNameController, colorScheme),
        const SizedBox(height: 12),
        _buildPasswordField(tr, colorScheme, state),
      ],
    );
  }

  Widget _buildInfoField(IconData icon, String label, TextEditingController controller, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],

        border: Border.all(
          color: _isEditable
              ? AppColors.primaryLight.withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryLight, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                TextField(
                  controller: controller,
                  enabled: _isEditable,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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

  Widget _buildPasswordField(AppLocalizations tr, ColorScheme colorScheme, AuthState state) {
    return InkWell(
      onTap: () => state is AuthAuthenticated ? context.push('/reset-password', extra: state.user.phone) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: colorScheme.surface, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.primaryLight),
            const SizedBox(width: 15),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr.password, style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
              const Text("••••••••", style: TextStyle(fontWeight: FontWeight.bold)),
            ])),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.verified, size: 12, color: colorScheme.tertiary),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(color: colorScheme.surface, fontSize: 10, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _actionItem(IconData icon, String label, VoidCallback onTap, ColorScheme colorScheme, {bool isPrimary = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Icon(icon, color: isPrimary ? AppColors.primaryLight : colorScheme.primary, size: 22),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isPrimary ? AppColors.primaryLight : null)),
      ]),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.2));

  Widget _buildAnimatedBubble({double? top, double? left, double? right, double? bottom, required double size, required double opacity}) {
    return Positioned(top: top, left: left, right: right, bottom: bottom, child: Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(opacity))));
  }

  void _showModernPasswordDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    final passwordController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
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
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: colorScheme.onSurface),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tr.identity_verification_input,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.6)),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: tr.current_password,
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                    prefixIcon: Icon(Icons.password_rounded, size: 20, color: colorScheme.primary.withOpacity(0.5)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5))),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(tr.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: isLoading ? null : () async {
                  setStateDialog(() => isLoading = true);
                  final isCorrect = await context.read<AuthCubit>().verifyPasswordSilently(passwordController.text);
                  if (isCorrect) {
                    Navigator.pop(context);
                    this.setState(() => _isEditable = true);
                  } else {
                    setStateDialog(() => isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr.incorrect_password),
                        backgroundColor: colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(tr.verify, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }
}