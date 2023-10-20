import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_learning_app/models/slide_model/slide_model.dart';

class CustomSlideItem extends StatelessWidget {
  const CustomSlideItem({
    required this.slideModel,
    Key? key,
  }) : super(key: key);

  final SlideModel slideModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            slideModel.illustration,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              slideModel.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              slideModel.description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
