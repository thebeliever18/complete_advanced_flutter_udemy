import 'dart:async';

import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class OnBoardingViewModel extends BaseViewModel with  OnBoardingViewModelInputs,OnBoardingViewModelOutputs{
  //stream controller
  final StreamController streamController = StreamController<SliderViewObject>();
  
  late final List<SliderObjectModel> _list ;
  int _currentIndex = 0;


  //inputs
  @override
  void dispose() {
    streamController.close();
  }

  @override
  void start() {
   _list = _getSliderObject();
   //send this slider data to our view
   _postDataToView();

  }
  
  @override
  int goNext() {
    int nextIndex = _currentIndex ++; //+1
    if(nextIndex >= _list.length){
      _currentIndex = 0;
    }
    return _currentIndex;
  }
  
  @override
  int goPrevious() {
    
    int previousIndex = _currentIndex --; //-1
    if(previousIndex == -1){
      _currentIndex = _list.length-1;
    }
   return _currentIndex;
  }
  
  @override
  void onPageChanged(int index) {
   _currentIndex = index;
   _postDataToView();
  }
  
  @override
  Sink get inputSliderViewObject => streamController.sink;
  
  //outputs
  @override
   Stream<SliderViewObject> get outputSliderViewObject => streamController.stream.map((slideViewObject) => slideViewObject);

  //private functions
  List<SliderObjectModel> _getSliderObject()=>[

    SliderObjectModel(AppStrings.onBoardingTitle1.tr(),AppStrings.onBoardingSubTitle1.tr(),ImageAssets.onboardingLogo1),
    SliderObjectModel(AppStrings.onBoardingTitle2.tr(),AppStrings.onBoardingSubTitle2.tr(),ImageAssets.onboardingLogo2),
    SliderObjectModel(AppStrings.onBoardingTitle3.tr(),AppStrings.onBoardingSubTitle3.tr(),ImageAssets.onboardingLogo3),
    SliderObjectModel(AppStrings.onBoardingTitle4.tr(),AppStrings.onBoardingSubTitle4.tr(),ImageAssets.onboardingLogo4),

   ];

   _postDataToView(){
    inputSliderViewObject.add(SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
   }
}

//inputs mean the orders that our view model will recieve from our view
abstract class OnBoardingViewModelInputs {
  void goNext();  //when user clicks on right arrow or swipe left
  void goPrevious();  //when user clicks on left arrow or swipe right
  void onPageChanged(int index);

  Sink get inputSliderViewObject; //this is the way to add data to the stream .. stream input
}

//outputs mean data or results that will be sent from our view model to our view
abstract class OnBoardingViewModelOutputs{
  Stream<SliderViewObject> get outputSliderViewObject;
}


class SliderViewObject{
  
  SliderObjectModel sliderObjectModel;
  int numOfSlides;
  int currentIndex;

  SliderViewObject(
  this.sliderObjectModel,
  this.numOfSlides,
  this.currentIndex);
}