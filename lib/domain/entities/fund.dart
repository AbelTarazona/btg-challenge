class Fund {
  final int id;
  final String name;
  final double minimumAmount;
  final String category;
  final String description;
  final String riskLevel;

  const Fund({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    required this.description,
    required this.riskLevel,
  });
}
