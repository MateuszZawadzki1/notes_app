// dart format width=80
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
import 'package:notes_app/src/features/auth/bloc/auth_bloc.dart' as _i756;
import 'package:notes_app/src/features/notes/cubit/notes_cubit.dart' as _i753;
import 'package:notes_app/src/core/di/di_modules.dart' as _i354;
import 'package:notes_app/src/core/services/api_service.dart' as _i67;
import 'package:notes_app/src/core/services/dio_client.dart' as _i129;
import 'package:notes_app/src/features/notes/data/repositories/note_repository.dart'
    as _i682;
import 'package:notes_app/src/features/auth/data/repositories/auth_service.dart'
    as _i830;

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
    final dioModule = _$dioModule();
    final appModule = _$AppModule();
    gh.factory<_i830.AuthService>(() => _i830.AuthService());
    gh.singleton<_i361.Dio>(() => dioModule.dioClient());
    gh.singleton<String>(
      () => appModule.baseUrl,
      instanceName: 'baseUrl',
    );
    gh.factory<_i756.AuthBloc>(
        () => _i756.AuthBloc(authService: gh<_i830.AuthService>()));
    gh.factory<_i67.ApiService>(() => _i67.ApiService(
          gh<_i361.Dio>(),
          baseUrl: gh<String>(instanceName: 'baseUrl'),
        ));
    gh.factory<_i682.NoteRepository>(
        () => _i682.NoteRepository(gh<_i67.ApiService>()));
    gh.factory<_i753.NotesCubit>(
        () => _i753.NotesCubit(gh<_i682.NoteRepository>()));
    return this;
  }
}

class _$dioModule extends _i129.DioModule {}

class _$AppModule extends _i354.AppModule {}
