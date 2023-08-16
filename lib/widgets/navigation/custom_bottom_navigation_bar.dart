import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
    required this.currentTab,
    required this.onSelect,
  }) : super(key: key);

  final int currentTab;
  final void Function(int) onSelect;

  static const List<_BottomNavigationBarItem> _items = [
    _BottomNavigationBarItem(
      iconPath: AppIcons.home,
      title: 'Home',
    ),
    _BottomNavigationBarItem(
      iconPath: AppIcons.course,
      title: 'Course',
    ),
    _BottomNavigationBarItem(
      iconPath: AppIcons.search,
      title: 'Search',
    ),
    _BottomNavigationBarItem(
      iconPath: AppIcons.message,
      title: 'Message',
    ),
    _BottomNavigationBarItem(
      iconPath: AppIcons.account,
      title: 'Account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: kBottomNavigationBarHeight,
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom / 2,
      ),
/*      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: AppColors.secondary.withOpacity(0.1),
          ),
        ),
      ),*/
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _items.map((e) {
          final int i = _items.indexOf(e);

          return Flexible(
            child: SizedBox(
              width: double.infinity,
              // height: kBottomNavigationBarHeight,
              height: 72.0,
              child: Material(
                // color: Theme.of(context).colorScheme.background,
                // color: Colors.transparent,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onSelect(i),
                  // highlightColor: Colors.transparent,
                  // highlightColor: Colors.red,
                  // highlightColor: Colors.white,
                  // splashColor: Colors.white,
                  highlightColor: Theme.of(context).colorScheme.background,
                  splashColor: Theme.of(context).colorScheme.background,
                  // highlightColor: Theme.of(context).colorScheme.background,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppIcons.rectangle2,
                        color: i == currentTab
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.background,
                      ),
                      const SizedBox(height: 12.0),
                      SvgPicture.asset(
                        e.iconPath,
                        color: i == currentTab
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.scrim,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        e.title,
                        style: TextStyle(
                          color: i == currentTab
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outlineVariant,
                          fontSize: 11.0,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomNavigationBarItem {
  const _BottomNavigationBarItem({
    required this.iconPath,
    required this.title,
  });

  final String iconPath;
  final String title;
}
