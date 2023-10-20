import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/duration_range_model/duration_range_model.dart';
import 'package:online_learning_app/pages/search_page/search_page.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/utils/enums.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_light.dart';
import 'package:online_learning_app/widgets/sliders/custom_range_slider.dart';
import 'package:online_learning_app/widgets/uncategorized/custom_widget_switcher.dart';

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({Key? key}) : super(key: key);

  static const routeName = '/record_pages/start_record';

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  void _navigateToPage({
    required BuildContext context,
    required String route,
    bool isRoot = false,
    Object? arguments,
  }) {
    Navigator.of(
      context,
      rootNavigator: isRoot,
    ).pushNamed(
      route,
      arguments: arguments,
    );
  }

  void _goToSearchPage() async {
    Navigator.of(context).pop();
    if (context.read<CoursesBloc>().state.isFilterNavToSearchPage) {
      _navigateToPage(
        context: context,
        route: SearchPage.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32),
            ),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 24,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CoursesBloc, CoursesState>(
                builder: (context, state) {
                  FilterEnabledType filterEnabledType = state.filterEnabledType;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const TopPanelOfBottomSheet(),
                      const FilterCategories(
                        isEnable: true,
                      ),
                      FilterPrice(
                        isEnable:
                            filterEnabledType == FilterEnabledType.price ||
                                filterEnabledType == FilterEnabledType.all,
                      ),
                      FilterDuration(
                        isEnable:
                            filterEnabledType == FilterEnabledType.duration ||
                                filterEnabledType == FilterEnabledType.all,
                      ),
                      const NoteFilterByOneParameter(),
                      FilterButtons(
                        onTapClear: () {
                          context.read<CoursesBloc>().add(ClearFilters());
                        },
                        goToSearchPage: () => _goToSearchPage(),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FilterButtons extends StatelessWidget {
  const FilterButtons({
    required this.onTapClear,
    required this.goToSearchPage,
    super.key,
  });

  final VoidCallback onTapClear;
  final VoidCallback goToSearchPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: CustomButtonLight(
            title: 'Clear',
            padding: 4.0,
            onTap: () => onTapClear(),
          ),
        ),
        Flexible(
          flex: 7,
          child: CustomButton(
            title: 'Apply Filter',
            padding: 4.0,
            onTap: () => goToSearchPage(),
          ),
        )
      ],
    );
  }
}

class FilterDuration extends StatelessWidget {
  const FilterDuration({
    required this.isEnable,
    super.key,
  });

  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return CustomWidgetSwitcher(
      isEnable: isEnable,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterTitle(text: 'Duration'),
          DurationElementsFilter(),
        ],
      ),
    );
  }
}

class FilterPrice extends StatelessWidget {
  const FilterPrice({
    required this.isEnable,
    super.key,
  });

  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return CustomWidgetSwitcher(
      isEnable: isEnable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterTitle(text: 'Price'),
          PriceFilterSlider(
            initRangeValues:
                context.read<CoursesBloc>().state.filterPriceRangeValues,
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class FilterCategories extends StatelessWidget {
  const FilterCategories({
    required this.isEnable,
    super.key,
  });

  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return CustomWidgetSwitcher(
      isEnable: isEnable,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterTitle(text: 'Categories'),
          CategoriesElementsFilter(),
        ],
      ),
    );
  }
}

class TopPanelOfBottomSheet extends StatelessWidget {
  const TopPanelOfBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                AppIcons.close,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onBackground,
                  BlendMode.srcIn,
                ),
              ),
            ),
            onTap: () {
              context.read<CoursesBloc>().add(FilterBottomSheetDisable());
            },
          ),
          Text(
            'Search Filter',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

class DurationElementsFilter extends StatelessWidget {
  const DurationElementsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          return Wrap(
            runSpacing: 12.0,
            spacing: 12.0,
            children: state.filterDurationItems.map((durationItem) {
              return DurationElementsFilterItem(
                durationRange: durationItem,
                isEnable: durationItem.isEnable,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class DurationElementsFilterItem extends StatelessWidget {
  const DurationElementsFilterItem({
    required this.durationRange,
    required this.isEnable,
    super.key,
  });

  final DurationRangeModel durationRange;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CoursesBloc>().add(
              InverseDurationRangeItem(
                durationRange: durationRange,
              ),
            );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEnable
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceTint,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${durationRange.min}-${durationRange.max} Hours',
            style: isEnable
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class NoteFilterByOneParameter extends StatelessWidget {
  const NoteFilterByOneParameter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Note: Filtering is available only by one parameter',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.orange,
          ),
    );
  }
}

class FilterTitle extends StatelessWidget {
  const FilterTitle({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 16.0,
          ),
    );
  }
}

class CategoriesElementsFilter extends StatelessWidget {
  const CategoriesElementsFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          return Wrap(
            runSpacing: 12.0,
            spacing: 12.0,
            children: state.categoryList.map((category) {
              return CategoriesElementFilterItem(
                name: category.name ?? ' ',
                isEnable: state.filterCategory.contains(category.name),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class CategoriesElementFilterItem extends StatelessWidget {
  const CategoriesElementFilterItem({
    required this.name,
    required this.isEnable,
    super.key,
  });

  final String name;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isEnable
            ? context
                .read<CoursesBloc>()
                .add(ChangeFilterCategory(remove: name))
            : context.read<CoursesBloc>().add(ChangeFilterCategory(add: name));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEnable
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceTint,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: isEnable
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
