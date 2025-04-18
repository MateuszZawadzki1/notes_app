import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_app/src/core/services/connectivity_service.dart';
import 'package:notes_app/src/features/notes/cubit/notes_cubit.dart';

@singleton
class SyncService {
  SyncService(this._connectivityService, this._notesCubit);

  final ConnectivityService _connectivityService;
  final NotesCubit _notesCubit;
  StreamSubscription<ConnectivityResult>? _subscritpion;

  @postConstruct
  void init() {
    _subscritpion = _connectivityService.connectivityStream.listen((result) {
      if (result != ConnectivityResult.none) {
        _notesCubit.synchronize();
      }
    });
  }

  @disposeMethod
  void dispose() {
    _subscritpion?.cancel();
  }
}
