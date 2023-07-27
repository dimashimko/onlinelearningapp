import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_learning_app/pages/home_page/home_page.dart';

part 'navigation_event.dart';

part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState()) {
    on<NavigateMenu>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStateStatus.menu,
          currentIndex: event.menuIndex,
          route: event.route,
        ),
      );
    });

    on<NavigateTab>((event, emit) {
      emit(
        state.copyWith(
          status: NavigationStateStatus.tab,
          currentIndex: event.tabIndex,
          route: event.route,
        ),
      );
    });
  }
}
