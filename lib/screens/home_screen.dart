import 'package:flutter/material.dart';
import '../models/rune.dart';
import '../services/rune_service.dart';
import 'collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final RuneService _service = RuneService();
  Rune? _todayRune;
  Rune? _pastRune;
  Rune? _futureRune;
  bool _isDrawing = false;
  bool _isDark = false;
  bool _isInit = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  static const _lightBg = Color(0xFFF9F0F5);
  static const _lightAccent = Color(0xFFE8A0BF);
  static const _lightCard = Colors.white;
  static const _lightText = Color(0xFF3D2C3A);
  static const _lightTextMid = Color(0xFF8E7F8A);
  static const _darkBg = Color(0xFF0D0D1A);
  static const _darkAccent = Color(0xFFFFD700);
  static const _darkCard = Color(0xFF1A1A2E);
  static const _darkText = Colors.white;
  static const _darkTextMid = Color(0xFF8888AA);

  Color get _bg => _isDark ? _darkBg : _lightBg;
  Color get _accent => _isDark ? _darkAccent : _lightAccent;
  Color get _card => _isDark ? _darkCard : _lightCard;
  Color get _text => _isDark ? _darkText : _lightText;
  Color get _textMid => _isDark ? _darkTextMid : _lightTextMid;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _loadLastRune();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadLastRune() async {
    try {
      await _service.init();
      final last = _service.getLastRune();
      if (mounted) {
        setState(() {
          _isInit = true;
          if (last != null) {
            _todayRune = last;
            if (_service.isPremium) {
              _pastRune = _service.getPastRune();
              _futureRune = _service.getFutureRune();
            }
          }
        });
        if (last != null) {
          _animController.forward();
        }
      }
    } catch (e, stack) {
      print('ERROR _loadLastRune: $e');
      print(stack);
      if (mounted) {
        setState(() => _isInit = true);
      }
    }
  }

  Future<void> _drawRune() async {
    try {
      if (!_service.canDrawToday) {
        _showLimitDialog();
        return;
      }
      setState(() => _isDrawing = true);
      await Future.delayed(const Duration(milliseconds: 900));
      final rune = await _service.drawRune();
      if (_service.isPremium) {
        await _service.drawExtraRunes();
      }
      if (!mounted) return;
      setState(() {
        _todayRune = rune;
        _isDrawing = false;
        if (_service.isPremium) {
          _pastRune = _service.getPastRune();
          _futureRune = _service.getFutureRune();
        }
      });
      _animController.reset();
      _animController.forward();
    } catch (e, stack) {
      print('ERROR _drawRune: $e');
      print(stack);
      if (mounted) {
        setState(() => _isDrawing = false);
      }
    }
  }

  void _showLimitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _card,
        title: Row(children: [
          Icon(Icons.diamond, color: _accent, size: 24),
          const SizedBox(width: 10),
          Text('Руна уже выпала', style: TextStyle(fontSize: 18, color: _text)),
        ]),
        content: Text('Сегодня ты уже получила руну дня.\nПремиум откроет руны прошлого и будущего — 299\u00a0\u20bd.',
            style: TextStyle(color: _textMid, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Позже', style: TextStyle(color: _textMid)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _service.setPremium(true);
              await _service.drawExtraRunes();
              if (!mounted) return;
              setState(() {
                _pastRune = _service.getPastRune();
                _futureRune = _service.getFutureRune();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: _isDark ? _darkBg : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Купить за 299\u00a0\u20bd',
              style: TextStyle(fontWeight: FontWeight.bold, color: _isDark ? _darkBg : Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _elementColor(String element) {
    switch (element) {
      case 'огонь': return const Color(0xFFE57373);
      case 'вода': return const Color(0xFF64B5F6);
      case 'воздух': return const Color(0xFF81D4FA);
      case 'земля': return const Color(0xFF81C784);
      default: return const Color(0xFFCE93D8);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      return Scaffold(
        backgroundColor: _isDark ? _darkBg : _lightBg,
        body: Center(child: CircularProgressIndicator(color: _accent)),
      );
    }
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          Expanded(
            child: _todayRune == null ? _buildEmptyState() : _buildRuneContent(),
          ),
          if (_todayRune != null) _buildBottomBar(),
          const SizedBox(height: 6),
        ]),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('МОЯ РУНА',
                style: TextStyle(color: _textMid.withOpacity(0.6), fontSize: 11,
                    fontWeight: FontWeight.w600, letterSpacing: 3)),
            Text('${_service.collectedCount}/${_service.totalCount}',
                style: TextStyle(color: _textMid.withOpacity(0.5), fontSize: 12)),
          ]),
          Row(children: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode,
                  color: _accent.withOpacity(0.7), size: 20),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
            IconButton(
              icon: Icon(Icons.grid_view_rounded, color: _accent.withOpacity(0.7), size: 20),
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const CollectionScreen())),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [_accent.withOpacity(0.25), _accent.withOpacity(0.0)]),
          ),
          child: Icon(Icons.auto_fix_high, size: 40, color: _accent),
        ),
        const SizedBox(height: 16),
        Text('Руна дня', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _text, letterSpacing: 2)),
        const SizedBox(height: 4),
        Text('Получи своё предсказание на сегодня', style: TextStyle(fontSize: 14, color: _textMid)),
        const SizedBox(height: 28),
        _buildDrawButton(),
      ],
    ));
  }

  Widget _buildRuneContent() {
    final rune = _todayRune!;
    final elemColor = _elementColor(rune.element);
    final isUltraRare = rune.id == 'dagaz';

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            Expanded(flex: 5, child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(rune.imagePath, fit: BoxFit.cover),
                  Container(decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.35)],
                    ),
                  )),
                  if (isUltraRare)
                    Positioned(top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('✦ РЕДКАЯ',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,
                              color: _isDark ? _darkBg : Colors.white)),
                      )),
                  Center(
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.35),
                        boxShadow: [BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.4), blurRadius: 16, spreadRadius: 2)],
                      ),
                      child: Center(
                        child: Text(rune.symbol,
                          style: TextStyle(
                            fontSize: 34,
                            color: const Color(0xFFFFD700),
                            fontWeight: FontWeight.w300,
                            shadows: [Shadow(color: const Color(0xFFFFD700), blurRadius: 8)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: elemColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(rune.element.toUpperCase(),
                  style: TextStyle(color: elemColor, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
              ),
              const SizedBox(width: 8),
              Text(rune.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _text, letterSpacing: 1)),
            ]),
            const SizedBox(height: 6),
            Expanded(flex: 2, child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                border: _isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(rune.title, style: TextStyle(fontSize: 12, color: _accent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(rune.description, style: TextStyle(fontSize: 14, color: _text, height: 1.45),
                    textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: -14),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isDark ? Colors.white.withOpacity(0.05) : _accent.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Column(children: [
                    Text('СОВЕТ ДНЯ', style: TextStyle(fontSize: 10, color: _accent, fontWeight: FontWeight.w600, letterSpacing: 1)),
                    const SizedBox(height: 4),
                    Text(rune.advice, style: TextStyle(fontSize: 13, color: _text, height: 1.4),
                        textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
                  ]),
                ),
              ]),
            )),
            if (_service.isPremium && _pastRune != null) ...[
              const SizedBox(height: 6),
              _buildExtraRuneCard(_pastRune!, 'РУНА ПРОШЛОГО', Icons.history),
            ],
            if (_service.isPremium && _futureRune != null) ...[
              const SizedBox(height: 6),
              _buildExtraRuneCard(_futureRune!, 'РУНА БУДУЩЕГО', Icons.auto_fix_high),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _buildExtraRuneCard(Rune rune, String label, IconData icon) {
    final elemColor = _elementColor(rune.element);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        boxShadow: _isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
        border: _isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 14, color: _accent.withOpacity(0.7)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 10, color: _accent, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 8),
        Text(rune.symbol, style: TextStyle(fontSize: 28, color: _accent, fontWeight: FontWeight.w300)),
        const SizedBox(height: 4),
        Text(rune.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _text)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: elemColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
          child: Text(rune.element.toUpperCase(), style: TextStyle(color: elemColor, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
        ),
        const SizedBox(height: 8),
        Text(rune.description, style: TextStyle(fontSize: 13, color: _text, height: 1.4), textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: _buildDrawButton(),
    );
  }

  Widget _buildDrawButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: _isDrawing ? null : _drawRune,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          foregroundColor: _isDark ? _darkBg : Colors.white,
          disabledBackgroundColor: _isDark ? const Color(0xFF3A3A55) : const Color(0xFFE0D0D8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _isDrawing
            ? SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: _isDark ? _darkBg : Colors.white))
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.auto_fix_high, size: 16),
                const SizedBox(width: 6),
                Text('ПОЛУЧИТЬ РУНУ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2,
                      color: _isDark ? _darkBg : Colors.white)),
              ]),
      ),
    );
  }
}
