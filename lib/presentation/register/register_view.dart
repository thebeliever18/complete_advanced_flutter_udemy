import 'dart:io';

import 'package:complete_advanced_flutter/app/app_prefs.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter/presentation/register/register_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final FlCountryCodePicker countryPicker = const FlCountryCodePicker(
    favorites: ['NPL']
  );
   List<CountryCode> availableCountryCodes = <CountryCode>[const CountryCode(
      name:  'United States',
      code: 'US',
      dialCode: '+1',
    )];
  var flagImage;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _mobileTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

 
  @override
  void initState() {
    _bind();
    super.initState();
  }

  void _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      _viewModel.setEmail(_emailTextEditingController.text);
    });
    _mobileTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });

    _viewModel.isUserRegisterInSuccessfullyStreamController.stream.listen((event) {
        //navigate to main screen
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          _appPreferences.setIsUserRegistered();
            Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          elevation: AppSize.s0,
          iconTheme: IconThemeData(color: ColorManager.primary),
          backgroundColor: ColorManager.white,
        ),
        body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return Center(
              child: snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _viewModel.register();
                  }) ??
                  _getContentWidget(),
            );
          },
        ));
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p12),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SvgPicture.asset(ImageAssets.loginLogo),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorUserName,
                  builder: ((context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userNameTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.username.tr(),
                          labelText: AppStrings.username.tr(),
                          errorText: snapshot.data),
                    );
                  }),
                ),
              ),

              Center(child: Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p28,
                left: AppPadding.p18,
                right: AppPadding.p28,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 30,
                      child: GestureDetector(
                        child: StreamBuilder<String?>(
                          stream: _viewModel.outputCountryCode,
                          builder: (context, snapshot) {
                            if(snapshot.data != null){
                              
                              var image = availableCountryCodes.where((element) => element.dialCode == snapshot.data).first;
                              return image.flagImage;
                            }
                            return availableCountryCodes[0].flagImage;
                            
                          
                          }
                        ),
                        onTap: () async {
                           var response = await countryPicker.showPicker(context: context);
                           availableCountryCodes.clear();
                           availableCountryCodes.add(CountryCode(name: response?.name ??'United States', code: response?.code ?? 'US', dialCode: response?.dialCode ?? '+1'));
                           _viewModel.setCountryCode(response?.dialCode ?? empty);
                           
                        },
                      ),
                    ),
                  ),
                  Expanded(
                  flex:3,
                  child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorMobileNumber,
                  builder: ((context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _mobileTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.mobileNumber.tr(),
                          labelText: AppStrings.mobileNumber.tr(),
                          errorText: (snapshot.data)),
                    );
                  }),
                ),)
                ],
              ),
              ),),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorEmail,
                  builder: ((context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.emailHint.tr(),
                          labelText: AppStrings.emailHint.tr(),
                          errorText: (snapshot.data)),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<String?>(
                  stream: _viewModel.outputErrorPassword,
                  builder: ((context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordTextEditingController,
                      decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: (snapshot.data)),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: Container(
                  decoration:BoxDecoration(
                    border: Border.all(color: ColorManager.lightGrey),
                    
                  ),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: (){
                      _showPicker(context);
                    },
                  ),
                )),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outputIsAllInputsValid,
                    builder: ((context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  _viewModel.register();
                                }
                              : null,
                          child: const Text(AppStrings.register).tr(),
                        ),
                      );
                    })),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.loginRoute);
                        },
                        child: Text(
                          AppStrings.haveAccount,
                          style: Theme.of(context).textTheme.caption,
                        ).tr()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  void _showPicker(BuildContext context) {
    showModalBottomSheet(context: context, builder: (context){
      return SafeArea(child: Wrap(
        children: [
          ListTile(
            trailing: const Icon(Icons.arrow_forward),
            leading: const Icon(Icons.camera),
            title: const Text(AppStrings.photoGallery).tr(),
            onTap: (){
              _imageFromGallery();
              Navigator.pop(context);
            },
          ),
          ListTile(
            trailing: const Icon(Icons.arrow_forward),
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text(AppStrings.photoCamera).tr(),
            onTap: (){
              _imageFromCamera();
              Navigator.pop(context);
            },
          )
        ],
      ));
    });
  }
  
  Widget _getMediaWidget() {
    return Padding(padding: EdgeInsets.symmetric(
      horizontal: AppPadding.p8,
      vertical: AppPadding.p12,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(AppStrings.profilePicture).tr()),
        Flexible(child: 
        StreamBuilder<File?>(
          stream: _viewModel.outputProfilePicture,
          builder: ((context, snapshot) {
            return _imagePickedByUser(snapshot.data);
          }),

          ),),
        Flexible(child: Icon(Icons.camera_alt_outlined)),
      ],
    ),
    );
  }

  _imageFromGallery() async{
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async{
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }
  
  Widget _imagePickedByUser(File? image) {
    if(image!=null && image.path.isNotEmpty){
      return Image.file(image);
    }else{
      return Container();
    }
  }
}
