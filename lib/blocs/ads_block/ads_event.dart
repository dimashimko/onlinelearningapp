part of 'ads_bloc.dart';

@immutable
abstract class AdsEvent {
  const AdsEvent();
}

class GetAdsCoursesUids extends AdsEvent {}
