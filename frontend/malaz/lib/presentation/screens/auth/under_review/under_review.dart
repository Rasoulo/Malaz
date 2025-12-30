import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/global_widgets/custom_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/config/color/app_color.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cubits/auth/auth_cubit.dart';

class UnderReview extends StatefulWidget {
  const UnderReview({Key? key}) : super(key: key);

  @override
  State<UnderReview> createState() => _UnderReviewState();
}

class _UnderReviewState extends State<UnderReview> {
  Timer? _timer;
  bool modalProgressHUDisOn = false;

  @override
  void initState() {
    super.initState();
    _startSilentTimer();
  }

  void _startSilentTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final state = context.read<AuthCubit>().state;
      if (state is AuthPending) {
        context.read<AuthCubit>().silentRoleCheck();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          }
        },
        child:ModalProgressHUD(
          color: Colors.white,
          inAsyncCall: modalProgressHUDisOn,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShaderMask(
                  shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 80,
                    color: Colors.yellow,
                  ),
                ),
                  const SizedBox(
                  height: 16,
                ),
                  ShaderMask(
                  shaderCallback: (bounds) => AppColors.premiumGoldGradient.createShader(bounds),
                  child: Text(
                    'Your request is under review by the application administrators. We will notify you when it is approved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                  const SizedBox(
                  height: 100,
                ),
                  SizedBox(
                  width: 250,
                  height: 50,
                  child: CustomButton(
                    text: 'Check Now',
                    onPressed: modalProgressHUDisOn ? null : _startSilentTimer, /// Disable the button during execution
                  ),
                ),
                  const SizedBox(
                  height: 14,
                ),
                  SizedBox(
                  width: 250,
                  height: 50,
                  child: CustomButton(
                    text: 'Log Out',
                    onPressed: () => context.read<AuthCubit>().logout(),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
