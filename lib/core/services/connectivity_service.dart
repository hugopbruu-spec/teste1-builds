import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityState {
  ConnectivityState({
    required this.isOffline,
  });

  final bool isOffline;
}

class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  Stream<ConnectivityState> watch() async* {
    yield await _current();
    await for (final result in _connectivity.onConnectivityChanged) {
      yield ConnectivityState(isOffline: result == ConnectivityResult.none);
    }
  }

  Future<ConnectivityState> _current() async {
    final result = await _connectivity.checkConnectivity();
    return ConnectivityState(isOffline: result == ConnectivityResult.none);
  }
}

final connectivityProvider = StreamProvider<ConnectivityState>((ref) {
  final service = ConnectivityService(Connectivity());
  return service.watch();
});
