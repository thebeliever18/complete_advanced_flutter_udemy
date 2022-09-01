import 'package:complete_advanced_flutter/domain/slider_object_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {


  final PageController _pageController= PageController(initialPage: 0);
    
   

  @override
  void dispose() {
    // TODO: viewModel.dispose()
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor:ColorManager.white,
        elevation: AppSize.s0,
        systemOverlayStyle: SystemUiOverlayStyle(
         statusBarColor: ColorManager.white,
         statusBarBrightness: Brightness.dark,
         statusBarIconBrightness: Brightness.dark
        )
      ),
      body: PageView.builder(
        controller: _pageController,
        
        itemCount: _list.length,
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
    
        itemBuilder: (context,i){
          return OnBoardingPage(_list[i]);
        }),
        bottomSheet: Container(
          color: ColorManager.white,
          height: AppSize.s100,
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: (){}, 
                child:  Text(
                  AppStrings.skip,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.subtitle2
                  )),
              ),
              //add layout for indicator and layout
              _getBottomSheetWidget()
            ],
          ),
        ),
    );
  }


Widget _getBottomSheetWidget(){
  return Container(
    color: ColorManager.primary,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //left
      Padding(
        padding: const EdgeInsets.all(AppPadding.p14),
        child: GestureDetector(
          onTap: (){
          
            _pageController.animateToPage(
              _getPreviousIndex(), 
            duration: const Duration(milliseconds: DurationConstant.d300), 
            curve: Curves.bounceInOut);  
          
          },
          child: SizedBox(
            height: AppSize.s20,
            width: AppSize.s20,
            child: SvgPicture.asset(ImageAssets.leftArrow),
          ),
        ),
      ),

      //circle
      Row(
        children: [
          for(int i =0;i<_list.length;i++)
            Padding(padding: const EdgeInsets.all(AppPadding.p8),
            child: _getProperCircle(i),
            )
        ],
      ),


      //right
      Padding(
        padding: const EdgeInsets.all(AppPadding.p14),
        child: GestureDetector(
          onTap: (){
            _pageController.animateToPage(_getNextIndex(), 
            duration: const Duration(
              milliseconds: DurationConstant.d300
            ), 
            curve: Curves.bounceInOut);
          },
          child: SizedBox(
            height: AppSize.s20,
            width: AppSize.s20,
            child: SvgPicture.asset(ImageAssets.rightArrow),
          ),
        ),
      )
    ],),
  );
}

  Widget _getProperCircle(int index) {
    if(_currentIndex==index){
      return Icon(Icons.circle_outlined,size: 10.0,color: Colors.white,);
    }else{
      return SvgPicture.asset(ImageAssets.circleFilled);
    }
  }
  
  
  int _getPreviousIndex() {
    int previousIndex = _currentIndex --; //-1
    if(previousIndex == -1){
      _currentIndex = _list.length-1;
    }
    return _currentIndex; 
  }

  int _getNextIndex() {
    int nextIndex = _currentIndex ++; //+1
    if(nextIndex >= _list.length){
      _currentIndex = 0;
    }
    return _currentIndex; 
  }
}



class OnBoardingPage extends StatelessWidget {
  SliderObjectModel _sliderObject;
  OnBoardingPage(this._sliderObject,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(_sliderObject.title,textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(_sliderObject.subTitle,textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const SizedBox(
          height: AppSize.s60,
        ),

        //image widget
        SvgPicture.asset(_sliderObject.image)
      ],
    );
  }
}

