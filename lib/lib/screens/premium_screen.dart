import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/billing_service.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final BillingService _billing = BillingService();
  bool _loading = true;
  bool _buying = false;

  static const _bg = Color(0xFF0D0D1A);
  static const _accent = Color(0xFFFFD700);
  static const _card = Color(0xFF1A1A2E);
  static const _text = Colors.white;
  static const _textMid = Color(0xFF8888AA);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _billing.init();
    setState(() => _loading = false);
  }

  Future<void> _buy(ProductDetails? product) async {
    if (product == null || _buying) return;
    setState(() => _buying = true);
    try {
      await _billing.buyProduct(product);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка покупки. Попробуй позже.')),
        );
      }
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _accent))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Icon(Icons.auto_fix_high, size: 48, color: _accent.withOpacity(0.8)),
                    const SizedBox(height: 16),
                    const Text(
                      'Раскрой три руны',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _text),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Прошлое · Настоящее · Будущее',
                      style: TextStyle(fontSize: 14, color: _textMid),
                    ),
                    const SizedBox(height: 32),
                    _buildCard(
                      icon: Icons.diamond,
                      title: '299\u00a0\u20bd',
                      subtitle: '30 дней',
                      desc: 'Три руны каждый день в течение месяца',
                      product: _billing.days30Product,
                      highlight: false,
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      icon: Icons.stars,
                      title: '599\u00a0\u20bd',
                      subtitle: 'Навсегда',
                      desc: 'Три руны каждый день — без ограничений',
                      product: _billing.foreverProduct,
                      highlight: true,
                    ),
                    const Spacer(),
                    const Text(
                      'Оплата через Google Play. Подписка автоматически не продлевается.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: _textMid),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String desc,
    required ProductDetails? product,
    required bool highlight,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: highlight
            ? Border.all(color: _accent.withOpacity(0.4), width: 1.5)
            : Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _accent, size: 22),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: _text)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: _textMid)),
                ],
              ),
              const Spacer(),
              if (highlight)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('ЛУЧШЕЕ',
                      style: TextStyle(
                          fontSize: 9, fontWeight: FontWeight.bold, color: _accent)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(desc, style: const TextStyle(fontSize: 13, color: _textMid, height: 1.4)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _buying ? null : () => _buy(product),
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight ? _accent : _accent.withOpacity(0.15),
                foregroundColor: highlight ? _bg : _accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _buying
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: _bg))
                  : Text(
                      'Купить $title',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: highlight ? _bg : _accent,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
