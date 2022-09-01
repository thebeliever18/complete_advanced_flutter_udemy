import 'dart:async';

import 'package:complete_advanced_flutter/domain/slider_object_model.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel with  OnBoardingViewModelInputs,OnBoardingViewModelOutputs{
  //stream controller
  final StreamController streamController = StreamController<SlideViewObject>();
  
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
  void goNext() {
    int nextIndex = _currentIndex ++; //+1
    if(nextIndex >= _list.length){
      _currentIndex = 0;
    }
    _postDataToView();
  }
  
  @override
  void goPrevious() {
    
    int previousIndex = _currentIndex --; //-1
    if(previousIndex == -1){
      _currentIndex = _list.length-1;
    }
    _postDataToView();
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
  Stream<SlideViewObject> get outputSliderViewObject => streamController.stream.map((slideViewObject) => slideViewObject);

  //private functions
  List<SliderObjectModel> _getSliderObject()=>[

    SliderObjectModel(AppStrings.onBoardingTitle1,AppStrings.onBoardingSubTitle1,ImageAssets.onboardingLogo1),
    SliderObjectModel(AppStrings.onBoardingTitle2,AppStrings.onBoardingSubTitle2,ImageAssets.onboardingLogo2),
    SliderObjectModel(AppStrings.onBoardingTitle3,AppStrings.onBoardingSubTitle3,ImageAssets.onboardingLogo3),
    SliderObjectModel(AppStrings.onBoardingTitle4,AppStrings.onBoardingSubTitle4,ImageAssets.onboardingLogo4),

   ];

   _postDataToView(){
    inputSliderViewObject.add(SlideViewObject(_list[_currentIndex], _list.length, _currentIndex));
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
  Stream<SlideViewObject> get outputSliderViewObject;
}


class SlideViewObject{
  
  SliderObjectModel sliderObjectModel;
  int numOfSlides;
  int currentIndex;

  SlideViewObject(
  this.sliderObjectModel,
  this.numOfSlides,
  this.currentIndex);
}