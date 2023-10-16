import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/services/firestore_ads_service.dart';

part 'ads_event.dart';

part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(const AdsState()) {
    MyFirestoreAdsService adsService = MyFirestoreAdsService();

    on<GetAdsCoursesUids>(
      (event, emit) async {
        List<String> adsCoursesUids = await adsService.getAdsCoursesUids();
        log('*** adsCoursesUids: $adsCoursesUids');

        emit(
          state.copyWith(
            adsCoursesUids: adsCoursesUids,
          ),
        );
      },
    );

  }
}
