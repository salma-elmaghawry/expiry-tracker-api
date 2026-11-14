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
import 'package:expiry_tracker/features/cartons/data/datasources/cartons_remote_datasource.dart';
import 'package:expiry_tracker/features/cartons/data/datasources/cartons_remote_datasource_impl.dart';
import 'package:expiry_tracker/features/cartons/data/repositories/cartons_repository_impl.dart';
import 'package:expiry_tracker/features/cartons/domain/repositories/cartons_repository.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/preview_carton_usecase.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/receive_carton_usecase.dart';
import 'package:expiry_tracker/features/cartons/presentation/cubit/receive_carton_cubit.dart';
import 'package:expiry_tracker/features/factory_labels/data/datasources/labels_remote_datasource.dart';
import 'package:expiry_tracker/features/factory_labels/data/datasources/labels_remote_datasource_impl.dart';
import 'package:expiry_tracker/features/factory_labels/data/repositories/labels_repository_impl.dart';
import 'package:expiry_tracker/features/factory_labels/domain/repositories/labels_repository.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/cubit/create_labels_cubit.dart';
import 'package:expiry_tracker/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:expiry_tracker/features/dashboard/data/datasources/dashboard_remote_datasource_impl.dart';
import 'package:expiry_tracker/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:expiry_tracker/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:expiry_tracker/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:expiry_tracker/features/dashboard/domain/usecases/load_demo_data_usecase.dart';
import 'package:expiry_tracker/features/dashboard/presentation/cubit/dashboard_cubit.dart';
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
  _registerCartons();
  _registerFactoryLabels();
  _registerDashboard();
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

void _registerCartons() {
  getIt.registerLazySingleton<CartonsRemoteDataSource>(
    () => CartonsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<CartonsRepository>(
    () => CartonsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => PreviewCartonUseCase(getIt()));
  getIt.registerLazySingleton(() => ReceiveCartonUseCase(getIt()));
  // Factory: every receiving session starts with fresh totals.
  getIt.registerFactory(() => ReceiveCartonCubit(getIt(), getIt()));
}

void _registerFactoryLabels() {
  getIt.registerLazySingleton<LabelsRemoteDataSource>(
    () => LabelsRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<LabelsRepository>(
    () => LabelsRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => CreateLabelJobUseCase(getIt()));
  getIt.registerFactory(() => CreateLabelsCubit(getIt()));
}

void _registerDashboard() {
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton(() => GetDashboardUseCase(getIt()));
  getIt.registerLazySingleton(() => LoadDemoDataUseCase(getIt()));
  // Also uses GetBatchesUseCase from the batches feature for the "Needs action" list.
  getIt.registerFactory(() => DashboardCubit(getIt(), getIt(), getIt()));
}
