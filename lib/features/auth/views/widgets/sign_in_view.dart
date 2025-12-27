import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/extenstions/custom_colors_extenstions.dart';
import 'package:social_mate/core/utils/extenstions/theme_extenstion.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/auth/views/widgets/custom_container.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key, required this.onGoToTab});
  final Function(int) onGoToTab;

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "E-mail"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter email";
                    }

                    if (!value.contains("@")) {
                      return "please enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter paswword";
                    }

                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.04),
                BlocConsumer<AuthCubit, AuthState>(
                  bloc: authCubit,
                  listenWhen: (previous, current) =>
                      current is AuthFailure || current is AuthSuccess,
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.of(context).pushNamed(AppRoutes.homePageRoute);
                    }
                    if (state is AuthFailure) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                      debugPrint(state.message);
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is AuthLoading ||
                      current is AuthSuccess ||
                      current is AuthFailure,
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return MainButton(isLoading: true);
                    }
                    return MainButton(
                      child: AutoSizeText(
                        "Login",
                        style: AppTextStyles.sMedium,
                      ),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authCubit.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          _emailController.clear();
                          _passwordController.clear();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {},
              child: AutoSizeText(
                "Forgot password?",

                style: AppTextStyles.sSemiBold.copyWith(
                  color: Theme.of(context).customColors.secondaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.07),
          //sign in with google and facebook
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AutoSizeText(
                  "Or sign in with",
                  style: AppTextStyles.mMedium,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          CustomContainer(
            imgPath: AppConstants.googlePath,
            title: "Google",
            onTap: () async => await authCubit.nativeGoogleSignIn(),
          ),
          SizedBox(height: size.height * 0.04),
          Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: () => widget.onGoToTab(1),
                child: AutoSizeText.rich(
                  maxLines: 1,

                  TextSpan(
                    text: "Don't have an account? ",
                    style: AppTextStyles.sMedium.copyWith(
                      color: Theme.of(context).customColors.secondaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: AppTextStyles.mSemiBold.copyWith(
                          color: context.isDarkMode
                              ? AppColors.linkColor
                              : AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
