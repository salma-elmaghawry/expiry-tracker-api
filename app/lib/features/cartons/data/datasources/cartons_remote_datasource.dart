import 'package:expiry_tracker/features/cartons/data/models/carton_model.dart';
import 'package:expiry_tracker/features/cartons/data/models/carton_preview_model.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/receive_carton_usecase.dart';

abstract class CartonsRemoteDataSource {
  Future<CartonPreviewModel> previewCarton(String qrText);

  Future<CartonModel> receiveCarton(ReceiveCartonParams params);
}
