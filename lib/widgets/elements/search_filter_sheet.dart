import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/duration_range/duration_range.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/test/test08.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_light.dart';
import 'package:online_learning_app/widgets/elements/custom_range_slider/custom_range_slider_v1.dart';
import 'package:online_learning_app/widgets/elements/custom_range_slider/custom_range_slider_v2.dart';
import 'package:range_slider_flutter/range_slider_flutter.dart';

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({Key? key}) : super(key: key);

  static const routeName = '/record_pages/start_record';

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  void _goToSearchPage() async {
    // log('*** _goToStopRecordPage');
    // Navigator.of(context).pop();
    // _navigateToPage(context, StopRecordPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
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
                                context
                                    .read<CoursesBloc>()
                                    .add(FilterBottomSheetDisable());
                              },
                            ),
                            Text(
                              'Search Filter',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                      const FilterTitle(text: 'Categories'),
                      const CategoriesElementsFilter(),
                      const FilterTitle(text: 'Price'),
                      const PriceFilterSlider(),
                      // const PriceFilterSliderFromGit(),
                      const FilterTitle(text: 'Duration'),
                      const DurationElementsFilter(),
                      Row(
                        children: [
                          Flexible(
                            flex: 4,
                            child: CustomButtonLight(
                              title: 'Clear',
                              padding: 4.0,
                              onTap: () {},
                            ),
                          ),
                          Flexible(
                            flex: 7,
                            child: CustomButton(
                              title: 'Apply Filter',
                              padding: 4.0,
                              onTap: () {},
                            ),
                          )
                        ],
                      )

                      // DurationRange
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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
            children: state.durationItems.map((durationItem) {
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

  final DurationRange durationRange;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CoursesBloc>().add(InverseDurationRangeItem(
              durationRange: durationRange,
            ));
        // isEnable
        //     ? context
        //     .read<CoursesBloc>()
        //     .add(ChangeCategoryFilter(remove: durationRange))
        //     : context.read<CoursesBloc>().add(
        //     ChangeCategoryFilter(add: durationRange));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEnable
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.scrim,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${durationRange.min}-${durationRange.max} Hours',
            style: isEnable
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
            // : Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class PriceFilterSlider extends StatefulWidget {
  const PriceFilterSlider({super.key});

  @override
  State<PriceFilterSlider> createState() => _PriceFilterSliderState();
}

class _PriceFilterSliderState extends State<PriceFilterSlider> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        activeTrackColor: Theme.of(context).colorScheme.primary,
        inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
        overlayColor: Colors.black12,
        valueIndicatorColor: Theme.of(context).colorScheme.primary,
        thumbColor: Theme.of(context).colorScheme.primary,
        // thumbColor: Colors.red,
        // rangeThumbShape: CustomRangeThumbShape(),
        showValueIndicator: ShowValueIndicator.always,
      ),
      child: RangeSlider(
        values: _currentRangeValues,
        max: 100,
        // divisions: 20,
        labels: RangeLabels(
          _currentRangeValues.start.round().toString(),
          _currentRangeValues.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _currentRangeValues = values;
          });
        },
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
                isEnable: state.categoryFilter.contains(category.name),
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
                .add(ChangeCategoryFilter(remove: name))
            : context.read<CoursesBloc>().add(ChangeCategoryFilter(add: name));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isEnable
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.scrim,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: isEnable
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyLarge,
            // : Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
