import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

/// @file settings_screen.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Экран пользовательских настроек приложения.

/// @class SettingsScreen
/// @brief Виджет экрана настроек, предоставляющий интерфейс для смены языка, темы и управления аккаунтом.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Подписка на текущие настройки темы и языка
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          /// Секция динамической смены языка интерфейса.
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: locale.languageCode,
              onChanged: (code) {
                if (code != null) {
                  // Обновление локали через провайдер
                  ref.read(localeProvider.notifier).setLocale(Locale(code));
                }
              },
              items: const [
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'be', child: Text('Беларуская')),
              ],
            ),
          ),
          const Divider(),
          /// Секция выбора темы оформления (светлая/темная/системная).
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              onChanged: (mode) {
                if (mode != null) {
                  ref.read(themeProvider.notifier).setTheme(mode);
                }
              },
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.themeSystem)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.themeDark)),
              ],
            ),
          ),
          const Divider(),
          /// Информационная секция о версии приложения.
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
          ),
          const Divider(),
          /// Секция сброса данных приложения (для тестирования логики регистрации).
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.orange),
            title: Text(l10n.deleteAccounts, style: const TextStyle(color: Colors.orange)),
            onTap: () async {
              await ref.read(authProvider.notifier).deleteAccounts();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Icon(Icons.delete_sweep)),
                );
              }
            },
          ),
          /// Секция выхода из учетной записи.
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }
}
