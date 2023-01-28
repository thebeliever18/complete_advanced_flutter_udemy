import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/login/login_view.dart';
import 'package:complete_advanced_flutter/presentation/onboarding/onboarding_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final OnBoardingViewModel _onBoardingViewModel = OnBoardingViewModel();
    final AppPreferences _appPreferences = instance<AppPreferences>();
   @override
   void initState() {
    _bind();
     super.initState();
   }

  _bind(){
    _appPreferences.setOnBoardingScreenViewed();
    _onBoardingViewModel.start();
  }

  @override
  void dispose() {
    _onBoardingViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _onBoardingViewModel.outputSliderViewObject,
      builder: (context,snapShot){
        return _getContentWidget(snapShot.data);
    });
  }

Widget _getContentWidget(SliderViewObject? data){
  if(data==null){
    return const SizedBox.shrink();
  }else {

  
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
        
        itemCount: data.numOfSlides,
        onPageChanged: (index){
          _onBoardingViewModel.onPageChanged(index);
        },
    
        itemBuilder: (context,i){
          return OnBoardingPage(data.sliderObjectModel);
        }),
        bottomSheet: Container(
          color: ColorManager.white,
          height: AppSize.s100,
          child: Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: (){
                    
                    // Navigator.of(context).push(MaterialPageRoute<void>(
                    //   builder: (BuildContext context) => const LoginView()
                    // ));

                    Navigator.pushNamed(context, Routes.loginRoute);
                  }, 
                child:  Text(
                  AppStrings.skip,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.subtitle2
                  ).tr()),
              ),
              //add layout for indicator and layout
              _getBottomSheetWidget(data)
            ],
          ),
        ),
    );
  }
}
Widget _getBottomSheetWidget(SliderViewObject? data){
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
              _onBoardingViewModel.goPrevious(), 
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
          for(int i =0;i<data!.numOfSlides;i++)
            Padding(padding: const EdgeInsets.all(AppPadding.p8),
            child: _getProperCircle(i,data.currentIndex),
            )
        ],
      ),


      //right
      Padding(
        padding: const EdgeInsets.all(AppPadding.p14),
        child: GestureDetector(
          onTap: (){
            _pageController.animateToPage(
              _onBoardingViewModel.goNext(), 
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

  Widget _getProperCircle(int index, int _currentIndex) {
    if(_currentIndex==index){
      return Icon(Icons.circle_outlined,size: 10.0,color: Colors.white,);
    }else{
      return SvgPicture.asset(ImageAssets.circleFilled);
    }
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

