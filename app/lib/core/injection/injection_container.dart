import 'package:dio/dio.dart';
import 'package:expiry_tracker/core/network/api_config.dart';
import 'package:expiry_tracker/core/network/dio_client.dart';
import 'package:expiry_tracker/core/routes/app_router.dart';
import 'package:expiry_tracker/core/theme/controller/theme_cubit.dart';
import 'package:expiry_tracker/features/batches/data/datasources/batches_remote_datasource.dart';
import 'package:expiry_tracker/features/batches/data/datasources/batches_remote_datasource_impl.dart';
import 'package:expiry_tracker/features/batches/data/repositories/batches_repository_impl.dart';
import 'package:expiry_tracker/features/batches/domain/repositories/batches_repository.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/get_batches_usecase.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjection() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<AppRouter>(() => AppRouter());

  getIt.registerLazySingleton<ApiConfig>(() => ApiConfig(getIt()));
  getIt.registerLazySingleton<Dio>(() => DioClient(getIt()).dio);

  getIt.registerFactory<ThemeCubit>(() => ThemeCubit(getIt()));

  _registerBatches();
}

void _registerBatches() {
  getIt.registerLazySingleton<BatchesRemoteDataSource>(
    () => BatchesRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<BatchesRepository>(
    () => BatchesRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetBatchesUseCase(getIt()));
  getIt.registerLazySingleton(() => ApplyBatchActionUseCase(getIt()));
  getIt.registerFactory(() => BatchesCubit(getIt(), getIt()));
}
