# Sync Room

Aplicativo Flutter de salas sincronizadas com Firebase (Auth, Firestore, FCM) e WebRTC.

## Como rodar

1. Atualize os placeholders em `lib/firebase_options.dart` com os dados do seu projeto Firebase.
2. Substitua o placeholder em `android/app/google-services.json`.

```bash
flutter pub get
flutter run
```

## Estrutura do projeto

```
lib/
  app/            # App, rotas, tema
  core/           # Models, services e widgets
  features/       # Módulos de telas
android/app/      # google-services.json placeholder
```

## Fluxo de dados (resumo)

- Auth: Firebase Authentication (email/senha).
- Salas: Firestore (rooms, participants, sync, messages).
- Chat: Firestore realtime.
- Voz/Transmissão: WebRTC com signaling via Firestore.
- Notificações: FCM preparado.

## Checklist de testes manuais

- Criar conta e entrar.
- Criar sala e entrar com código.
- Ver participantes em tempo real.
- Enviar mensagens no chat (tempo real).
- Atualizar play/pause no modo sincronizado.
- Iniciar/entrar em chamada de voz.
- Iniciar/entrar em transmissão.
