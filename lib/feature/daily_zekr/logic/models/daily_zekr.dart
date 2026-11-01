class DailyZekr {
  final int id;
  final String text;
  final String reference;
  final String? fadl;
  final bool isHadith;

  const DailyZekr({
    required this.id,
    required this.text,
    required this.reference,
    this.fadl,
    this.isHadith = false,
  });
}
