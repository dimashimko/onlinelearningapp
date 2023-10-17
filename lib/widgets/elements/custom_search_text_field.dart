import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(
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
            AppIcons.searchGrey,
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
                    AppIcons.clearText,
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
        border: customBorder,
        focusedBorder: customBorder,
        enabledBorder: customBorder,
        hintText: 'Find Cousre',
        hintStyle: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
