import 'dart:async';

import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/presentation/base/base_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // stream controllers outputs
  final StreamController _streamController =
      StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentIndex = 0;

  // OnBoarding ViewModel Inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
// view model start your job
    _list = _getSliderData();
    _postDataToView(); //to update ui - send data to view
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  // OnBoarding ViewModel Outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  // onboarding private functions
  _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(
        sliderObject: _list[_currentIndex],
        numOfSlides: _list.length,
        currentIndex: _currentIndex));
  }

  List<SliderObject> _getSliderData() => [
        SliderObject(
          AppStrings.onBoardingTitle1.tr(),
          AppStrings.onBoardingSubTitle1.tr(),
          ImageAssets.onboardingLogo1,
        ),
        SliderObject(
          AppStrings.onBoardingTitle2.tr(),
          AppStrings.onBoardingSubTitle2.tr(),
          ImageAssets.onboardingLogo2,
        ),
        SliderObject(
          AppStrings.onBoardingTitle3.tr(),
          AppStrings.onBoardingSubTitle3.tr(),
          ImageAssets.onboardingLogo3,
        ),
        SliderObject(
          AppStrings.onBoardingTitle4.tr(),
          AppStrings.onBoardingSubTitle4.tr(),
          ImageAssets.onboardingLogo4,
        ),
      ];
}

// inputs mean that "Orders" that our view model will receive from view
abstract class OnBoardingViewModelInputs {
  int goNext(); // when user clicks on right arrow or swip left
  int goPrevious(); // when user clicks on left arrow or swip right
  void onPageChanged(int index);

  // stream controller input
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}
