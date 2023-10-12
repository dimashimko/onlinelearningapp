// simple to draws from get model
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_learning_app/resources/app_images.dart';

class CustomImageViewer extends StatelessWidget {
  CustomImageViewer({
    required this.link,
    this.alternativePhoto = AppImages.empty_course,
    this.height = 240,
    this.boxFitLocalImage = BoxFit.fitHeight,
    this.boxFitNetworkImage = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  final String? link;
  final String alternativePhoto;
  final double height;
  final BoxFit boxFitLocalImage;
  final BoxFit boxFitNetworkImage;

  @override
  Widget build(BuildContext context) {
    // print('*** CustomImageViewer: ');
    // String imageLink = sm.linkToCover ?? AppImages.white;
    String imageLink = link ?? alternativePhoto;
    // print('*** imageLink: $imageLink');

    bool isNetwork = imageLink.startsWith('http');
    // print('*** isNetwork: $isNetwork');
    Widget image = Container(
      color: Colors.white,
    );
    image = isNetwork
        ? Image.network(
            imageLink,
            // width: double.infinity,
            width: double.infinity,
            height: height,
            fit: boxFitNetworkImage,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            // loadingBuilder: (BuildContext context, Widget exception,
            //     ImageChunkEvent? stackTrace) {
            //         return Image.asset(
            //           alternativePhoto,
            //           fit: BoxFit.cover,
            //         );
            //       },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(
                alternativePhoto,
                fit: boxFitLocalImage,
              );
            },
          )
        : Image.file(
            File(
              imageLink,
            ),
            width: double.infinity,
            height: height,
            fit: boxFitLocalImage,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              // return Container(color: AppColors.whiteSmoke.withOpacity(0.9));
              return Image.asset(
                alternativePhoto,
                fit: boxFitLocalImage,
              );
            },
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: image,
    );
  }
}
