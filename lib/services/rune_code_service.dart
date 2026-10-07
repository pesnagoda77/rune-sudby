import 'package:activation_codes/activation_codes.dart' as ac;

/// Сервис активации кодов Руны Судьбы (task 091).
///
/// appId RUNE / appCode 3 (SPEC.md activation-codes):
/// - FOREVER (typeCode 1) — Premium навсегда (expDays = 0xFFFF);
/// - MONTH (typeCode 2) — Premium до даты кода.
///
/// Ключ подписи — только через --dart-define=CODE_KEY (боевой ключ на релизе
/// подставляет Краб). Без ключа персональные коды не проверяются: сервис
/// работает в серверном режиме и принимает только промо-коды billing-api.
class RuneCodeService {
  static final RuneCodeService _instance = RuneCodeService._internal();
  factory RuneCodeService() => _instance;
  RuneCodeService._internal();

  static const String _appId = 'RUNE';
  static const int _appCode = 3;
  static const String _serverUrl =
      'https://billing-api.pesnagoda77.workers.dev';

  static const Map<String, int> _types = {
    'FOREVER': 1,
    'MONTH': 2,
  };

  static const String _key =
      String.fromEnvironment('CODE_KEY', defaultValue: '');

  ac.CodeBackend? _backend;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    if (_key.isEmpty) {
      _backend = ac.ServerCodeBackend(baseUrl: _serverUrl, appId: _appId);
      return;
    }
    final local = ac.LocalCodeBackend(
      appId: _appId,
      appCode: _appCode,
      types: _types,
      key: _key,
    );
    final server =
        ac.ServerCodeBackend(baseUrl: _serverUrl, appId: _appId);
    _backend =
        ac.SmartCodeBackend(local: local, server: server, appId: _appId);
  }

  bool get isReady => _backend != null;

  Future<ac.CodeResult> redeem(String code) async {
    await init();
    final backend = _backend;
    if (backend == null) {
      return const ac.CodeResult(
          ok: false, error: ac.CodeError.disabled);
    }
    return backend.redeem(code);
  }
}
