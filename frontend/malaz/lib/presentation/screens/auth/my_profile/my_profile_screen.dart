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
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
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
        background: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.premiumGoldGradient2
                ),
              ),

              PositionedDirectional(
                top: -20,
                start: -40,
                child: _buildGlowingKey(180, 0.15, -0.2),
              ),

              PositionedDirectional(
                bottom: 40,
                end: -10,
                child: _buildGlowingKey(140, 0.12, 0.5),
              ),

              PositionedDirectional(
                top: 40,
                end: 80,
                child: _buildGlowingKey(70, 0.12, 2.5),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(25, 100, 25, 40),
                child: Row(
                  children: [
                    _buildAvatarWrapper(user?.id, colorScheme),
                    const SizedBox(width: 20),
                    Expanded(child: _buildProfileHeaderInfo(tr, colorScheme)),
                  ],
                ),
              ),
            ],
          ),
        )
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

  Widget _buildAvatarWrapper(int? userId, ColorScheme colorScheme) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        _tempLocalImagePath != null
            ? Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            gradient: AppColors.premiumGoldGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: Image.file(
              File(_tempLocalImagePath!),
              fit: BoxFit.cover,
            ),
          ),
        )
            : UserProfileImage(
          userId: userId ?? 0,
          radius: 46,
          isPremiumStyle: true,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        ),

        if (_isEditable)
          Positioned(
            bottom: -5,
            right: -5,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryLight, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 18,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileActionsBar(ColorScheme colorScheme, AppLocalizations tr) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionItem(Icons.bookmark_border_rounded, tr.favorites, () => context.push('/favorites'), colorScheme),
          _vDivider(),
          _actionItem(Icons.map_outlined, tr.location, _handleLocationUpdate, colorScheme),
          _vDivider(),
          _actionItem(Icons.verified_user_outlined, tr.edit_profile, () => _requestEditProfile(context), colorScheme, isPrimary: true),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
        border: Border.all(
          color: _isEditable
              ? colorScheme.primary.withOpacity(0.5)
              : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
                icon,
                color: colorScheme.primary,
                size: 22
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: colorScheme.primary.withOpacity(0.8),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  enabled: _isEditable,
                  cursorColor: colorScheme.primary,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: _isEditable ? "Enter $label..." : null,
                    hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ),
          if (_isEditable)
            Icon(Icons.edit_rounded, size: 14, color: colorScheme.primary.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildPasswordField(AppLocalizations tr, ColorScheme colorScheme, AuthState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => state is AuthAuthenticated
          ? context.push('/reset-password', extra: state.user.phone)
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                  Icons.lock_outline_rounded,
                  color: colorScheme.primary,
                  size: 22
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr.password.toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.primary.withOpacity(0.8),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "••••••••",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.primary.withOpacity(0.5),
                size: 20,
              ),
            ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isPrimary
                    ? colorScheme.primary.withOpacity(0.15)
                    : colorScheme.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                  icon,
                  color: colorScheme.primary,
                  size: 24
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                color: isPrimary ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vDivider() => Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.2));

  Widget _buildGlowingKey(double size, double opacity, double rotation) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryLight.withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Image.asset(
            'assets/icons/key_logo.png',
            width: size,
            height: size,
            color: Colors.white,
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
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