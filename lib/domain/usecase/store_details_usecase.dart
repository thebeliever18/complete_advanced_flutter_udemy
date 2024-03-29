import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:complete_advanced_flutter/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class StoreDetailsUseCase extends BaseUseCase<void,StoreDetails>{
   Repository repository;
  StoreDetailsUseCase(this.repository);
  @override
  Future<Either<Failure, StoreDetails>> execute(void input){
   return repository.getStoreDetails();
  }

}