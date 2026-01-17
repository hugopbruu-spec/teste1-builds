import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_item.dart';

class HistoryRepository {
  List<HistoryItem> fetchHistory() {
    return const [
      HistoryItem(
        title: 'Sessão com Lia',
        subtitle: 'YouTube • Modo sincronizado',
        timestampLabel: '1h atrás',
      ),
      HistoryItem(
        title: 'Navegação conjunta',
        subtitle: 'Web • Workspace',
        timestampLabel: 'ontem',
      ),
    ];
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});
