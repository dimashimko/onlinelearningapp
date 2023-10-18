import 'package:equatable/equatable.dart';

class DurationRangeModel extends Equatable {
  final int min;
  final int max;
  final bool isEnable;

  const DurationRangeModel({
    required this.min,
    required this.max,
    required this.isEnable,
  });

  DurationRangeModel copyWith({
    int? min,
    int? max,
    bool? isEnable,
  }) {
    return DurationRangeModel(
      min: min ?? this.min,
      max: max ?? this.max,
      isEnable: isEnable ?? this.isEnable,
    );
  }

  @override
  List<Object?> get props => [
        min,
        max,
        isEnable,
      ];
}
