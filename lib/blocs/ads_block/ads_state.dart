part of 'ads_bloc.dart';

@immutable
class AdsState extends Equatable {
  const AdsState({
    this.adsCoursesUids = const [],
  });

  final List<String> adsCoursesUids;

  @override
  List<Object?> get props => [
        adsCoursesUids,
      ];

  AdsState copyWith({
    List<String>? adsCoursesUids,
  }) {
    return AdsState(
      adsCoursesUids: adsCoursesUids ?? this.adsCoursesUids,
    );
  }
}
