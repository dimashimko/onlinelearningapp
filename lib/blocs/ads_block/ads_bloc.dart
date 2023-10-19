import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/services/firestore_ads_service.dart';

part 'ads_event.dart';

part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  MyFirestoreAdsService adsService = MyFirestoreAdsService();

  AdsBloc() : super(const AdsState()) {
    on<GetAdsCoursesUids>(_getAdsCoursesUids);
  }

  void _getAdsCoursesUids(
    GetAdsCoursesUids event,
    Emitter<AdsState> emit,
  ) async {
    List<String> adsCoursesUids = await adsService.getAdsCoursesUids();

    emit(
      state.copyWith(
        adsCoursesUids: adsCoursesUids,
      ),
    );
  }
}
