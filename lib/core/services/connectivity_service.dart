import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectivityState {
  ConnectivityState({
    required this.isOffline,
    required this.isReconnecting,
  });

  final bool isOffline;
  final bool isReconnecting;

  ConnectivityState copyWith({bool? isOffline, bool? isReconnecting}) {
    return ConnectivityState(
      isOffline: isOffline ?? this.isOffline,
      isReconnecting: isReconnecting ?? this.isReconnecting,
    );
  }
}

class ConnectivityService extends StateNotifier<ConnectivityState> {
  ConnectivityService() : super(ConnectivityState(isOffline: false, isReconnecting: false));

  void simulateOffline() {
    state = state.copyWith(isOffline: true, isReconnecting: false);
  }

  void simulateReconnecting() {
    state = state.copyWith(isOffline: false, isReconnecting: true);
  }

  void simulateOnline() {
    state = state.copyWith(isOffline: false, isReconnecting: false);
  }
}

final connectivityProvider = StateNotifierProvider<ConnectivityService, ConnectivityState>(
  (ref) => ConnectivityService(),
);
