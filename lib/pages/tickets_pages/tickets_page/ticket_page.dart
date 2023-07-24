import 'dart:io';

import 'package:online_learning_app/pages/tickets_pages/tickets_page/widgets/ticket_item.dart';
import 'package:online_learning_app/resources/app_colors.dart';
import 'package:online_learning_app/resources/app_fonts.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/widgets/navigation/custom_app_bar.dart';
import 'package:online_learning_app/widgets/uncategorized/glow_scroll_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: SvgPicture.asset(
          AppIcons.menu,
          color: AppColors.textPrimary,
        ),
        onLeading: () {
          Scaffold.of(context).openDrawer();
        },
        title: const Text(
          'TicketsPage',
          style: TextStyle(
            fontWeight: AppFonts.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ).copyWith(
              left: 16.0,
            ),
            child: const Text(
              'Filter',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: GlowScrollIndicator(
              enabled: !Platform.isAndroid,
              child: ListView.builder(
                itemCount: 50,
                itemBuilder: (_, int i) {
                  return TicketItem(
                    index: i,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
