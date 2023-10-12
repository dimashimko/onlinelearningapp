part of 'ads_bloc.dart';

@immutable
abstract class AdsEvent {
  const AdsEvent();
}

// class SomeEvent extends PlayerEvent {}

class GetAdsCoursesUids extends AdsEvent {}

/*class SomeEvent extends AdsEvent {
  const SomeEvent({
    required this.counter,
  });

  final int counter;
}*/
