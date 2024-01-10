import 'package:egypt_wonders/core/constants/constants.dart';
import 'package:egypt_wonders/core/error_handling/failure_ui_handling.dart';
import 'package:egypt_wonders/core/main_blocs/blocs.dart';
import 'package:egypt_wonders/core/utililty/validations/percise_validation.dart';
import 'package:egypt_wonders/core/utililty/widgets/custom_app_bar.dart';
import 'package:egypt_wonders/features/auth/presentaion/blocs/auth_bloc/auth_bloc.dart';
import 'package:egypt_wonders/features/auth/presentaion/screens/auth_screen.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/field_decoration.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/custom_Button.dart';
import 'package:egypt_wonders/features/common/presentation/widgets/loading_dialog.dart';
import 'package:egypt_wonders/theme.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/ForgotPasswordScreen";

  // Constructor
  ForgotPasswordScreen({super.key});

  // Form key for managing the form state
  final _formKey = GlobalKey<FormState>();

  // TextEditingController for email input
  final TextEditingController emailController = TextEditingController();

  // FocusNode for email input
  final emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OwnTheme.white,
      appBar: CustomAppBar(
          txt: "Reset Password"), // Placeholder AppBar, you may customize it
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
            previous.resetPasswordStatus != current.resetPasswordStatus,
        listener: (context, state) {
          // Handling different states based on resetPasswordStatus
          if (state.resetPasswordStatus == RequestStatus.success) {
            FailureUiHandling.showToast(
              context: context,
              errorMsg: "Email has been sent please check your Email Address",
            );
            Navigator.popUntil(context,
                (route) => route.settings.name == AuthScreen.routeName);
            AuthBloc.get(context).add(ResetRestPassowrdStatusEvent());
          } else if (state.resetPasswordStatus == RequestStatus.loading) {
            LoadingDialog.displayLoadingDialog(context);
          } else if (state.resetPasswordStatus == RequestStatus.failure) {
            Navigator.pop(context);
            FailureUiHandling.showToast(
              context: context,
              errorMsg: "This Email is not registered yet",
            );
            AuthBloc.get(context).add(ResetRestPassowrdStatusEvent());
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container with an image
              Container(
                height: 30.h,
                color: OwnTheme.white,
                width: double.infinity,
                child: LayoutBuilder(builder: (context, constraints) {
                  return Center(
                    child: Image.asset(
                      'assets/images/Egypt.png',
                      height: constraints.maxHeight * 1,
                    ),
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(paddingAll),
                child: Center(
                  child: Text(
                    "Enter Your Email Address",
                    style: OwnTheme.subTitleStyle().copyWith(
                      color: OwnTheme.black,
                    ),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(paddingAll),
                      child: TextFormField(
                        key: const ValueKey('email'),
                        controller: emailController,
                        focusNode: emailFocusNode,
                        cursorColor: OwnTheme.grey,
                        onChanged: (email) {
                          PreciseValidate.email(email);
                        },
                        validator: (email) =>
                            PreciseValidate.email(email ?? ""),
                        decoration: AuthScreensFieldDecoration.fieldDecoration(
                          "Email",
                          Icons.email,
                          context: context,
                        ),
                        style: OwnTheme.bodyTextStyle().copyWith(
                          color: OwnTheme.black,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: CustomButton(
                  label: "Reset Password",
                  onPressed: () => _resetPassword(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to trigger the password reset
  _resetPassword(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    AuthBloc.get(context).add(ResetPasswordEvent(emailController.text.trim()));
  }
}
