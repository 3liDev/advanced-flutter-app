import 'package:advanced_flutter_app/app/constants.dart';
import 'package:advanced_flutter_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

// loading state(POPUP,FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState(
      {required this.stateRendererType, this.message = AppStrings.loading});

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// error state(POPUP,FULL SCREEN)

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// empty state

class EmptytState extends FlowState {
  String message;
  EmptytState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.fullScreenEmptyState;
}

// content state

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => Constants.empty;

  @override
  StateRendererType getStateRendererType() => StateRendererType.contentState;
}

class SuccessState extends FlowState {
  String messsage;
  SuccessState(this.messsage);

  @override
  String getMessage() => messsage;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popUpSuccess;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.popUpLoadingState) {
            // show popup loading
            showPopup(context, getStateRendererType(), getMessage());

            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen loading state
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.popUpErrorState) {
            // show popup error
            showPopup(context, getStateRendererType(), getMessage());

            // show content ui of the screen
            return contentScreenWidget;
          } else {
            // full screen error state
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case EmptytState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: () {});
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }

      case SuccessState:
        {
          // i should check if we are showing loading popup to remove it before showing success popup
          dismissDialog(context);

          // show popup
          showPopup(context, StateRendererType.popUpSuccess, getMessage(),
              title: AppStrings.success);
          // return content ui of the screen
          return contentScreenWidget;
        }
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }

  _isCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context) {
    if (_isCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = Constants.empty}) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRendererType: stateRendererType,
            message: message,
            title: title,
            retryActionFunction: () {})));
  }
}
