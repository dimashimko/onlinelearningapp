class DurationRange {
  const DurationRange({
    required this.min,
    required this.max,
    required this.isEnable,
  });
  final int min;
  final int max;
  final bool isEnable;

  @override
  String toString() {
    return 'min: $min, max: $max, isEnable: $isEnable';
  }

  DurationRange copyWith({
    int? min,
    int? max,
    bool? isEnable,
  }) {
    return DurationRange(
      min: min ?? this.min,
      max: max ?? this.max,
      isEnable: isEnable ?? this.isEnable,
    );
  }

}
