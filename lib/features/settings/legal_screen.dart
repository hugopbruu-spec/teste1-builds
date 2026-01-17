import 'package:flutter/material.dart';
import '../../core/widgets/gradient_scaffold.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(title: const Text('Legal')),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          Text('Termos de uso', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Este é um aplicativo MVP com dados simulados.'),
          SizedBox(height: 16),
          Text('Política de privacidade', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Nenhum dado real é coletado neste protótipo.'),
        ],
      ),
    );
  }
}
