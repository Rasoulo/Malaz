import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';

class BuildBranding extends StatelessWidget implements PreferredSizeWidget {
  final bool meta;
  final LottieBuilder? lottie;
  final bool name;
  final bool logo;
  final double width;
  final double height;
  const BuildBranding({super.key})
      : meta = false,
        lottie = null,
        width = 0,
        height = 0,
        logo = true,
        name = true;

  const BuildBranding.noLogo({super.key})
      : meta = false,
        lottie = null,
        width = 0,
        height = 0,
        logo = false,
        name = true;

  const BuildBranding.noName({super.key})
      : meta = false,
        lottie = null,
        width = 0,
        height = 0,
        logo = true,
        name = false;

  const BuildBranding.metaStyle({super.key})
      : meta = true,
        lottie = null,
        width = 0,
        height = 0,
        logo = false,
        name = false;

  const BuildBranding.nameLottie(
      {super.key,
      required LottieBuilder this.lottie,
      required this.width,
      required this.height})
      : meta = false,
        logo = false,
        name = true;

  const BuildBranding.logoLottie(
      {super.key,
      required LottieBuilder this.lottie,
      required this.width,
      required this.height})
      : meta = false,
        logo = true,
        name = false;

  @override
  Widget build(BuildContext context) {
    if (meta) {
      return _BuildMeta();
    }

    if (lottie == null) {
      if (name && logo) {
        return _BuildNormal();
      }
      if (name) {
        return _BuildNoName();
      }
      if (logo) {
        return _BuildNoLogo();
      }
    }

    if (name) {
      return _BuildNameLottie(lottie!, width, height);
    }

    return _BuildLogoLottie(lottie!, width, height);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _BuildMeta extends StatelessWidget {
  const _BuildMeta();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'FROM',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'MALAZ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildNormal extends StatelessWidget {
  const _BuildNormal();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.premiumGoldGradient.createShader(bounds),
        child: Text(l10n.malaz,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold)),
      ),
      const SizedBox(width: 10),
      SizedBox(
          height: 60,
          width: 50,
          child: Image.asset("assets/icons/key_logo.png",
              color: colorScheme.primary)),
    ]);
  }
}

class _BuildNoName extends StatelessWidget {
  const _BuildNoName();
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
        height: 60,
        width: 50,
        child: Image.asset("assets/icons/key_logo.png",
            color: colorScheme.primary));
  }
}

class _BuildNoLogo extends StatelessWidget {
  const _BuildNoLogo();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ShaderMask(
      shaderCallback: (bounds) =>
          AppColors.premiumGoldGradient.createShader(bounds),
      child: Text(l10n.malaz,
          style: const TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
    );
  }
}

class _BuildNameLottie extends StatelessWidget {
  final LottieBuilder lottie;
  final double width;
  final double height;
  const _BuildNameLottie(this.lottie, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      ShaderMask(
        shaderCallback: (bounds) =>
            AppColors.premiumGoldGradient.createShader(bounds),
        child: Text(l10n.malaz,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: height, width: width, child: lottie),
    ]);
  }
}

class _BuildLogoLottie extends StatelessWidget {
  final LottieBuilder lottie;
  final double width;
  final double height;
  const _BuildLogoLottie(this.lottie, this.width, this.height);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          height: height,
          width: width,
          child: Image.asset(
              "assets/icons/key_logo.png",
              color: colorScheme.primary
          )
      ),
      const SizedBox(width: 1),
      SizedBox(height: 75, width: 100, child: lottie),
    ]);
  }
}
