import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:malaz/presentation/global_widgets/custom_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../../core/config/color/app_color.dart';
import '../../../cubits/auth/auth_cubit.dart';

class UnderReview extends StatefulWidget {
  const UnderReview({Key? key}) : super(key: key);

  @override
  State<UnderReview> createState() => _UnderReviewState();
}

class _UnderReviewState extends State<UnderReview> {
  Timer? _timer;
  final int _intervalSeconds = 10; /// We check every 10 seconds
  bool modalProgressHUDisOn = false;

  @override
  void initState() {
    super.initState();
    /// Immediate call first
    _checkNow();

    /// Set up a periodic timer for verification
    _timer = Timer.periodic(Duration(seconds: _intervalSeconds), (_) {
      _checkNow();
    });
  }


  Future<void> _checkNow() async {
    if (modalProgressHUDisOn) return;
    setState(() => modalProgressHUDisOn = true);

    try {
      await context.read<AuthCubit>().checkAuth();

       await Future.delayed(const Duration(milliseconds: 400));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification error : $e')),
        );
      }
    } finally {
      if (!mounted) return;
      setState(() => modalProgressHUDisOn = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.white,
      inAsyncCall: modalProgressHUDisOn,
      child: Scaffold(
        backgroundColor: ColorScheme.of(context).surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                  child: Icon(
                    Icons.hourglass_top_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
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
                    onPressed: modalProgressHUDisOn ? null : _checkNow, /// Disable the button during execution
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
    );
  }
}
