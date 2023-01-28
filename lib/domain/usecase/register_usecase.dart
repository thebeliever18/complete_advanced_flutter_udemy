import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUseCaseInput, Authentication> {
  final Repository _repository;
  RegisterUseCase(this._repository);
  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUseCaseInput input) async {
  
    return await _repository.register(RegisterRequest(
      input.countryMobileCode, input.userName, input.email,
      input.password, input.profilePicture,input.mobileNumber

        ));
  }
}

class RegisterUseCaseInput {
  String countryMobileCode;
  String userName;
  String email;
  String password;
  String profilePicture;
  String mobileNumber;
  RegisterUseCaseInput(this.countryMobileCode, this.userName, this.email,
      this.password, this.profilePicture,this.mobileNumber);
}
