import 'package:complete_advanced_flutter/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter/data/data_source/remote_data_source.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/data/network/error_handler.dart';
import 'package:complete_advanced_flutter/data/network/network_info.dart';
import 'package:complete_advanced_flutter/data/request/request.dart';
import 'package:complete_advanced_flutter/data/network/failure.dart';
import 'package:complete_advanced_flutter/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';

class RepositoryImpl extends Repository{
  RemoteDataSource _remoteDataSource;
  NetworkInfo _networkInfo;
  LocalDataSource _localDataSource;
  RepositoryImpl(this._remoteDataSource,this._networkInfo,this._localDataSource);
  @override
  Future<Either<Failure,Authentication>> login(LoginRequest loginRequest) async{
    if(await _networkInfo.isConnected){
      try{
        final response = await _remoteDataSource.login(loginRequest);
      if(response.statusCode == ApiInternalStatus.success){
        return Right(response.toDomain());
      }else{
        return Left(Failure(response.statusCode ?? ApiInternalStatus.failure, 
        response.message??ResponseMessage.unknown));
      }
      }catch(error){
        return Left(ErrorHandler.handle(error).failure);
      }
      
    }else{
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
  
  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async{
    if(await _networkInfo.isConnected){
      try{
        final response = await _remoteDataSource.register(registerRequest);
      if(response.statusCode == ApiInternalStatus.success){
        return Right(response.toDomain());
      }else{
        return Left(Failure(response.statusCode ?? ApiInternalStatus.failure, 
        response.message??ResponseMessage.unknown));
      }
      }catch(error){
        return Left(ErrorHandler.handle(error).failure);
      }
      
    }else{
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
  
  @override
  Future<Either<Failure, String>> forgetPassword(String email) async{
     if(await _networkInfo.isConnected){
      try{
        final response = await _remoteDataSource.forgetPassword(email);
      if(response.statusCode == ApiInternalStatus.success){
        return Right(response.toDomain());
      }else{
        return Left(Failure(response.statusCode ?? ApiInternalStatus.failure, 
        response.message??ResponseMessage.unknown));
      }
      }catch(error){
        return Left(ErrorHandler.handle(error).failure);
      }
      
    }else{
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
  
  @override
  Future<Either<Failure, HomeObject>> getHome() async{
    try{
      //get from cache
      final response = await _localDataSource.getHome();
      return Right(response.toDomain());
    }catch(cacheError){
      //we have cache error so we should call api
      if(await _networkInfo.isConnected){
      try{
        final response = await _remoteDataSource.getHome();
      if(response.statusCode == ApiInternalStatus.success){

        //save reponse to cache/local data source
        _localDataSource.saveHomeToCache(response);
        return Right(response.toDomain());
      }else{
        return Left(Failure(response.statusCode ?? ApiInternalStatus.failure, 
        response.message??ResponseMessage.unknown));
      }
      }catch(error){
        return Left(ErrorHandler.handle(error).failure);
      }
      
    }else{
      return Left(DataSource.noInternetConnection.getFailure());
    }
    }
    
  }
  
  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async{
   try{
      //get from cache
      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());
    }catch(cacheError){
      //we have cache error so we should call api
      if(await _networkInfo.isConnected){
      try{
        final response = await _remoteDataSource.getStoreDetails();
      if(response.statusCode == ApiInternalStatus.success){

        //save reponse to cache/local data source
        _localDataSource.saveStoreDetailsToCache(response);
        return Right(response.toDomain());
      }else{
        return Left(Failure(response.statusCode ?? ApiInternalStatus.failure, 
        response.message??ResponseMessage.unknown));
      }
      }catch(error){
        return Left(ErrorHandler.handle(error).failure);
      }
      
    }else{
      return Left(DataSource.noInternetConnection.getFailure());
    }
    }
  }
}