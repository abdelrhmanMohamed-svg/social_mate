import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/views/widgets/main_button.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/auth/views/widgets/custom_container.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key, required this.onGoToTab});
  final Function(int) onGoToTab;

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
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
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "your name"),
                ),
                SizedBox(height: size.height * 0.02),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "E-mail"),
                ),
                SizedBox(height: size.height * 0.02),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter password",
                  ),
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
                      child: Text("Join Now"),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authCubit.signUpWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text,
                          );
                          _emailController.clear();
                          _passwordController.clear();
                          _nameController.clear();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.04),
          //sign up with google and facebook
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Or sign up  with",
                  style: Theme.of(context).textTheme.bodyLarge,
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
                onTap: () => widget.onGoToTab(0),
                child: Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: "Sign in",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
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
