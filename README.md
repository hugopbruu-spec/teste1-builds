# Sync Room

Aplicativo Flutter de salas sincronizadas para assistir, navegar e compartilhar em tempo real.

## Como rodar

```bash
flutter pub get
flutter run
```

## Estrutura do projeto

```
lib/
  app/            # App, rotas, tema
  core/           # Widgets reutilizáveis e serviços
  features/       # Módulos de telas
assets/           # Imagens locais
```

## Como simular estados

No menu **Ajuda & Diagnóstico**, use os botões para:
- Simular offline e reconexão.
- Simular jitter alto e fora de sincronização.
- Forçar "Ressincronizar" no modo sincronizado.

## Checklist de testes manuais

- Autenticação básica e navegação entre telas.
- Criar sala gera código curto e abre Lobby.
- Entrar com código válido/invalidado (fake).
- Definir link detecta tipo e mostra preview.
- Painéis inferiores (Chat/Voz/Participantes/Opções).
- Botão de Ressincronizar altera estado visual.
- Diagnóstico simula offline e estados de sync.
