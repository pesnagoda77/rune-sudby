import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rune.dart';
import '../data/runes.dart';
import 'billing_service.dart';

class RuneService {
  static final RuneService _instance = RuneService._internal();
  factory RuneService() => _instance;
  RuneService._internal();

  SharedPreferences? _prefs;
  final BillingService _billing = BillingService();

  static const String _lastDrawDateKey = 'last_draw_date';
  static const String _lastRuneIdKey = 'last_rune_id';
  static const String _lastPastRuneIdKey = 'last_past_rune_id';
  static const String _lastFutureRuneIdKey = 'last_future_rune_id';
  static const String _collectedRunesKey = 'collected_runes';
  static const String _drawStepKey = 'draw_step'; // 'none' | 'present' | 'past' | 'future' | 'done'

  static const String _ultraRuneId = 'dagaz';
  static const double _ultraRuneChance = 0.0004;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _billing.init();
    _checkDayReset();
  }

  void _checkDayReset() {
    if (_prefs == null) return;
    final lastDrawStr = _prefs!.getString(_lastDrawDateKey);
    if (lastDrawStr == null) return;
    final lastDraw = DateTime.parse(lastDrawStr);
    final now = DateTime.now();
    final isNewDay = lastDraw.year != now.year ||
        lastDraw.month != now.month ||
        lastDraw.day != now.day;
    if (isNewDay) {
      // Reset draw step for new day
      _prefs!.remove(_drawStepKey);
    }
  }

  bool get canDrawToday {
    if (_prefs == null) return false;
    final lastDrawStr = _prefs!.getString(_lastDrawDateKey);
    if (lastDrawStr == null) return true;
    final lastDraw = DateTime.parse(lastDrawStr);
    final now = DateTime.now();
    return lastDraw.year != now.year ||
        lastDraw.month != now.month ||
        lastDraw.day != now.day;
  }

  Future<bool> get isPremium async {
    if (await _debugPremium) return true;
    return await _billing.isPremium();
  }

  Future<bool> get _debugPremium async {
    if (_prefs == null) return false;
    return _prefs!.getBool('debug_premium') ?? false;
  }

  Rune _weightedDraw() {
    final random = Random();
    final roll = random.nextDouble();
    if (roll < _ultraRuneChance) {
      return allRunes.firstWhere((r) => r.id == _ultraRuneId);
    }
    final normalRunes = allRunes.where((r) => r.id != _ultraRuneId).toList();
    return normalRunes[random.nextInt(normalRunes.length)];
  }

  /// Бесплатная руна (1 руна)
  Future<Rune> drawRune() async {
    if (_prefs == null) await init();
    final now = DateTime.now();
    final rune = _weightedDraw();

    await _prefs!.setString(_lastDrawDateKey, now.toIso8601String());
    await _prefs!.setString(_lastRuneIdKey, rune.id);
    await _prefs!.remove(_lastPastRuneIdKey);
    await _prefs!.remove(_lastFutureRuneIdKey);
    await _prefs!.setString(_drawStepKey, 'done');

    _saveToCollection(rune.id);
    return rune;
  }

  /// Премиум: пошаговое вытягивание
  /// Шаг 1: Настоящее
  Future<Rune> drawPresentRune() async {
    if (_prefs == null) await init();
    final now = DateTime.now();
    final rune = _weightedDraw();

    await _prefs!.setString(_lastDrawDateKey, now.toIso8601String());
    await _prefs!.setString(_lastRuneIdKey, rune.id);
    await _prefs!.remove(_lastPastRuneIdKey);
    await _prefs!.remove(_lastFutureRuneIdKey);
    await _prefs!.setString(_drawStepKey, 'present');

    _saveToCollection(rune.id);
    return rune;
  }

  /// Шаг 2: Прошлое
  Future<Rune> drawPastRune() async {
    if (_prefs == null) await init();
    var rune = _weightedDraw();
    final presentId = _prefs!.getString(_lastRuneIdKey);
    // Ensure different from present
    int attempts = 0;
    while (rune.id == presentId && attempts < 50) {
      rune = _weightedDraw();
      attempts++;
    }

    await _prefs!.setString(_lastPastRuneIdKey, rune.id);
    await _prefs!.setString(_drawStepKey, 'past');
    _saveToCollection(rune.id);
    return rune;
  }

  /// Шаг 3: Будущее
  Future<Rune> drawFutureRune() async {
    if (_prefs == null) await init();
    var rune = _weightedDraw();
    final presentId = _prefs!.getString(_lastRuneIdKey);
    final pastId = _prefs!.getString(_lastPastRuneIdKey);
    // Ensure different from present and past
    int attempts = 0;
    while ((rune.id == presentId || rune.id == pastId) && attempts < 50) {
      rune = _weightedDraw();
      attempts++;
    }

    await _prefs!.setString(_lastFutureRuneIdKey, rune.id);
    await _prefs!.setString(_drawStepKey, 'done');
    _saveToCollection(rune.id);
    return rune;
  }

  String get drawStep {
    if (_prefs == null) return 'none';
    if (canDrawToday) return 'none';
    return _prefs!.getString(_drawStepKey) ?? 'none';
  }

  Future<void> _saveToCollection(String id) async {
    final collected = getCollectedRunes();
    if (!collected.contains(id)) {
      collected.add(id);
      await _prefs!.setStringList(_collectedRunesKey, collected);
    }
  }

  Rune? getLastRune() {
    if (_prefs == null) return null;
    final id = _prefs!.getString(_lastRuneIdKey);
    if (id == null) return null;
    try {
      return allRunes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Rune? getLastPastRune() {
    if (_prefs == null) return null;
    final id = _prefs!.getString(_lastPastRuneIdKey);
    if (id == null) return null;
    try {
      return allRunes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Rune? getLastFutureRune() {
    if (_prefs == null) return null;
    final id = _prefs!.getString(_lastFutureRuneIdKey);
    if (id == null) return null;
    try {
      return allRunes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<String> getCollectedRunes() {
    if (_prefs == null) return [];
    return _prefs!.getStringList(_collectedRunesKey) ?? [];
  }

  List<Rune> getCollectedRunesData() {
    final ids = getCollectedRunes();
    return allRunes.where((r) => ids.contains(r.id)).toList();
  }

  int get collectedCount => getCollectedRunes().length;
  int get totalCount => allRunes.length;

  Future<bool> get isLimited async {
    final premium = await isPremium;
    if (premium) {
      final step = drawStep;
      return step == 'done' && !canDrawToday;
    }
    return !canDrawToday;
  }

  /// Если премиум активировался ПОСЛЕ бесплатной руны этого дня — разрешить
  /// продолжить триадой (Прошлое + Будущее) в тот же день.
  Future<void> continuePremiumToday() async {
    if (_prefs == null) await init();
    if (drawStep != 'done') return;
    final lastDrawStr = _prefs!.getString(_lastDrawDateKey);
    if (lastDrawStr == null) return;
    final lastDraw = DateTime.parse(lastDrawStr);
    final now = DateTime.now();
    final sameDay = lastDraw.year == now.year &&
        lastDraw.month == now.month &&
        lastDraw.day == now.day;
    if (!sameDay) return;
    final hasPast = _prefs!.getString(_lastPastRuneIdKey) != null;
    final hasFuture = _prefs!.getString(_lastFutureRuneIdKey) != null;
    if (hasPast || hasFuture) return; // триада уже начата/завершена
    await _prefs!.setString(_drawStepKey, 'present');
  }

  /// DEBUG: Принудительно включить/выключить премиум (для теста)
  Future<void> debugSetPremium(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool('debug_premium', value);
    // If enabling premium and already drew today, reset step to continue
    if (value) {
      final step = drawStep;
      if (step == 'done') {
        final hasPresent = _prefs!.getString(_lastRuneIdKey) != null;
        if (hasPresent) {
          await _prefs!.setString(_drawStepKey, 'present');
        }
      }
    }
  }
}
