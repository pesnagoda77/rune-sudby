import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/billing_service.dart';
import '../l10n/app_localizations.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final BillingService _billing = BillingService();
  StreamSubscription<String>? _messagesSub;
  bool _loading = true;
  bool _buying = false;
  bool _restoring = false;

  static const _bg = Color(0xFF0D0D1A);
  static const _accent = Color(0xFFFFD700);
  static const _card = Color(0xFF1A1A2E);
  static const _text = Colors.white;
  static const _textMid = Color(0xFF8888AA);

  static const _subscriptionCenterUrl =
      'https://play.google.com/store/account/subscriptions?package=com.slavanapps.runeday';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _messagesSub = _billing.messages.listen(_onMessage);
    await _billing.init();
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _messagesSub?.cancel();
    super.dispose();
  }

  void _onMessage(String messageKey) {
    if (!mounted) return;
    final text = AppLocalizations.of(context).t(messageKey);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _buy(ProductDetails? product) async {
    if (product == null || _buying) return;
    setState(() => _buying = true);
    try {
      await _billing.buyProduct(product);
      final ok = await _billing.waitForPremium();
      if (!mounted) return;
      Navigator.pop(context, ok);
    } catch (_) {
      _onMessage('msgPurchaseError');
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  Future<void> _restore() async {
    if (_restoring) return;
    setState(() => _restoring = true);
    final premium = await _billing.restore();
    if (!mounted) return;
    setState(() => _restoring = false);
    _onMessage(premium ? 'msgRestored' : 'msgNothingToRestore');
  }

  Future<void> _manageSubscription() async {
    try {
      final ok = await launchUrl(
        Uri.parse(_subscriptionCenterUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!ok && mounted) {
        _onMessage('couldNotOpenPlay');
      }
    } catch (_) {
      _onMessage('manageManualHint');
    }
  }

  String _priceText(ProductDetails? product) {
    if (product == null) return '—';
    final price = _billing.displayPrice(product);
    return price.isEmpty ? '—' : price;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                    Icon(Icons.auto_fix_high,
                        size: 48, color: _accent.withOpacity(0.8)),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context).t('premiumTitle'),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _text),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context).t('premiumSubtitle'),
                      style: TextStyle(fontSize: 14, color: _textMid),
                    ),
                    const SizedBox(height: 32),
                    _buildCard(
                      icon: Icons.diamond,
                      title: _priceText(_billing.days30Product),
                      subtitle: l10n.t('subPeriod'),
                      desc: l10n.t('subDesc'),
                      product: _billing.days30Product,
                      highlight: false,
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      icon: Icons.stars,
                      title: _priceText(_billing.foreverProduct),
                      subtitle: l10n.t('forever'),
                      desc: l10n.t('foreverDesc'),
                      product: _billing.foreverProduct,
                      highlight: true,
                    ),
                    const Spacer(),
                    Text(
                      AppLocalizations.of(context).t('legal'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: _textMid),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _manageSubscription,
                      icon: const Icon(Icons.settings_outlined,
                          size: 16, color: _accent),
                      label: Text(l10n.t('manageSubscription'),
                          style: const TextStyle(fontSize: 12, color: _accent)),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: _restoring ? null : _restore,
                        icon: _restoring
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: _accent))
                            : const Icon(Icons.refresh,
                                size: 16, color: _accent),
                        label: Text(
                          _restoring ? l10n.t('restoring') : l10n.t('restore'),
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _accent),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: _accent.withOpacity(0.4), width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _text)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: _textMid)),
                ],
              ),
              const Spacer(),
              if (highlight)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                      AppLocalizations.of(context).t('best'),
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: _accent)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(desc,
              style: const TextStyle(
                  fontSize: 13, color: _textMid, height: 1.4)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: (_buying || product == null)
                  ? null
                  : () => _buy(product),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    highlight ? _accent : _accent.withOpacity(0.15),
                foregroundColor: highlight ? _bg : _accent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _buying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: _bg))
                  : Text(
                      '${l10n.t('buy')} $title',
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
