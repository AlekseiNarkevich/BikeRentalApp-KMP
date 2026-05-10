import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../l10n/app_localizations.dart';

/// @file login_screen.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Экран авторизации и регистрации пользователя.

/// @class LoginScreen
/// @brief Виджет экрана входа, адаптирующийся под состояние базы пользователей.
/// 
/// Если в системе нет пользователей, экран работает в режиме регистрации.
/// В противном случае — в режиме входа с проверкой пароля.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

/// @class _LoginScreenState
/// @brief Состояние экрана логина, управляющее вводом данных и отображением ошибок.
class _LoginScreenState extends ConsumerState<LoginScreen> {
  /// Контроллер для поля ввода электронной почты.
  final _emailController = TextEditingController();
  /// Контроллер для поля ввода пароля.
  final _passwordController = TextEditingController();
  /// Флаг выполнения процесса аутентификации для отображения индикатора загрузки.
  bool _isLoading = false;

  /// @brief Получение локализованного текста ошибки на основе ключа.
  /// 
  /// @param errorCode Строковый ключ ошибки, возвращаемый провайдером.
  /// @param l10n Объект локализации текущего контекста.
  /// @return Локализованная строка сообщения об ошибке.
  String _getLocalizedError(String errorCode, AppLocalizations l10n) {
    switch (errorCode) {
      case 'userNotFound': return l10n.userNotFound;
      case 'wrongPassword': return l10n.wrongPassword;
      case 'fillFields': return l10n.fillFields;
      case 'passwordShort': return l10n.passwordShort;
      default: return l10n.error;
    }
  }

  /// @brief Обработчик нажатия кнопки входа/регистрации.
  /// 
  /// Выполняет асинхронный вызов к AuthNotifier и отображает результат 
  /// через SnackBar в случае неудачи.
  Future<void> _handleAuth() async {
    setState(() => _isLoading = true);
    final errorKey = await ref.read(authProvider.notifier).authenticate(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (errorKey != null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getLocalizedError(errorKey, l10n)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Наблюдаем за тем, есть ли пользователи в системе для смены режима (Вход/Регистрация)
    final hasUsers = ref.watch(hasUsersProvider);
    final isReg = !hasUsers;

    return Scaffold(
      appBar: AppBar(title: Text(isReg ? l10n.register : l10n.login)),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            // [DESKTOP/WEB] Ограничение максимальной ширины формы для больших экранов
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isReg ? l10n.register : l10n.login,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.password,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _handleAuth,
                          child: Text(isReg ? l10n.register : l10n.login),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
