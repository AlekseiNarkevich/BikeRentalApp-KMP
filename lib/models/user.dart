import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// @file user.dart
/// @author Наркевич Алексей
/// @version 1.0
/// @brief Модель данных для пользователя приложения.

/// @class User
/// @brief Класс, представляющий авторизованного пользователя.
/// 
/// Содержит данные профиля, необходимые для поддержания сессии.
/// Используется в AuthService для хранения текущего состояния входа.
@JsonSerializable()
@HiveType(typeId: 2)
class User extends HiveObject {
  /// @brief Электронная почта пользователя.
  /// Выступает в качестве уникального логина в системе.
  @HiveField(0)
  final String email;

  /// @brief Токен сессии.
  /// Имитирует JWT или другой механизм безопасности для API-запросов.
  @HiveField(1)
  final String token;

  /// @brief Конструктор для создания объекта пользователя.
  /// 
  /// @param email Адрес электронной почты.
  /// @param token Уникальный ключ сессии.
  User({
    required this.email,
    required this.token,
  });

  /// @brief Фабричный метод для создания пользователя из JSON.
  /// 
  /// @param json Карта данных профиля.
  /// @return Экземпляр User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// @brief Метод для преобразования пользователя в JSON.
  /// 
  /// @return Карта данных объекта.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
