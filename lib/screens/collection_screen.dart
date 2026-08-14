import 'package:flutter/material.dart';
import '../data/runes.dart';
import '../models/rune.dart';
import '../services/rune_service.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final RuneService _service = RuneService();
  List<Rune> _collected = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  Future<void> _loadCollection() async {
    await _service.init();
    if (!mounted) return;
    setState(() {
      _collected = _service.getCollectedRunesData();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F0F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F0F5),
        elevation: 0,
        title: const Text('Коллекция',
            style: TextStyle(color: Color(0xFF3D2C3A), fontWeight: FontWeight.w600)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF8E7F8A)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE8A0BF)))
          : SafeArea(
              bottom: false,
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: allRunes.length,
                itemBuilder: (context, index) {
                  final rune = allRunes[index];
                  final isCollected = _collected.any((r) => r.id == rune.id);
                  return _buildRuneCard(rune, isCollected);
                },
              ),
            ),
    );
  }

  Widget _buildRuneCard(Rune rune, bool isCollected) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isCollected ? Colors.white : const Color(0xFFEDE0E8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isCollected)
              Image.asset(rune.imagePath, fit: BoxFit.cover)
            else
              Container(color: const Color(0xFFEDE0E8)),
            if (!isCollected)
              Container(color: const Color(0xFFEDE0E8).withOpacity(0.7)),
            // Rune symbol
            Center(
              child: Text(
                rune.symbol,
                style: TextStyle(
                  fontSize: 48,
                  color: isCollected ? const Color(0xFFE8A0BF) : const Color(0xFFC0B0C0),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            // Name at bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Text(
                  rune.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isCollected ? Colors.white : const Color(0xFF3D2C3A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
