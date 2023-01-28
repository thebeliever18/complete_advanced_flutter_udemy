import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:complete_advanced_flutter/presentation/store_details/store_details_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  @override
  void initState() {
    super.initState();
    _bind();
  }

  _bind() {
    _viewModel.start();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title:  Text(AppStrings.storeDetails.tr()),
        elevation: AppSize.s0,
        iconTheme: IconThemeData(color: ColorManager.white),
        backgroundColor: ColorManager.primary,
        centerTitle: true,
      ),
        body: StreamBuilder<FlowState>(
            stream: _viewModel.outputState,
            builder: ((context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, contentScreenWidget(), () {
                    _viewModel.start();
                  }) ??
                  Container();
            })));
  }

  Widget contentScreenWidget() {
    return Container(
      constraints: BoxConstraints.expand(),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: StreamBuilder<StoreDetails>(
          stream: _viewModel.outputStoreDetails,
          builder: (context,snapshot){
            return _getItems(snapshot.data);
          },),
      ),
    );
  }
  
  Widget _getItems(StoreDetails? data) {
    if(data != null){
      return Column(
        children: [
          Center(
            child: Image.network(
              data.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,),
          ),
          _getSection(AppStrings.details.tr()),
          _getInfoText(data.details),
          _getSection(AppStrings.services.tr()),
          _getInfoText(data.services),
          _getSection(AppStrings.about.tr()),
          _getInfoText(data.about)
        ],
      );
    }else{
      return Container();
    }
  }
  
  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Text(title,style: Theme.of(context).textTheme.headline3,),
    );
  }
  
  Widget _getInfoText(String info) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Text(info,style: Theme.of(context).textTheme.bodyText2,),
    );
  }
}
