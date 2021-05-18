// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Аккаунт
  internal static let accountLabel = L10n.tr("Localizable", "accountLabel")
  /// Ошибка базы данных. Пожалуйста, попробуйте позже
  internal static let databaseError = L10n.tr("Localizable", "databaseError")
  /// Ошибка во время открытия базы данных. Пожалуйста, попробуйте позже
  internal static let databaseOpenError = L10n.tr("Localizable", "databaseOpenError")
  /// Ошибка во время сохранения в базу данных. Пожалуйста, попробуйте позже
  internal static let databaseSaveError = L10n.tr("Localizable", "databaseSaveError")
  /// Ошибка
  internal static let errorTitle = L10n.tr("Localizable", "errorTitle")
  /// Неверный имейл или пароль
  internal static let incorrectCredentials = L10n.tr("Localizable", "incorrectCredentials")
  /// Неверный имейл или пароль
  internal static let incorrectEmailPassword = L10n.tr("Localizable", "incorrectEmailPassword")
  /// В библиотеке
  internal static let inLibraryState = L10n.tr("Localizable", "inLibraryState")
  /// Неправильный имейл или пароль. Возможно, такой пользователь уже существует
  internal static let invalidEmailPassword = L10n.tr("Localizable", "invalidEmailPassword")
  /// Невозможно совершить запрос по данному адресу. Пожалуйста, попробуйте позже
  internal static let invalidUrl = L10n.tr("Localizable", "invalidUrl")
  /// Библиотека
  internal static let libraryLabel = L10n.tr("Localizable", "libraryLabel")
  /// Слишком долгое ожидание запроса в сеть. Пожалуйста, попробуйте позже
  internal static let longResponse = L10n.tr("Localizable", "longResponse")
  /// Нет подключения к Интернет. Пожалуйста, попробуйте позже
  internal static let noConnection = L10n.tr("Localizable", "noConnection")
  /// Ок
  internal static let okButton = L10n.tr("Localizable", "okButton")
  /// Нет в наличии
  internal static let pickedUpState = L10n.tr("Localizable", "pickedUpState")
  /// Зарезервирована
  internal static let reservedState = L10n.tr("Localizable", "reservedState")
  /// Невозможно сделать запрос по данному адресу
  internal static let unableToCreateUrl = L10n.tr("Localizable", "unableToCreateUrl")
  /// Неавторизированный доступ
  internal static let unauthorizedAccess = L10n.tr("Localizable", "unauthorizedAccess")
  /// Неизвестная ошибка при получении данных с сервера. Пожалуйста, попробуйте позже
  internal static let unknownBackendError = L10n.tr("Localizable", "unknownBackendError")
  /// Неизвестная ошибка базы данных. Пожалуйста, попробуйте позже
  internal static let unknownDatabaseError = L10n.tr("Localizable", "unknownDatabaseError")
  /// Невозможно совершить запрос из-за неизвестной ошибки. Пожалуйста, попробуйте позже
  internal static let unknownNetworkError = L10n.tr("Localizable", "unknownNetworkError")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
