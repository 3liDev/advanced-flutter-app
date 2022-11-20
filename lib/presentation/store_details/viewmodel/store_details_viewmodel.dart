import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/domain/usecase/store_details_usecase.dart';
import 'package:advanced_flutter_app/presentation/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';
import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInput, StoreDetailsViewModelOutput {
  final _storeDetailsStreamController = BehaviorSubject<StoreDetails>();

  final StoreDetailsUseCase storeDetailsUseCase;
  StoreDetailsViewModel(this.storeDetailsUseCase);

  // input

  @override
  void start() {
    _loadData();
  }

  void input() {}

  _loadData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await storeDetailsUseCase.execute(input())).fold(
        (failure) => {
              // left -> failure
              inputState.add(ErrorState(
                  StateRendererType.fullScreenErrorState, failure.message))
            }, (storeDetails) async {
      // right -> data(success)
      // content state
      inputState.add(ContentState());
      inputStoreDetail.add(storeDetails);

      // navigate to main screen
    });
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
  }

  @override
  Sink get inputStoreDetail => _storeDetailsStreamController.sink;

// output
  @override
  Stream<StoreDetails> get outputStoreDetail =>
      _storeDetailsStreamController.stream.map((stores) => stores);
}

abstract class StoreDetailsViewModelInput {
  Sink get inputStoreDetail;
}

abstract class StoreDetailsViewModelOutput {
  Stream<StoreDetails> get outputStoreDetail;
}
