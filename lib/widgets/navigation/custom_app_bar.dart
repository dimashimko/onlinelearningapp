import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class CustomAppBarDefault extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBarDefault({
    Key? key,
    this.title,
    this.onLeading,
  }) : super(key: key);

  final String? title;
  final void Function()? onLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: SvgPicture.asset(
        AppIcons.arrow_back,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSecondaryContainer,
          BlendMode.srcIn,
        ),
      ),
      // onLeading: onLeading,
      onLeading: () {
        Navigator.of(context).pop();
      },
      title: Text(
        title ?? '',
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 24.0,
            ),
      ),
      action: const Text(
        '          ',
        // style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.leading,
    this.action,
    this.onAction,
    this.onLeading,
    this.backgroundColor,
  }) : super(key: key);

  final Color? backgroundColor;
  final Widget? title;
  final Widget? leading;
  final Widget? action;
  final void Function()? onAction;
  final void Function()? onLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: AppFonts.bold,
        fontSize: 20.0,
      ),
      actions: [
        if (action != null)
          InkWell(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [action!],
              ),
            ),
          )
      ],
      leading: leading != null
          ? InkWell(
              onTap: onLeading,
              child: Stack(
                alignment: Alignment.center,
                children: [leading!],
              ),
            )
          : null,
      title: title,
    );
  }
}
