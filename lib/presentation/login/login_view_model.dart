import 'dart:async';

import 'package:complete_advanced_flutter/domain/usecase/login_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

class LoginViewModel extends BaseViewModel with LoginViewModelInputs,LoginViewModelOutputs{

  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<String>();
  var loginObject = LoginObject('','');

  LoginUseCase? _loginUseCase;
  LoginViewModel(this._loginUseCase);


  //inputs
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isAllInputValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    //view tells state renderer, please show the content of the screen
    inputState.add(ContentState());
  }
  
  @override
  Sink get inputPassword => _passwordStreamController.sink;
  
  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputIsAllInputsValid => _isAllInputValidStreamController.sink;
  
  @override
  login() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.popUpLoadingState));
    (await _loginUseCase!.execute(LoginUseCaseInput(loginObject.userName,loginObject.password)))
    .fold((failure) {
        inputState.add(ErrorState(
          StateRendererType.popUpErrorState,failure.message
          ,
          ));
    }, (data) {
        inputState.add(ContentState());

      //navigate to main screen after the login
      isUserLoggedInSuccessfullyStreamController.add('token--abcdefgh');
      
    });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password); //data class operation same as kotlin
    _validate();
  }
  
  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName); //data class operation same as kotlin
    _validate();
  }

  _validate(){
    inputIsAllInputsValid.add(null);
  }
  
  @override
  Stream<bool> get outputIsPasswordValid => 
  _passwordStreamController.stream.asBroadcastStream().map((password) => _isPasswordValid(password));
  
  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.
  stream.asBroadcastStream().map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outputIsAllInputsValid => _isAllInputValidStreamController.stream.asBroadcastStream().map((_) => _isAllInputsValid());
  
  bool _isUserNameValid(String userName){
    return userName.isNotEmpty;
  }
  
  bool _isPasswordValid(String password){
    return password.isNotEmpty;
  }

  bool _isAllInputsValid(){
    return _isUserNameValid(loginObject.userName) && _isPasswordValid(loginObject.password);
  }
  
  
  
 
  
  

}

abstract class LoginViewModelInputs{
  //three functions for actions
  setUserName(String userName);
  setPassword(String password);
  login();

  //two sinks for streams
  Sink get inputUserName;
  Sink get inputPassword;

  Sink get inputIsAllInputsValid;
}

abstract class LoginViewModelOutputs{
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsAllInputsValid;
}