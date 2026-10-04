import 'package:flutter/material.dart';
import '../data/runes.dart';
import '../models/rune.dart';
import '../services/rune_service.dart';
import 'collection_screen.dart';
import 'premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final RuneService _service = RuneService();
  Rune? _presentRune;
  Rune? _pastRune;
  Rune? _futureRune;
  bool _isDrawing = false;
  bool _isDark = false;
  bool _isPremium = false;
  int _tapCount = 0;
  final PageController _pageController = PageController();

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
    _animController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOutCubic));
    _loadLastDraw();
  }

  @override
  void dispose() {
    _animController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadLastDraw() async {
    await _service.init();
    final premium = await _service.isPremium;
    if (premium) {
      await _service.continuePremiumToday();
    }
    if (mounted) {
      setState(() => _isPremium = premium);
    }
    final step = _service.drawStep;
    if (step != 'none') {
      final present = _service.getLastRune();
      final past = _service.getLastPastRune();
      final future = _service.getLastFutureRune();
      if (mounted) {
        setState(() {
          _presentRune = present;
          _pastRune = past;
          _futureRune = future;
        });
        _animController.forward();
      }
    }
  }

  Future<void> _drawRune() async {
    final limited = await _service.isLimited;
    if (limited) {
      _showLimitDialog();
      return;
    }

    setState(() => _isDrawing = true);
    await Future.delayed(const Duration(milliseconds: 900));

    final premium = await _service.isPremium;
    if (mounted && premium != _isPremium) {
      setState(() => _isPremium = premium);
    }
    final step = _service.drawStep;

    if (premium) {
      if (step == 'none') {
        final rune = await _service.drawPresentRune();
        if (!mounted) return;
        setState(() {
          _presentRune = rune;
          _isDrawing = false;
        });
      } else if (step == 'present') {
        final rune = await _service.drawPastRune();
        if (!mounted) return;
        setState(() {
          _pastRune = rune;
          _isDrawing = false;
        });
        _jumpToLastPage();
      } else if (step == 'past') {
        final rune = await _service.drawFutureRune();
        if (!mounted) return;
        setState(() {
          _futureRune = rune;
          _isDrawing = false;
        });
        _jumpToLastPage();
      }
    } else {
      final rune = await _service.drawRune();
      if (!mounted) return;
      setState(() {
        _presentRune = rune;
        _isDrawing = false;
      });
    }

    _animController.reset();
    _animController.forward();
  }

  void _jumpToLastPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final count = _runesCount;
      if (count > 0 && _pageController.hasClients) {
        _pageController.animateToPage(
          count - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  int get _runesCount {
    int count = 0;
    if (_presentRune != null) count++;
    if (_pastRune != null) count++;
    if (_futureRune != null) count++;
    return count;
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
          Text('Руна уже выпала',
              style: TextStyle(fontSize: 18, color: _text)),
        ]),
        content: Text(
            'Сегодня ты уже получила свою руну.\n\nОткрой три руны: Прошлое, Настоящее и Будущее.',
            style: TextStyle(color: _textMid, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Позже', style: TextStyle(color: _textMid)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openPremium();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: _isDark ? _darkBg : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Открыть три руны',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _isDark ? _darkBg : Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _openPremium() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PremiumScreen()),
    );
    // После возврата перечитываем статус: если покупка прошла — включаем
    // премиум и продолжаем три руны в тот же день.
    final premium = await _service.isPremium;
    if (premium) {
      await _service.continuePremiumToday();
    }
    if (mounted) setState(() => _isPremium = premium);
  }

  Color _elementColor(String element) {
    switch (element) {
      case 'огонь':
        return const Color(0xFFE57373);
      case 'вода':
        return const Color(0xFF64B5F6);
      case 'воздух':
        return const Color(0xFF81D4FA);
      case 'земля':
        return const Color(0xFF81C784);
      default:
        return const Color(0xFFCE93D8);
    }
  }

  String _getAdviceForRune(Rune rune, String type) {
    switch (type) {
      case 'past':
        return '${rune.predictionPast}\n\n${rune.advice}';
      case 'future':
        return '${rune.predictionFuture}\n\n${rune.advice}';
      case 'present':
      default:
        return rune.advice;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAnyRune = _presentRune != null || _pastRune != null || _futureRune != null;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(),
          Expanded(
            child: !hasAnyRune ? _buildEmptyState() : _buildRunesPager(),
          ),
          _buildBottomBar(),
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
          GestureDetector(
            onTap: () async {
              _tapCount++;
              if (_tapCount >= 5) {
                _tapCount = 0;
                await _service.debugSetPremium(true);
                final premium = await _service.isPremium;
                if (mounted) {
                  setState(() => _isPremium = premium);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Премиум активирован (debug)')));
                }
              }
            },
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('МОЯ РУНА',
                  style: TextStyle(
                      color: _textMid.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3)),
              Text('${_service.collectedCount}/${_service.totalCount}',
                  style: TextStyle(
                      color: _textMid.withOpacity(0.5), fontSize: 12)),
            ]),
          ),
          Row(children: [
            IconButton(
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode,
                  color: _accent.withOpacity(0.7), size: 20),
              onPressed: () => setState(() => _isDark = !_isDark),
            ),
            IconButton(
              icon: Icon(Icons.grid_view_rounded,
                  color: _accent.withOpacity(0.7), size: 20),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CollectionScreen())),
            ),
            TextButton.icon(
              onPressed: _openPremium,
              icon: Icon(Icons.workspace_premium, size: 18, color: _accent),
              label: Text('Премиум',
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: _accent)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
                colors: [_accent.withOpacity(0.25), _accent.withOpacity(0.0)]),
          ),
          child: Icon(Icons.auto_fix_high, size: 40, color: _accent),
        ),
        const SizedBox(height: 16),
        Text('Руна дня',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _text,
                letterSpacing: 2)),
        const SizedBox(height: 4),
        Text('Получи своё предсказание на сегодня',
            style: TextStyle(fontSize: 14, color: _textMid)),
      ],
    ));
  }

  Widget _buildRunesPager() {
    final runes = <_RuneDisplay>[];
    if (_presentRune != null) {
      runes.add(_RuneDisplay(_presentRune!, 'НАСТОЯЩЕЕ', 'present'));
    }
    if (_pastRune != null) {
      runes.add(_RuneDisplay(_pastRune!, 'ПРОШЛОЕ', 'past'));
    }
    if (_futureRune != null) {
      runes.add(_RuneDisplay(_futureRune!, 'БУДУЩЕЕ', 'future'));
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: runes.length,
      itemBuilder: (ctx, index) {
        final item = runes[index];
        return _buildFullRunePage(item.rune, item.label, item.type);
      },
    );
  }

  Widget _buildFullRunePage(Rune rune, String label, String type) {
    final elemColor = _elementColor(rune.element);
    final isUltraRare = rune.id == 'dagaz';
    final adviceText = _getAdviceForRune(rune, type);

    return FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            // Label
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: _accent)),
            ),
            // Image
            Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(rune.imagePath, fit: BoxFit.cover),
                      Container(
                          decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.05),
                            Colors.black.withOpacity(0.35)
                          ],
                        ),
                      )),
                      if (isUltraRare)
                        Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _accent.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('✦ РЕДКАЯ',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: _isDark
                                          ? _darkBg
                                          : Colors.white)),
                            )),
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.35),
                          ),
                          child: Center(
                            child: Text(rune.symbol,
                                style: TextStyle(
                                  fontSize: 34,
                                  color: const Color(0xFFFFD700),
                                  fontWeight: FontWeight.w300,
                                  shadows: [
                                    Shadow(
                                        color: const Color(0xFFFFD700),
                                        blurRadius: 8)
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 6),
            // Name row
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: elemColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(rune.element.toUpperCase(),
                    style: TextStyle(
                        color: elemColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5)),
              ),
              const SizedBox(width: 8),
              Text(rune.name,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _text,
                      letterSpacing: 1)),
            ]),
            const SizedBox(height: 1),
            Text(rune.title,
                style: TextStyle(
                    fontSize: 12,
                    color: _textMid.withOpacity(0.7),
                    fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            // Advice card
            Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: _isDark
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                                offset: const Offset(0, 2))
                          ],
                    border: _isDark
                        ? Border.all(color: Colors.white.withOpacity(0.06))
                        : null,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(adviceText,
                            style: TextStyle(
                                fontSize: 14, color: _text, height: 1.45),
                            textAlign: TextAlign.center,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis),
                      ]),
                )),
          ]),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: _buildDrawButton(),
    );
  }

  String _getButtonText() {
    final step = _service.drawStep;
    if (!_isPremium) {
      // Бесплатный режим — всегда 1 руна
      if (step == 'done') return 'УЗНАЙ СУДЬБУ ЗАВТРА';
      return 'ПОЛУЧИТЬ РУНУ';
    }
    // Премиум — пошагово
    switch (step) {
      case 'present':
        return 'ПОЛУЧИТЬ РУНУ ПРОШЛОГО';
      case 'past':
        return 'ПОЛУЧИТЬ РУНУ БУДУЩЕГО';
      case 'future':
      case 'done':
        return 'УЗНАЙ СУДЬБУ ЗАВТРА';
      case 'none':
      default:
        return 'ПОЛУЧИТЬ ТРИ РУНЫ';
    }
  }

  bool _isButtonDisabled() {
    final step = _service.drawStep;
    return step == 'future' || step == 'done' || _isDrawing;
  }

  Widget _buildDrawButton() {
    final disabled = _isButtonDisabled();
    final text = _getButtonText();

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: disabled ? null : _drawRune,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? (_isDark ? const Color(0xFF3A3A55) : const Color(0xFFE0D0D8))
              : _accent,
          foregroundColor: _isDark ? _darkBg : Colors.white,
          disabledBackgroundColor:
              _isDark ? const Color(0xFF3A3A55) : const Color(0xFFE0D0D8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: _isDrawing
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: _isDark ? _darkBg : Colors.white))
            : Text(
                text,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: disabled
                        ? _textMid
                        : (_isDark ? _darkBg : Colors.white)),
              ),
      ),
    );
  }
}

class _RuneDisplay {
  final Rune rune;
  final String label;
  final String type;
  _RuneDisplay(this.rune, this.label, this.type);
}
