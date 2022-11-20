import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_flutter_app/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../resources/strings_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final ForgotPasswordViewModel _viewModel =
      instance<ForgotPasswordViewModel>();

  bind() {
    _viewModel.start();
    _emailTextEditingController.addListener(
        () => _viewModel.setEmail(_emailTextEditingController.text));
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.forgotPassword();
                }) ??
                _getContentWidget();
          }),
    );
  }

  Widget _getContentWidget() {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: EdgeInsets.only(top: AppPadding.p100H),
      color: ColorManager.white,
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Image(image: AssetImage(ImageAssets.splashLogo)),
            SizedBox(
              height: AppSize.s20H,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppPadding.p28W,
                right: AppPadding.p28W,
              ),
              child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.emailHint.tr(),
                        labelText: AppStrings.emailHint.tr(),
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.invalidEmail.tr(),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: AppSize.s20H,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: AppPadding.p28W,
                right: AppPadding.p28W,
              ),
              child: StreamBuilder<bool>(
                  stream: _viewModel.outputIsAllInputValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: AppSize.sInfinity,
                      height: AppSize.s40H,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () => _viewModel.forgotPassword()
                              : null,
                          child: Text(
                            AppStrings.resetPassword.tr(),
                            style: TextStyle(fontSize: AppSize.s20SP),
                          )),
                    );
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
