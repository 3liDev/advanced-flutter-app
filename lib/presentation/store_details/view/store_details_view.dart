import 'package:advanced_flutter_app/app/di.dart';
import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:advanced_flutter_app/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({Key? key}) : super(key: key);

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final StoreDetailsViewModel _viewModel = instance<StoreDetailsViewModel>();

  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: (context, snapshot) {
            return Container(
              child: snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _viewModel.start();
                  }) ??
                  Container(),
            );
          }),
    );
  }

  Widget _getContentWidget() {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text(AppStrings.storeDetails.tr()),
        elevation: AppSize.s0,
        iconTheme: IconThemeData(
            // back button
            color: ColorManager.white),
        backgroundColor: ColorManager.primary,
        centerTitle: true,
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: ColorManager.white,
        child: SingleChildScrollView(
          child: StreamBuilder<StoreDetails>(
            stream: _viewModel.outputStoreDetail,
            builder: (context, snapshot) {
              return _getItem(snapshot.data);
            },
          ),
        ),
      ),
    );
  }

  Widget _getItem(StoreDetails? storeDetails) {
    if (storeDetails != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              storeDetails.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: AppSize.s150H,
            ),
          ),
          _getSection(AppStrings.details.tr()),
          _getInfoText(storeDetails.details),
          _getSection(AppStrings.services.tr()),
          _getInfoText(storeDetails.services),
          _getSection(AppStrings.about.tr()),
          _getInfoText(storeDetails.about),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
      padding: EdgeInsets.only(
          left: AppPadding.p8W,
          right: AppPadding.p8W,
          top: AppPadding.p8H,
          bottom: AppPadding.p8H),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _getInfoText(String info) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p8SP),
      child: Text(
        info,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
