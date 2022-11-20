import 'package:advanced_flutter_app/app/app_prefs.dart';
import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/constants_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/routes_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    _appPreferences.setOnBoardingScreenViewed();
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _viewModel.outputSliderViewObject,
        builder: (context, snapshot) {
          return _getContentWidget(snapshot.data);
        });
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    } else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: PageView.builder(
            controller: _pageController,
            itemCount: sliderViewObject.numOfSlides,
            onPageChanged: (index) {
              _viewModel.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              // return onBoarding page
              return OnBoardingPage(sliderViewObject.sliderObject);
            }),
        bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(
                    AppStrings.skip.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              _getBottomSheetWidget(sliderViewObject),
            ],
          ),
        ),
      );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left arrow
          Padding(
            padding: EdgeInsets.all(AppPadding.p14SP),
            child: GestureDetector(
              child: SizedBox(
                width: AppSize.s20W,
                height: AppSize.s20H,
                child: SvgPicture.asset(ImageAssets.leftArrowIc),
              ),
              onTap: () {
                // go to previous slide
                _pageController.animateToPage(
                  _viewModel.goPrevious(),
                  duration: const Duration(
                      microseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut,
                );
              },
            ),
          ),

          // circle indicator
          Row(
            children: [
              for (int i = 0; i < sliderViewObject.numOfSlides; i++)
                Padding(
                  padding: EdgeInsets.all(AppPadding.p8SP),
                  child: _getProperCircle(i, sliderViewObject.currentIndex),
                ),
            ],
          ),

          // right arrow
          Padding(
            padding: EdgeInsets.all(AppPadding.p14SP),
            child: GestureDetector(
              child: SizedBox(
                width: AppSize.s20W,
                height: AppSize.s20H,
                child: SvgPicture.asset(ImageAssets.rightArrowIc),
              ),
              onTap: () {
                // go to previous slide
                _pageController.animateToPage(
                  _viewModel.goNext(),
                  duration: const Duration(
                      microseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int currentIndex) {
    if (index == currentIndex) {
      return SvgPicture.asset(ImageAssets.solidCircleIc);
    } else {
      return SvgPicture.asset(ImageAssets.hollowCirlceIc);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;
  const OnBoardingPage(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: AppSize.s0.h,
        // ),
        Padding(
          padding: EdgeInsets.all(AppPadding.p8SP),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(AppPadding.p8SP),
          child: Text(
            _sliderObject.subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        SizedBox(
          height: AppSize.s60H,
        ),
        SvgPicture.asset(
          _sliderObject.image,
          width: AppSize.s235W,
          height: AppSize.s235H,
        ),
      ],
    );
  }
}
