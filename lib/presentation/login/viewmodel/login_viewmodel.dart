import 'dart:async';

import 'package:advanced_flutter_app/domain/usecase/login_usecase.dart';
import 'package:advanced_flutter_app/presentation/base/base_viewmodel.dart';
import 'package:advanced_flutter_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserLoggedSuccessfullyStreamController =
      StreamController<bool>();

  var loginObject = LoginObject("", "");

  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // view model should tell view please show content state

    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputAreAllDataValid => _areAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllDataValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllDataValid.add(null);
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popUpLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRendererType.popUpErrorState, failure.message))
                }, (data) {
      // right -> data(success)
      // content state
      inputState.add(ContentState());
      // navigate to main screen
      isUserLoggedSuccessfullyStreamController.add(true);
    });
  }

  // outputs

  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outIsAreAllDataValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isUserNameValid(loginObject.userName) &&
        _isPasswordValid(loginObject.password);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputAreAllDataValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;

  Stream<bool> get outIsAreAllDataValid;
}
