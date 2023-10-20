import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_learning_app/resources/app_icons.dart';
import 'package:online_learning_app/resources/app_images.dart';
import 'package:online_learning_app/widgets/elements/custom_image_viewer.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.avatarLink,
    required this.onChangeImage,
    super.key,
  });

  final String? avatarLink;
  final Function(String) onChangeImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.0,
      child: InkWell(
        onTap: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(
            source: ImageSource.gallery,
          );
          if (image != null) {
            onChangeImage(image.path);
          } else {}
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            CustomImageViewer(
              link: avatarLink,
              alternativePhoto: AppImages.emptyAvatar,
              boxFitNetworkImage: BoxFit.fitHeight,
            ),
            SvgPicture.asset(
              AppIcons.cameraContour,
            ),
          ],
        ),
      ),
    );
  }
}
