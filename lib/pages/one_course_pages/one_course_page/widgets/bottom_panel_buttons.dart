import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/progress_bloc/progress_bloc.dart';
import 'package:online_learning_app/models/progress/progress_model.dart';
import 'package:online_learning_app/widgets/buttons/custom_button.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_light.dart';
import 'package:online_learning_app/widgets/buttons/custom_button_star.dart';

class BottomPanelButtons extends StatelessWidget {
  const BottomPanelButtons({
    required this.onTapFavoriteButton,
    required this.onTapBuyButton,
    super.key,
  });

  final VoidCallback onTapFavoriteButton;
  final VoidCallback onTapBuyButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, -4), // Shadow position
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(8.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: BlocBuilder<ProgressBloc, ProgressState>(
          builder: (context, state) {
            CourseProgressModel? currentCourseProgressModel =
            state.userProgress?[state.currentCourseUid];

            return Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: StarButton(
                    isEnable: (currentCourseProgressModel?.favorites) ?? false,
                    onTap: () {
                      onTapFavoriteButton();
                    },
                  ),
                ),
                const SizedBox(width: 12.0),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: (currentCourseProgressModel?.bought ?? false)
                      ? const CustomButtonLight(
                    title: 'Bought ✓ ',
                    onTap: null,
                  )
                      : CustomButton(
                    title: 'Buy Now',
                    onTap: () {
                      onTapBuyButton();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
