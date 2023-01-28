import 'dart:async';
import 'dart:ffi';

import 'package:analyzer/dart/element/type.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInputs,HomeViewModelOutputs{
  HomeUseCase homeUseCase;
  HomeViewModel(this.homeUseCase);

  final StreamController _dataStreamController = BehaviorSubject<HomeViewObject>();
  // final StreamController _servicesStreamController = BehaviorSubject<List<Services>>();
  // final StreamController _storesStreamController = BehaviorSubject<List<Stores>>();

  //inputs
  @override
  void start() {
    _getHome();
  }

  _getHome() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState,));

    (await homeUseCase.execute(VoidType)).fold((failure) {
      inputState.add(ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (homeObject) {
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.stores, homeObject.data.services, homeObject.data.banners));
      // inputBanners.add(homeObject.data.banners);
      // inputStores.add(homeObject.data.stores);
      // inputServices.add(homeObject.data.services);
    }); 

  }

  @override
  void dispose(){
    _dataStreamController.close();
    // _servicesStreamController.close();
    // _storesStreamController.close();
  }
  
  @override
  Sink get inputHomeData => _dataStreamController.sink;
  
  // @override
  // Sink get inputServices => _servicesStreamController.sink;
  
  // @override
  // Sink get inputStores => _storesStreamController.sink;
  

  //outputs
  @override
  Stream<HomeViewObject> get outputHomeData => 
  _dataStreamController.stream.map((data) => data);
  
  // @override
  // Stream<List<Services>> get outputServices => 
  // _servicesStreamController.stream.map((services) => services);
  
  // @override
  // Stream<List<Stores>> get outputStores => _storesStreamController.stream.map((stores) => stores);

}

abstract class HomeViewModelInputs{
  // Sink get inputStores;
  // Sink get inputServices;
  // Sink get inputBanners;
  Sink get inputHomeData;
}


abstract class HomeViewModelOutputs{
  // Stream<List<Stores>> get outputStores;
  // Stream<List<Services>> get outputServices;
  // Stream<List<Banners>> get outputBanners;
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject{
  List<Stores> stores;
  List<Services> services;
  List<Banners> banners;

  HomeViewObject(this.stores,this.services,this.banners);
}