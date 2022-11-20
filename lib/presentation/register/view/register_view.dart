import 'dart:io';

import 'package:advanced_flutter_app/app/constants.dart';
import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/app_prefs.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();

  final ImagePicker _imagePicker = instance<ImagePicker>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberEditingController =
      TextEditingController();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _viewModel.start();
    _userNameEditingController.addListener(() {
      _viewModel.setUserName(_userNameEditingController.text);
    });

    _emailEditingController.addListener(() {
      _viewModel.setEmail(_emailEditingController.text);
    });

    _passwordEditingController.addListener(() {
      _viewModel.setPassword(_passwordEditingController.text);
    });

    _mobileNumberEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberEditingController.text);
    });

    _viewModel.isUserRegisteredSuccessfullyStreamController.stream
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
      appBar: AppBar(
        elevation: AppSize.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.register();
                }) ??
                _getContentWidget();
          }),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: EdgeInsets.only(top: AppPadding.p8H),
      child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                    child: StreamBuilder<String?>(
                        stream: _viewModel.outputErrorUserName,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _userNameEditingController,
                            decoration: InputDecoration(
                              hintText: AppStrings.userName.tr(),
                              labelText: AppStrings.userName.tr(),
                              errorText: snapshot.data,
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: AppSize.s5H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CountryCodePicker(
                            padding: EdgeInsets.all(AppSize.s0),
                            onChanged: (country) {
                              _viewModel.setCountryCode(
                                  country.dialCode ?? Constants.token);
                            },
                            initialSelection: '+963',
                            favorite: const ['+02', '+963'],
                            showCountryOnly: false,
                            hideMainText: true,
                            showOnlyCountryWhenClosed: true,
                          ),
                        ),
                        Expanded(
                            flex: 4,
                            child: StreamBuilder<String?>(
                              stream: _viewModel.outputErrorMobileNumber,
                              builder: (context, snapshot) {
                                return TextFormField(
                                  keyboardType: TextInputType.phone,
                                  controller: _mobileNumberEditingController,
                                  decoration: InputDecoration(
                                      hintText: AppStrings.mobileNumber.tr(),
                                      labelText: AppStrings.mobileNumber.tr(),
                                      errorText: snapshot.data),
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppSize.s5H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: StreamBuilder<String?>(
                        stream: _viewModel.outputErrorEmail,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailEditingController,
                            decoration: InputDecoration(
                              hintText: AppStrings.emailHint.tr(),
                              labelText: AppStrings.emailHint.tr(),
                              errorText: snapshot.data,
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: AppSize.s5H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: StreamBuilder<String?>(
                        stream: _viewModel.outputErrorPassword,
                        builder: (context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordEditingController,
                            decoration: InputDecoration(
                              hintText: AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
                              errorText: snapshot.data,
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: AppSize.s5H,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppPadding.p28W,
                      right: AppPadding.p28W,
                    ),
                    child: Container(
                      height: AppSize.s40H,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(AppSize.s8R)),
                          border: Border.all(color: ColorManager.grey)),
                      child: GestureDetector(
                        child: _getMediaWidget(),
                        onTap: () {
                          _showPicker(context);
                        },
                      ),
                    ),
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
                        stream: _viewModel.outputAreAllInputsValid,
                        builder: (context, snapshot) {
                          return SizedBox(
                            width: AppSize.sInfinity,
                            height: AppSize.s40H,
                            child: ElevatedButton(
                                onPressed: (snapshot.data ?? false)
                                    ? () {
                                        _viewModel.register();
                                      }
                                    : null,
                                child: Text(
                                  AppStrings.register.tr(),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAccount.tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppStrings.login.tr(),
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

  _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
            child: Wrap(
          children: [
            ListTile(
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(Icons.camera),
              title: Text(AppStrings.photoGallery.tr()),
              onTap: () {
                _imageFromGallery();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(AppStrings.photoCamera.tr()),
              onTap: () {
                _imageFromCamera();
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
      },
    );
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? Constants.empty));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? Constants.empty));
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.p8W,
        right: AppPadding.p8W,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(AppStrings.profilePicture.tr())),
          Flexible(
              child: StreamBuilder<File>(
            stream: _viewModel.outputProfilePicture,
            builder: (context, snapshot) {
              return _imagePicketByUser(snapshot.data);
            },
          )),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc)),
        ],
      ),
    );
  }

  Widget _imagePicketByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      // return image
      return Image.file(image);
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
