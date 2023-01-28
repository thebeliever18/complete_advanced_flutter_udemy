import 'package:complete_advanced_flutter/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererTyper();
  String getMessage();
}

//Loading state (popup, fullScreen)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading.tr();
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererTyper() => stateRendererType;
}

//error state (popup, full loading)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;
  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererTyper() => stateRendererType;
}

//content state ()

class ContentState extends FlowState {
  ContentState();
  @override
  String getMessage() => empty;

  @override
  StateRendererType getStateRendererTyper() =>
      StateRendererType.contentScreenState;
}

//empty state

class EmptyState extends FlowState {
  String message;
  EmptyState(this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererTyper() =>
      StateRendererType.emptyScreenState;
}

//success state

class SuccessState extends FlowState{
  String message;
  SuccessState(this.message);
  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererTyper() => StateRendererType.popUpSuccess;

}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (this.runtimeType) {
      //remove or add this
      case LoadingState:
        {
          if (getStateRendererTyper() == StateRendererType.popUpLoadingState) {
            //show popup dialog
            showPopUp(context, getStateRendererTyper(), getMessage());
            //return the content ui of the screen
            return contentScreenWidget;
          } else {
            //StateRendererType.fullScreenLoading
            return StateRenderer(
                stateRendererType: getStateRendererTyper(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererTyper() == StateRendererType.popUpErrorState) {
            //show popup dialog
            showPopUp(context, getStateRendererTyper(), getMessage());
            //show content
            return contentScreenWidget;
          } else {
            //StateRendererType.fullScreenErrorState
            return StateRenderer(
              stateRendererType: getStateRendererTyper(),
              message: getMessage(),
              retryActionFunction: retryActionFunction,
            );
          }
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererTyper(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
      case SuccessState:
      {
        dismissDialog(context);
        showPopUp(context,StateRendererType.popUpSuccess,getMessage(),
        title:AppStrings.success.tr()
        );
        return contentScreenWidget;
      }
      default:
        {
          return contentScreenWidget;
        }
    }
  }

  dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message,{String title = empty}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: ((context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {})),
      ),
    );
  }
}
