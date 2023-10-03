part of 'analytics_bloc.dart';


@immutable
class AnalyticsState extends Equatable {
  const AnalyticsState({
    this.counter = 0,
  });

  final int counter;

  //
  @override
  List<Object?> get props => [
        counter,
      ];

  AnalyticsState copyWith({
    int? counter,
  }) {
    return AnalyticsState(
      counter: counter ?? this.counter,
    );
  }
}
