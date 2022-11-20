import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_flutter_app/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../app/app_prefs.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = instance<LoginViewModel>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _viewModel.start(); // tell viewmodel, start your job
    _userNameController
        .addListener(() => _viewModel.setUserName(_userNameController.text));
    _passwordController
        .addListener(() => _viewModel.setPassword(_passwordController.text));

    _viewModel.isUserLoggedSuccessfullyStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        // navigate to main screen
        SchedulerBinding.instance?.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.login();
                }) ??
                _getContentWidget();
          }),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: EdgeInsets.only(top: AppPadding.p100H),
      child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: AppSize.s150H,
                    child: const Center(
                        child: Image(
                      image: AssetImage(ImageAssets.splashLogo),
                    )),
                  ),
                  SizedBox(
                    height: AppSize.s10H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: StreamBuilder<bool>(
                        stream: _viewModel.outIsUserNameValid,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _userNameController,
                            decoration: InputDecoration(
                              hintText: AppStrings.userName.tr(),
                              labelText: AppStrings.userName.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.userNameInvalid.tr(),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: AppSize.s10H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: StreamBuilder<bool>(
                        stream: _viewModel.outIsPasswordValid,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              hintText: AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
                              errorText: (snapshot.data ?? true)
                                  ? null
                                  : AppStrings.passwordInvalid.tr(),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: AppSize.s10H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: StreamBuilder<bool>(
                        stream: _viewModel.outIsAreAllDataValid,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: AppSize.sInfinity,
                            height: AppSize.s40H,
                            child: ElevatedButton(
                                onPressed: (snapshot.data ?? false)
                                    ? () {
                                        _viewModel.login();
                                      }
                                    : null,
                                child: Text(
                                  AppStrings.login.tr(),
                                  style: TextStyle(fontSize: AppSize.s20SP),
                                )),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppPadding.p8H,
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.forgotPasswordRoute);
                          },
                          child: Text(
                            AppStrings.forgetPassword.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.registerRoute);
                          },
                          child: Text(
                            AppStrings.registerText.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
