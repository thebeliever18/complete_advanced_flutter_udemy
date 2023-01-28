import 'dart:async';

import 'package:complete_advanced_flutter/app/functions.dart';
import 'package:complete_advanced_flutter/domain/usecase/forget_password_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';

class ForgotPasswordViewModel extends BaseViewModel with ForgetPasswordViewModelInput,ForgetPasswordViewModelOutput{

  final StreamController _emailStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();

  final ForgotPasswordUseCase _forgotPasswordUseCase;
  ForgotPasswordViewModel(this._forgotPasswordUseCase); 
  var email = '';

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  forgetPassword() async{
    inputState.add(
      LoadingState(stateRendererType: StateRendererType.popUpLoadingState));

      (await _forgotPasswordUseCase.execute(email)).fold(
        (failure) {
          inputState.add(
            ErrorState(StateRendererType.popUpErrorState, failure.message)
          );
        }, 
        (supportMessage) {
          inputState.add(SuccessState(supportMessage));
        });
  }

  @override
  setEmail(String email){
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  //output
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  Stream<bool> get outputIsEmailValid => _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputValid => _isAllInputValidStreamController.stream.map((isAllInputValid) => _isAllInputValid());

  _isAllInputValid(){
    return isEmailValid(email);
  }

  _validate(){
    inputIsAllInputValid.add(null);
  }
  
 

}

abstract class ForgetPasswordViewModelInput{
  forgetPassword();
  setEmail(String email);

  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract class ForgetPasswordViewModelOutput{
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}