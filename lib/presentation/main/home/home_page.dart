import 'package:carousel_slider/carousel_slider.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter/presentation/main/home/home_view_mode.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeViewModel viewModel = instance<HomeViewModel>();

  _bind(){
    viewModel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Center(
    child: 
    SingleChildScrollView(
      child: StreamBuilder<FlowState>(
        stream: viewModel.outputState,
        builder: (context,snapshot){
          return snapshot.data?.getScreenWidget(context, contentScreenWidget(), (){
            viewModel.start();
          }) ?? Container(); 
      }
    )));
  }
  
  Widget contentScreenWidget() {
    return StreamBuilder<HomeViewObject>(
      stream: viewModel.outputHomeData,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getBanner(snapshot.data?.banners),
            _getSection(AppStrings.services.tr()),
            _getServicesWidget(snapshot.data?.services),
            _getSection(AppStrings.stores.tr()),
            _getStoresWidget(snapshot.data?.stores)
          ],
        );
      }
    );
  }
  
  // Widget _getBannersCarousel() {
  //   return StreamBuilder<List<Banners>>(
  //     stream: viewModel.outputBanners,
  //     builder: (context,snapshot){
  //       return _getBanner(snapshot.data);
  //     });
  // }
  
  Widget _getSection(String title) {
    return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Text(title,style: Theme.of(context).textTheme.headline3,)
    );
  }
  
  // Widget _getServices() {
  //   return StreamBuilder<List<Services>>(
  //     stream: viewModel.outputServices,
  //     builder: ((context, snapshot) {
  //       return _getServicesWidget(snapshot.data);
  //     }));
  // }
  
  // Widget _getStores() {
  //   return StreamBuilder<List<Stores>>(
  //     stream: viewModel.outputStores,
  //     builder: ((context, snapshot) {
  //       return _getStoresWidget(snapshot.data);
  //   }));
  // }
  
  Widget _getBanner(List<Banners>? data) {
    if(data!=null){
      return CarouselSlider(
      items: data.map((banner) => 
      SizedBox(
        width: double.infinity,
        child: Card(
          elevation: AppSize.s1_5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
            side: BorderSide(
              color: ColorManager.white,
              width: AppSize.s1_5
            )
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.s12),
            child: Image.network(banner.image,fit: BoxFit.cover,),
          )),
      )).toList(), 
      options: CarouselOptions(
        height: AppSize.s180,
        autoPlay: true,
        enableInfiniteScroll: true,
        enlargeCenterPage: true
      ));
    }else{
      return Container();
    }
  }
  
  Widget _getServicesWidget(List<Services>? services) {
    if(services != null){
      return Padding(padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
      child: Container(
        height: AppSize.s140,
        margin: const EdgeInsets.symmetric(vertical: AppMargin.m8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: 
            services.map((services) => Card(
              elevation: AppSize.s4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                side: BorderSide(color: ColorManager.white,width: AppSize.s1_5)
              ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.s12),
              child: Image.network(services.image,fit: BoxFit.cover,
              height: AppSize.s100,
              width: AppSize.s100,
              ),

            ),
            Padding(padding: const EdgeInsets.only(top: AppPadding.p8),
            child: Align(
              alignment: Alignment.center,
              child: Text(services.title,textAlign: TextAlign.center,),
            )
            )
          ],
        ),
      )).toList()
          
        )
      ),
      );
      
      
    }else{  
      return Container();
    }
  }
  
  Widget _getStoresWidget(List<Stores>? stores) {
    if(stores != null){
      return Padding(padding: EdgeInsets.all(AppPadding.p12),
      child: Flex(
        direction: Axis.vertical,
        children: [
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: AppSize.s8,
            crossAxisSpacing: AppSize.s8,
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(stores.length, (index) {
              return InkWell(
                onTap: (){
                  Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                },
                child: Card(
                  elevation: AppSize.s4,
                  child: Image.network(stores[index].image,fit: BoxFit.cover,),
                )
              );
            }),
          )
        ]),
      );
    }else{
      return Container();
    }
  }
  
}