import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_learning_app/blocs/video_bloc/video_bloc.dart';

class TodayProgress extends StatelessWidget {
  const TodayProgress({
    required this.onTapMyCourses,
    super.key,
  });

  final VoidCallback? onTapMyCourses;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: 96.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learned today',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              if (onTapMyCourses != null)
                InkWell(
                  onTap: () {
                    if (onTapMyCourses != null) {
                      onTapMyCourses!();
                    }
                  },
                  child: Text(
                    'My courses',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
            ],
          ),
          BlocBuilder<VideoBloc, VideoState>(
            buildWhen: (p, c) {
              return p.userActivityModel != c.userActivityModel;
            },
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          state.userActivityModel != null
                              ? '${(state.userActivityModel!.timePerDay??0.0)~/60} min'
                              : '- min',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 20.0,
                              ),
                        ),
                        Text(
                          ' / 60min',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CustomLinearGradientLine(
                    // min: 10,
                    sec: state.userActivityModel != null
                        ? (state.userActivityModel!.timePerDay ?? 0.0).toInt()
                        : 0,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomLinearGradientLine extends StatelessWidget {
  const CustomLinearGradientLine({
    required this.sec,
    super.key,
  });

  final int sec;

  @override
  Widget build(BuildContext context) {
    int minRounded = sec > 3600 ? 60 : sec~/60;
    return Stack(
      children: [
        Container(
          height: 6.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        Container(
          height: 6.0,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              // end: Alignment.centerRight,
              end: Alignment(((minRounded * 2) / 60) - 1, 0.0),
              // end: Alignment(-0.5, 0.0),
              colors: <Color>[
                Theme.of(context).colorScheme.onSecondary,
                // Colors.white,
                Theme.of(context).colorScheme.tertiaryContainer,
              ],
              tileMode: TileMode.decal,
            ),
          ),
        ),
      ],
    );
  }
}
