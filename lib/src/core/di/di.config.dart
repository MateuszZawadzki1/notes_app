// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:notes_app/src/core/di/di_modules.dart' as _i545;
import 'package:notes_app/src/core/hive/hive_service.dart' as _i805;
import 'package:notes_app/src/core/services/api_service.dart' as _i108;
import 'package:notes_app/src/core/services/connectivity_service.dart' as _i827;
import 'package:notes_app/src/core/services/dio_client.dart' as _i1004;
import 'package:notes_app/src/features/auth/bloc/auth_bloc.dart' as _i180;
import 'package:notes_app/src/features/auth/data/repositories/auth_service.dart'
    as _i249;
import 'package:notes_app/src/features/notes/cubit/notes_cubit.dart' as _i570;
import 'package:notes_app/src/features/notes/data/repositories/note_repository.dart'
    as _i306;
import 'package:notes_app/src/features/notes/data/services/sync_service.dart'
    as _i735;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final dioModule = _$DioModule();
    final appModule = _$AppModule();
    gh.factory<_i249.AuthService>(() => _i249.AuthService());
    gh.singletonAsync<_i805.HiveService>(() {
      final i = _i805.HiveService();
      return i.init().then((_) => i);
    });
    gh.singleton<_i361.Dio>(() => dioModule.dioClient());
    gh.singleton<_i827.ConnectivityService>(() => _i827.ConnectivityService());
    gh.factory<_i180.AuthBloc>(
        () => _i180.AuthBloc(authService: gh<_i249.AuthService>()));
    gh.singleton<String>(
      () => appModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.factory<_i108.ApiService>(() => _i108.ApiService(
          gh<_i361.Dio>(),
          baseUrl: gh<String>(instanceName: 'baseUrl'),
        ));
    gh.factoryAsync<_i306.NoteRepository>(() async => _i306.NoteRepository(
          gh<_i108.ApiService>(),
          await getAsync<_i805.HiveService>(),
          gh<_i827.ConnectivityService>(),
        ));
    gh.singletonAsync<_i570.NotesCubit>(() async => _i570.NotesCubit(
          await getAsync<_i306.NoteRepository>(),
          gh<_i827.ConnectivityService>(),
        ));
    gh.singletonAsync<_i735.SyncService>(
      () async => _i735.SyncService(
        gh<_i827.ConnectivityService>(),
        await getAsync<_i570.NotesCubit>(),
      )..init(),
      dispose: (i) => i.dispose(),
    );
    return this;
  }
}

class _$DioModule extends _i1004.DioModule {}

class _$AppModule extends _i545.AppModule {}
