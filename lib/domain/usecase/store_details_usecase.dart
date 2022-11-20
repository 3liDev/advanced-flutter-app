import 'package:advanced_flutter_app/data/network/failure.dart';
import 'package:advanced_flutter_app/domain/model/models.dart';
import 'package:advanced_flutter_app/domain/repository/repository.dart';
import 'package:advanced_flutter_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class StoreDetailsUseCase extends BaseUseCase<void, StoreDetails> {
  Repository repository;
  StoreDetailsUseCase(this.repository);
  @override
  Future<Either<Failure, StoreDetails>> execute(void input) {
    return repository.getStoreDetails();
  }
}
