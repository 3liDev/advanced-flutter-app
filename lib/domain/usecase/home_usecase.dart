import 'package:advanced_flutter_app/data/network/failure.dart';
import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/domain/repository/repository.dart';
import 'package:advanced_flutter_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;
  HomeUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}
