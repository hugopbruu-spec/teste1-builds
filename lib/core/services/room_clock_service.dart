import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomClockService extends StateNotifier<DateTime> {
  RoomClockService() : super(DateTime.now());

  void tick() {
    state = DateTime.now();
  }
}

final roomClockProvider = StateNotifierProvider<RoomClockService, DateTime>(
  (ref) => RoomClockService(),
);
