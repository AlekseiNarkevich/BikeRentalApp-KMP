import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

/// @file auth_service.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Сервис для управления авторизацией и пользователями.

/// @class AuthService
/// @brief Класс, отвечающий за сохранение сессий и учетных данных пользователей в Hive.
class AuthService {
  static const String _authBoxName = 'authBox';
  static const String _usersBoxName = 'registeredUsers';
  static const String _currentUserKey = 'currentUser';

  /// @brief Инициализация хранилищ Hive для авторизации.
  /// [ALL] Открывает бинарные коробки для хранения сессий и базы пользователей.
  Future<void> init() async {
    await Hive.openBox(_authBoxName);
    await Hive.openBox<String>(_usersBoxName);
  }

  /// @brief Проверка наличия хотя бы одного зарегистрированного пользователя.
  /// @return true, если база пользователей не пуста.
  bool get hasUsers => Hive.box<String>(_usersBoxName).isNotEmpty;

  /// @brief Регистрация первого пользователя в системе.
  /// 
  /// @param email Электронная почта.
  /// @param password Пароль.
  /// @return Объект User с токеном сессии.
  Future<User?> register(String email, String password) async {
    final usersBox = Hive.box<String>(_usersBoxName);
    final authBox = Hive.box(_authBoxName);
    
    await usersBox.put(email, password);
    final user = User(email: email, token: 'token-${email.hashCode}');
    await authBox.put(_currentUserKey, user);
    return user;
  }

  /// @brief Выполнение входа существующего пользователя.
  /// 
  /// @param email Логин (почта).
  /// @param password Пароль.
  /// @throw 'wrongPassword' или 'userNotFound' при ошибках.
  /// @return Объект User при успешном входе.
  Future<User?> login(String email, String password) async {
    final usersBox = Hive.box<String>(_usersBoxName);
    final authBox = Hive.box(_authBoxName);

    if (usersBox.containsKey(email)) {
      if (usersBox.get(email) == password) {
        final user = User(email: email, token: 'token-${email.hashCode}');
        await authBox.put(_currentUserKey, user);
        return user;
      } else {
        throw 'wrongPassword';
      }
    } else {
      throw 'userNotFound';
    }
  }

  /// @brief Удаление текущей сессии пользователя.
  Future<void> logout() async {
    await Hive.box(_authBoxName).delete(_currentUserKey);
  }

  /// @brief Полный сброс системы пользователей (удаление всех данных).
  /// Используется для возврата к экрану регистрации.
  Future<void> deleteAllUsers() async {
    final usersBox = Hive.box<String>(_usersBoxName);
    final authBox = Hive.box(_authBoxName);
    await usersBox.clear();
    await authBox.delete(_currentUserKey);
  }

  /// @brief Получение данных текущего пользователя из локального кеша.
  /// @return Объект User или null.
  User? getCurrentUser() => Hive.box(_authBoxName).get(_currentUserKey) as User?;
}
