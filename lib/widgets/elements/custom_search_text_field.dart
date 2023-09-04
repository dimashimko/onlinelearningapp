import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/blocs/courses_bloc/courses_bloc.dart';
import 'package:online_learning_app/models/course/course_model.dart';
import 'package:online_learning_app/resources/app_icons.dart';

class FindTextField extends StatefulWidget {
  const FindTextField({
    required this.searchController,
    required this.onTapSetting,
    required this.onTap,
    required this.isReadOnly,
    super.key,
  });

  final TextEditingController searchController;
  final VoidCallback onTapSetting;
  final VoidCallback onTap;
  final bool isReadOnly;

  @override
  State<FindTextField> createState() => _FindTextFieldState();
}

class _FindTextFieldState extends State<FindTextField> {
  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(() {
      setState(() {});
      // add Bloc Event
    });
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(
        // color: Colors.red,
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
    );
    return TextField(
      controller: widget.searchController,
      readOnly: widget.isReadOnly,
      onTap: () {
        widget.onTap();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.inverseSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            AppIcons.search_grey,
          ),
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.searchController.text.isNotEmpty)
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: SvgPicture.asset(
                    AppIcons.clear_text,
                  ),
                ),
                onTap: () {
                  widget.searchController.text = '';
                },
              ),
            const SizedBox(width: 8.0),
            InkWell(
              splashColor: Colors.transparent,
              onTap: widget.onTapSetting,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: SvgPicture.asset(
                  AppIcons.filter,
                ),
              ),
            ),
          ],
        ),
        // errorMaxLines: 2,
        // border: InputBorder.none,
        border: customBorder,
        focusedBorder: customBorder,
        enabledBorder: customBorder,
        hintText: 'Find Cousre',
        hintStyle: Theme.of(context).textTheme.titleSmall,
        // suffixIcon: widget.suffixIcon,
        // suffixIconColor: AppColors.white,
        // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}



