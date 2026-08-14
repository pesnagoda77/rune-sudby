import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rune.dart';
import '../data/runes.dart';

class RuneService {
  static final RuneService _instance = RuneService._internal();
  factory RuneService() => _instance;
  RuneService._internal();

  SharedPreferences? _prefs;
  static const String _lastDrawDateKey = 'last_draw_date';
  static const String _lastRuneIdKey = 'last_rune_id';
  static const String _pastRuneIdKey = 'past_rune_id';
  static const String _futureRuneIdKey = 'future_rune_id';
  static const String _collectedRunesKey = 'collected_runes';
  static const String _premiumKey = 'is_premium';

  static const String _ultraRuneId = 'dagaz';
  static const double _ultraRuneChance = 0.0004;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
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

  Rune _weightedDraw() {
    final random = Random();
    final roll = random.nextDouble();
    if (roll < _ultraRuneChance) {
      return allRunes.firstWhere((r) => r.id == _ultraRuneId);
    }
    final normalRunes = allRunes.where((r) => r.id != _ultraRuneId).toList();
    return normalRunes[random.nextInt(normalRunes.length)];
  }

  Future<Rune> drawRune() async {
    if (_prefs == null) await init();
    final now = DateTime.now();
    final rune = _weightedDraw();

    await _prefs!.setString(_lastDrawDateKey, now.toIso8601String());
    await _prefs!.setString(_lastRuneIdKey, rune.id);

    final collected = getCollectedRunes();
    if (!collected.contains(rune.id)) {
      collected.add(rune.id);
      await _prefs!.setStringList(_collectedRunesKey, collected);
    }
    return rune;
  }

  Future<void> drawExtraRunes() async {
    if (_prefs == null) await init();
    final past = _weightedDraw();
    final future = _weightedDraw();
    await _prefs!.setString(_pastRuneIdKey, past.id);
    await _prefs!.setString(_futureRuneIdKey, future.id);

    final collected = getCollectedRunes();
    if (!collected.contains(past.id)) {
      collected.add(past.id);
    }
    if (!collected.contains(future.id)) {
      collected.add(future.id);
    }
    await _prefs!.setStringList(_collectedRunesKey, collected);
  }

  Rune? getPastRune() {
    if (_prefs == null) return null;
    final id = _prefs!.getString(_pastRuneIdKey);
    if (id == null) return null;
    try {
      return allRunes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Rune? getFutureRune() {
    if (_prefs == null) return null;
    final id = _prefs!.getString(_futureRuneIdKey);
    if (id == null) return null;
    try {
      return allRunes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
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

  bool get isPremium {
    if (_prefs == null) return false;
    return _prefs!.getBool(_premiumKey) ?? false;
  }

  Future<void> setPremium(bool value) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_premiumKey, value);
  }

  bool get isLimited => !isPremium && !canDrawToday;
}
