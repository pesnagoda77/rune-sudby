class Rune {
  final String id;
  final String name;
  final String symbol; // Unicode символ руны
  final String title;
  final String description;
  final String advice;
  final String element;
  final String imagePath; // assets/images/fehu.png

  Rune({
    required this.id,
    required this.name,
    required this.symbol,
    required this.title,
    required this.description,
    required this.advice,
    required this.element,
    required this.imagePath,
  });
}