import 'dart:async';
import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/domain/usecase/home_usecase.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../base/base_viewmodel.dart';
import '../../../../common/state_renderer/state_renderer.dart';
import '../../../../common/state_renderer/state_renderer_impl.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final StreamController _dataStreamController =
      BehaviorSubject<HomeViewObject>();

  final HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);

  // Inputs

  @override
  void start() {
    _getHomeData();
  }

  void input() {}

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _homeUseCase.execute(input())).fold(
        (failure) => {
              // left -> failure
              inputState.add(ErrorState(
                  StateRendererType.fullScreenErrorState, failure.message))
            }, (homeObject) {
      // right -> data(success)
      // content state
      inputState.add(ContentState());
      inputHomeData.add(HomeViewObject(homeObject.data.services,
          homeObject.data.banners, homeObject.data.stores));

      // navigate to main screen
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();

    super.dispose();
  }

  @override
  Sink get inputHomeData => _dataStreamController.sink;

  // Outputs

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelInput {
  Sink get inputHomeData;
}

abstract class HomeViewModelOutput {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Service>? services;
  List<BannerAd>? banners;
  List<Store>? stores;
  HomeViewObject(this.services, this.banners, this.stores);
}
