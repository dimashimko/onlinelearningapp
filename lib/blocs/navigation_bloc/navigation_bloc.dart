import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';
import 'package:online_learning_app/utils/enums.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateMenu>(_navigateMenu);
    on<NavigateTab>(_navigateTab);
  }

  void _navigateMenu(
    NavigateMenu event,
    Emitter<NavigationState> emit,
  ) {
    emit(
      state.copyWith(
        status: NavigationStateStatus.menu,
        currentIndex: event.menuIndex,
        route: event.route,
      ),
    );
  }

  void _navigateTab(
    NavigateTab event,
    Emitter<NavigationState> emit,
  ) {
    emit(
      state.copyWith(
        status: NavigationStateStatus.tab,
        currentIndex: event.tabIndex,
        route: event.route,
      ),
    );
  }
}

