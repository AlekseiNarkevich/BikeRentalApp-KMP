import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

/// @file auth_provider.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Провайдеры для управления состоянием авторизации пользователя.

/// @brief Провайдер доступа к сервису авторизации.
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

/// @brief Провайдер состояния регистрации.
/// Используем простой Provider, так как AuthService сам знает состояние базы Hive.
final hasUsersProvider = Provider<bool>((ref) {
  final service = ref.watch(authServiceProvider);
  return service.hasUsers;
});

/// @class AuthNotifier
/// @brief Контроллер состояния текущего пользователя.
/// 
/// Управляет процессами входа, регистрации и выхода из системы.
class AuthNotifier extends StateNotifier<User?> {
  final AuthService _authService;
  final Ref _ref;

  /// @brief Конструктор контроллера.
  /// @param _authService Сервис для работы с хранилищем пользователей.
  /// @param _ref Ссылка на другие провайдеры Riverpod.
  AuthNotifier(this._authService, this._ref) : super(null);

  /// @brief Вход в систему или автоматическая регистрация.
  /// 
  /// Если в базе еще нет пользователей, выполняется регистрация.
  /// Иначе — проверка учетных данных.
  /// 
  /// @param email Электронная почта.
  /// @param password Пароль пользователя.
  /// @return Ключ ошибки для локализации или null при успехе.
  Future<String?> authenticate(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return 'fillFields';
    if (password.length < 6) return 'passwordShort';

    try {
      User? user;
      final bool alreadyHasUsers = _authService.hasUsers;
      
      if (!alreadyHasUsers) {
        user = await _authService.register(email, password);
        // Инвалидируем провайдер, чтобы UI узнал о наличии зарегистрированных юзеров
        _ref.invalidate(hasUsersProvider);
      } else {
        user = await _authService.login(email, password);
      }
      
      if (user != null) {
        state = user;
        return null;
      }
      return 'error';
    } catch (e) {
      return e.toString();
    }
  }

  /// @brief Выход текущего пользователя из системы.
  /// [DESKTOP] Вызывается при нажатии Ctrl+Q благодаря Shortcuts в main.dart.
  Future<void> logout() async {
    await _authService.logout();
    state = null;
  }

  /// @brief Полное удаление всех аккаунтов и сброс состояния приложения.
  /// Используется для тестирования логики "первого запуска" (регистрации).
  Future<void> deleteAccounts() async {
    await _authService.deleteAllUsers();
    state = null;
    _ref.invalidate(hasUsersProvider);
  }
}

/// @brief Глобальный провайдер состояния авторизации.
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService, ref);
});
