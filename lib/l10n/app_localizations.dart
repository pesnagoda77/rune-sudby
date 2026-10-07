import 'package:flutter/material.dart';

/// Локализация Руны Судьбы 1.2.0.
///
/// Словарь + fallback на русский. Язык системы; если язык не из supported —
/// русский.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Языки приложения. Первый — fallback.
  static const List<String> languages = ['ru', 'en', 'de', 'es', 'fr'];

  static const supportedLocales = [
    Locale('ru', 'RU'),
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
  ];

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get languageCode =>
      languages.contains(locale.languageCode) ? locale.languageCode : 'ru';

  String t(String key) =>
      _values[key]?[languageCode] ?? _values[key]?['ru'] ?? key;

  /// Статический вариант для сервисов без BuildContext.
  static String tr(String languageCode, String key) =>
      _values[key]?[languageCode] ?? _values[key]?['ru'] ?? key;

  static const Map<String, Map<String, String>> _values = {
    'myRune': {
      'ru': 'МОЯ РУНА',
      'en': 'MY RUNE',
      'de': 'MEINE RUNE',
      'es': 'MI RUNA',
      'fr': 'MA RUNE',
    },
    'premium': {
      'ru': 'Премиум',
      'en': 'Premium',
      'de': 'Premium',
      'es': 'Premium',
      'fr': 'Premium',
    },
    'debugPremiumOn': {
      'ru': 'Премиум активирован (debug)',
      'en': 'Premium activated (debug)',
      'de': 'Premium aktiviert (Debug)',
      'es': 'Prémium activado (debug)',
      'fr': 'Premium activé (debug)',
    },
    'limitDialogTitle': {
      'ru': 'Руна уже выпала',
      'en': 'Your rune is already drawn',
      'de': 'Deine Rune ist schon gezogen',
      'es': 'Tu runa ya ha salido',
      'fr': 'Ta rune est déjà tirée',
    },
    'limitDialogBody': {
      'ru':
          'Сегодня ты уже получила свою руну.\n\nОткрой три руны: Прошлое, Настоящее и Будущее.',
      'en':
          'You have already drawn your rune today.\n\nOpen three runes: Past, Present and Future.',
      'de':
          'Du hast heute schon deine Rune gezogen.\n\nÖffne drei Runen: Vergangenheit, Gegenwart und Zukunft.',
      'es':
          'Ya has recibido tu runa de hoy.\n\nAbre tres runas: Pasado, Presente y Futuro.',
      'fr':
          'Tu as déjà tiré ta rune du jour.\n\nOuvre trois runes : Passé, Présent et Avenir.',
    },
    'later': {
      'ru': 'Позже',
      'en': 'Later',
      'de': 'Später',
      'es': 'Más tarde',
      'fr': 'Plus tard',
    },
    'openThreeRunes': {
      'ru': 'Открыть три руны',
      'en': 'Open three runes',
      'de': 'Drei Runen öffnen',
      'es': 'Abrir tres runas',
      'fr': 'Ouvrir trois runes',
    },
    'emptyTitle': {
      'ru': 'Руна дня',
      'en': 'Rune of the Day',
      'de': 'Runentag',
      'es': 'Runa del día',
      'fr': 'Rune du jour',
    },
    'emptySubtitle': {
      'ru': 'Получи своё предсказание на сегодня',
      'en': 'Get your prediction for today',
      'de': 'Deine Vorhersage für heute',
      'es': 'Recibe tu predicción para hoy',
      'fr': 'Ta prédiction pour aujourd’hui',
    },
    'labelPresent': {
      'ru': 'НАСТОЯЩЕЕ',
      'en': 'PRESENT',
      'de': 'GEGENWART',
      'es': 'PRESENTE',
      'fr': 'PRÉSENT',
    },
    'labelPast': {
      'ru': 'ПРОШЛОЕ',
      'en': 'PAST',
      'de': 'VERGANGENHEIT',
      'es': 'PASADO',
      'fr': 'PASSÉ',
    },
    'labelFuture': {
      'ru': 'БУДУЩЕЕ',
      'en': 'FUTURE',
      'de': 'ZUKUNFT',
      'es': 'FUTURO',
      'fr': 'AVENIR',
    },
    'rare': {
      'ru': 'РЕДКАЯ',
      'en': 'RARE',
      'de': 'SELTEN',
      'es': 'RARA',
      'fr': 'RARE',
    },
    'btnTomorrow': {
      'ru': 'УЗНАЙ СУДЬБУ ЗАВТРА',
      'en': 'SEE TOMORROW’S FATE',
      'de': 'ERFAHRE DEIN SCHICKSAL MORGEN',
      'es': 'DESCUBRE TU DESTINO MAÑANA',
      'fr': 'DÉCOUVRE TON DESTIN DEMAIN',
    },
    'btnDrawOne': {
      'ru': 'ПОЛУЧИТЬ РУНУ',
      'en': 'DRAW A RUNE',
      'de': 'RUNE ZIEHEN',
      'es': 'RECIBIR RUNA',
      'fr': 'TIRER UNE RUNE',
    },
    'btnDrawPast': {
      'ru': 'ПОЛУЧИТЬ РУНУ ПРОШЛОГО',
      'en': 'DRAW THE RUNE OF THE PAST',
      'de': 'RUNE DER VERGANGENHEIT ZIEHEN',
      'es': 'RECIBIR LA RUNA DEL PASADO',
      'fr': 'TIRER LA RUNE DU PASSÉ',
    },
    'btnDrawFuture': {
      'ru': 'ПОЛУЧИТЬ РУНУ БУДУЩЕГО',
      'en': 'DRAW THE RUNE OF THE FUTURE',
      'de': 'RUNE DER ZUKUNFT ZIEHEN',
      'es': 'RECIBIR LA RUNA DEL FUTURO',
      'fr': 'TIRER LA RUNE DE L’AVENIR',
    },
    'btnDrawThree': {
      'ru': 'ПОЛУЧИТЬ ТРИ РУНЫ',
      'en': 'DRAW THREE RUNES',
      'de': 'DREI RUNEN ZIEHEN',
      'es': 'RECIBIR TRES RUNAS',
      'fr': 'TIRER TROIS RUNES',
    },
    'collectionTitle': {
      'ru': 'Коллекция рун',
      'en': 'Rune Collection',
      'de': 'Runensammlung',
      'es': 'Colección de runas',
      'fr': 'Collection de runes',
    },
    'collectionHint': {
      'ru':
          'Тяните руну дня — открытые руны остаются здесь навсегда. Часть рун ещё впереди.',
      'en':
          'Draw your daily rune — opened runes stay here forever. Some runes are still ahead.',
      'de':
          'Ziehe deine Tagesrune — geöffnete Runen bleiben für immer hier. Einige Runen liegen noch vor dir.',
      'es':
          'Tira tu runa del día — las runas abiertas permanecen aquí para siempre. Algunas runas aún están por llegar.',
      'fr':
          'Tire ta rune du jour — les runes ouvertes restent ici pour toujours. Certaines runes t’attendent encore.',
    },
    'notOpened': {
      'ru': 'Ещё не открыта',
      'en': 'Not opened yet',
      'de': 'Noch nicht geöffnet',
      'es': 'Aún no abierta',
      'fr': 'Pas encore ouverte',
    },
    'premiumTitle': {
      'ru': 'Раскрой три руны',
      'en': 'Reveal three runes',
      'de': 'Enthülle drei Runen',
      'es': 'Revela tres runas',
      'fr': 'Révèle trois runes',
    },
    'premiumSubtitle': {
      'ru': 'Прошлое · Настоящее · Будущее',
      'en': 'Past · Present · Future',
      'de': 'Vergangenheit · Gegenwart · Zukunft',
      'es': 'Pasado · Presente · Futuro',
      'fr': 'Passé · Présent · Avenir',
    },
    'subPeriod': {
      'ru': '30 дней · подписка',
      'en': '30 days · subscription',
      'de': '30 Tage · Abo',
      'es': '30 días · suscripción',
      'fr': '30 jours · abonnement',
    },
    'subDesc': {
      'ru':
          'Три руны каждый день в течение месяца. Подписка продлевается автоматически каждые 30 дней, отмена — в любой момент.',
      'en':
          'Three runes every day for a month. The subscription renews automatically every 30 days; cancel anytime.',
      'de':
          'Drei Runen jeden Tag für einen Monat. Das Abo verlängert sich automatisch alle 30 Tage, jederzeit kündbar.',
      'es':
          'Tres runas cada día durante un mes. La suscripción se renueva automáticamente cada 30 días; cancela cuando quieras.',
      'fr':
          'Trois runes chaque jour pendant un mois. L’abonnement se renouvelle automatiquement tous les 30 jours ; annulable à tout moment.',
    },
    'forever': {
      'ru': 'Навсегда',
      'en': 'Forever',
      'de': 'Für immer',
      'es': 'Para siempre',
      'fr': 'Pour toujours',
    },
    'foreverDesc': {
      'ru':
          'Три руны каждый день — без ограничений и автопродлений. Разовая покупка.',
      'en':
          'Three runes every day — no limits, no renewals. One-time purchase.',
      'de':
          'Drei Runen jeden Tag — ohne Limits und Verlängerungen. Einmaliger Kauf.',
      'es':
          'Tres runas cada día — sin límites ni renovaciones. Compra única.',
      'fr':
          'Trois runes chaque jour — sans limites ni renouvellement. Achat unique.',
    },
    'best': {
      'ru': 'ЛУЧШЕЕ',
      'en': 'BEST',
      'de': 'BESTE',
      'es': 'MEJOR',
      'fr': 'LE MEILLEUR',
    },
    'legal': {
      'ru':
          'Оплату обрабатывает Google Play. Подписка продлевается автоматически; отменить её можно в настройках подписки Google Play.',
      'en':
          'Payments are processed by Google Play. The subscription renews automatically; you can cancel it in your Google Play subscription settings.',
      'de':
          'Zahlungen werden über Google Play abgewickelt. Das Abo verlängert sich automatisch; du kannst es in den Google-Play-Abo-Einstellungen kündigen.',
      'es':
          'Los pagos los procesa Google Play. La suscripción se renueva automáticamente; puedes cancelarla en la configuración de suscripciones de Google Play.',
      'fr':
          'Les paiements sont gérés par Google Play. L’abonnement se renouvelle automatiquement ; tu peux l’annuler dans les paramètres d’abonnement Google Play.',
    },
    'manageSubscription': {
      'ru': 'Управление подпиской',
      'en': 'Manage subscription',
      'de': 'Abo verwalten',
      'es': 'Gestionar suscripción',
      'fr': 'Gérer l’abonnement',
    },
    'restore': {
      'ru': 'Восстановить покупки',
      'en': 'Restore purchases',
      'de': 'Käufe wiederherstellen',
      'es': 'Restaurar compras',
      'fr': 'Restaurer les achats',
    },
    'restoring': {
      'ru': 'Восстановление…',
      'en': 'Restoring…',
      'de': 'Wiederherstellung…',
      'es': 'Restaurando…',
      'fr': 'Restauration…',
    },
    'buy': {
      'ru': 'Купить',
      'en': 'Buy',
      'de': 'Kaufen',
      'es': 'Comprar',
      'fr': 'Acheter',
    },
    'msgPurchaseCanceled': {
      'ru': 'Покупка отменена',
      'en': 'Purchase canceled',
      'de': 'Kauf abgebrochen',
      'es': 'Compra cancelada',
      'fr': 'Achat annulé',
    },
    'msgPurchaseError': {
      'ru': 'Ошибка покупки. Попробуй позже.',
      'en': 'Purchase error. Please try again later.',
      'de': 'Kauf fehlgeschlagen. Bitte versuche es später erneut.',
      'es': 'Error de compra. Inténtalo de nuevo más tarde.',
      'fr': 'Erreur d’achat. Réessaie plus tard.',
    },
    'msgStoreUnavailable': {
      'ru': 'Магазин недоступен. Проверь подключение к интернету.',
      'en': 'Store unavailable. Check your internet connection.',
      'de': 'Shop nicht verfügbar. Prüfe deine Internetverbindung.',
      'es': 'Tienda no disponible. Comprueba tu conexión a internet.',
      'fr': 'Boutique indisponible. Vérifie ta connexion internet.',
    },
    'msgRestored': {
      'ru': 'Покупки восстановлены',
      'en': 'Purchases restored',
      'de': 'Käufe wiederhergestellt',
      'es': 'Compras restauradas',
      'fr': 'Achats restaurés',
    },
    'msgNothingToRestore': {
      'ru': 'Активных покупок не найдено',
      'en': 'No active purchases found',
      'de': 'Keine aktiven Käufe gefunden',
      'es': 'No se encontraron compras activas',
      'fr': 'Aucun achat actif trouvé',
    },
    'couldNotOpenPlay': {
      'ru': 'Не удалось открыть Google Play',
      'en': 'Could not open Google Play',
      'de': 'Google Play konnte nicht geöffnet werden',
      'es': 'No se pudo abrir Google Play',
      'fr': 'Impossible d’ouvrir Google Play',
    },
    'manageManualHint': {
      'ru': 'Google Play → Профиль → Платежи и подписки → Подписки',
      'en': 'Google Play → Profile → Payments & subscriptions → Subscriptions',
      'de': 'Google Play → Profil → Zahlungen und Abos → Abos',
      'es': 'Google Play → Perfil → Pagos y suscripciones → Suscripciones',
      'fr': 'Google Play → Profil → Paiements et abonnements → Abonnements',
    },
    'enterCode': {
      'ru': 'Ввести код',
      'en': 'Enter code',
      'de': 'Code eingeben',
      'es': 'Introducir código',
      'fr': 'Entrer le code',
    },
    'codeDialogTitle': {
      'ru': 'Активация кода',
      'en': 'Activate code',
      'de': 'Code aktivieren',
      'es': 'Activar código',
      'fr': 'Activer le code',
    },
    'codeHint': {
      'ru': 'Код активации',
      'en': 'Activation code',
      'de': 'Aktivierungscode',
      'es': 'Código de activación',
      'fr': 'Code d’activation',
    },
    'codeActivate': {
      'ru': 'Активировать',
      'en': 'Activate',
      'de': 'Aktivieren',
      'es': 'Activar',
      'fr': 'Activer',
    },
    'codeActivated': {
      'ru': 'Premium активирован',
      'en': 'Premium activated',
      'de': 'Premium aktiviert',
      'es': 'Prémium activado',
      'fr': 'Premium activé',
    },
    'codeAlreadyUsed': {
      'ru': 'Код уже активирован на этом устройстве',
      'en': 'Code already activated on this device',
      'de': 'Code auf diesem Gerät bereits aktiviert',
      'es': 'Código ya activado en este dispositivo',
      'fr': 'Code déjà activé sur cet appareil',
    },
    'codeMalformed': {
      'ru': 'Код не распознан — проверьте ввод',
      'en': 'Code not recognized — check the input',
      'de': 'Code nicht erkannt — Eingabe prüfen',
      'es': 'Código no reconocido — revisa la entrada',
      'fr': 'Code non reconnu — vérifie la saisie',
    },
    'codeWrongApp': {
      'ru': 'Этот код для другого приложения',
      'en': 'This code is for another app',
      'de': 'Dieser Code ist für eine andere App',
      'es': 'Este código es para otra app',
      'fr': 'Ce code est pour une autre application',
    },
    'codeUnknownType': {
      'ru': 'Неизвестный тип кода',
      'en': 'Unknown code type',
      'de': 'Unbekannter Codetyp',
      'es': 'Tipo de código desconocido',
      'fr': 'Type de code inconnu',
    },
    'codeExpired': {
      'ru': 'Срок действия кода истёк',
      'en': 'Code has expired',
      'de': 'Code abgelaufen',
      'es': 'El código ha caducado',
      'fr': 'Code expiré',
    },
    'codeBadSignature': {
      'ru': 'Код недействителен',
      'en': 'Code is invalid',
      'de': 'Code ungültig',
      'es': 'Código no válido',
      'fr': 'Code invalide',
    },
    'codeLimitReached': {
      'ru': 'Лимит активаций по этому коду исчерпан',
      'en': 'Activation limit reached for this code',
      'de': 'Aktivierungslimit für diesen Code erreicht',
      'es': 'Límite de activaciones agotado',
      'fr': 'Limite d’activations atteinte',
    },
    'codeDisabled': {
      'ru': 'Код отключён',
      'en': 'Code disabled',
      'de': 'Code deaktiviert',
      'es': 'Código desactivado',
      'fr': 'Code désactivé',
    },
    'codeNetwork': {
      'ru': 'Нужен интернет для активации этого кода',
      'en': 'Internet required to activate this code',
      'de': 'Internet erforderlich, um diesen Code zu aktivieren',
      'es': 'Se necesita internet para activar este código',
      'fr': 'Internet requis pour activer ce code',
    },
    'codeServerError': {
      'ru': 'Не удалось активировать — попробуйте позже',
      'en': 'Activation failed — try again later',
      'de': 'Aktivierung fehlgeschlagen — später erneut versuchen',
      'es': 'No se pudo activar — inténtalo de nuevo más tarde',
      'fr': 'Échec de l’activation — réessaie plus tard',
    },
    'elementFire': {
      'ru': 'ОГОНЬ',
      'en': 'FIRE',
      'de': 'FEUER',
      'es': 'FUEGO',
      'fr': 'FEU',
    },
    'elementWater': {
      'ru': 'ВОДА',
      'en': 'WATER',
      'de': 'WASSER',
      'es': 'AGUA',
      'fr': 'EAU',
    },
    'elementAir': {
      'ru': 'ВОЗДУХ',
      'en': 'AIR',
      'de': 'LUFT',
      'es': 'AIRE',
      'fr': 'AIR',
    },
    'elementEarth': {
      'ru': 'ЗЕМЛЯ',
      'en': 'EARTH',
      'de': 'ERDE',
      'es': 'TIERRA',
      'fr': 'TERRE',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.languages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
