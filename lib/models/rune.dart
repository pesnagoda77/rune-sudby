class Rune {
  final String id;
  final String name;
  final String symbol; // Unicode символ руны
  final String title;
  final String description;
  final String advice; // Наставление (настоящее время, для всех рун)
  final String predictionPast; // Событие прошлого
  final String predictionFuture; // Событие будущего
  final String element;
  final String imagePath; // assets/images/fehu.png

  Rune({
    required this.id,
    required this.name,
    required this.symbol,
    required this.title,
    required this.description,
    required this.advice,
    required this.predictionPast,
    required this.predictionFuture,
    required this.element,
    required this.imagePath,
  });
}
