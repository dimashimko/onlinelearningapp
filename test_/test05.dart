// import 'package:appinio_video_player/appinio_video_player.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rayanik/core/constants/urls.dart';
// import 'package:rayanik/core/widgets/appbar_widget.dart';
// import 'package:rayanik/models/models/course_model.dart';
// import 'package:rayanik/viewmodels/show_video_viewmodel.dart';
//
// class ShowVideoScreen extends StatefulWidget {
//   const ShowVideoScreen({Key? key, required this.lesson}) : super(key: key);
//   final Lessons lesson;
//
//   @override
//   State<ShowVideoScreen> createState() => _ShowVideoScreenState();
// }
//
// class _ShowVideoScreenState extends State<ShowVideoScreen> {
//   late VideoPlayerController videoPlayerController;
//   late CustomVideoPlayerController customVideoPlayerController;
//
//   @override
//   void initState() {
//     super.initState();
//     print(Uri.parse(baseUrl + '/uploads/' + (widget.lesson.videoUrl ?? ""))
//         .toString());
//     videoPlayerController = VideoPlayerController.networkUrl(
//         Uri.parse('$baseUrl/uploads/${widget.lesson.videoUrl}'),
//         videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
//         httpHeaders: {
//           "Access-Control-Allow-Origin": "*",
//           'Accept': '*/*',
//         })
//       ..initialize().then((value) => setState(() {}));
//     // ..initialize().then((value) => setState(() {}));
//     customVideoPlayerController = CustomVideoPlayerController(
//         context: context,
//         videoPlayerController: videoPlayerController,
//         customVideoPlayerSettings: CustomVideoPlayerSettings(
//             placeholderWidget: Hero(
//               tag: widget.lesson.id ?? "",
//               transitionOnUserGestures: true,
//               child: Stack(
//                 children: [
//                   Image.network(
//                     widget.lesson.imageUrl ?? "",
//                     fit: BoxFit.fitHeight,
//                     width: Get.width,
//                     height: Get.height,
//                   ),
//                   const Center(
//                     child: CircularProgressIndicator(),
//                   )
//                 ],
//               ),
//             )));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     customVideoPlayerController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final controller =
//     //     Get.put(ShowVideoViewModel(context: context, lessonsModel: widget.lesson));
//     return Scaffold(
//       appBar: screensAppBar(),
//       body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         SizedBox(
//           width: Get.width,
//           height: Get.height / 4,
//           child: CustomVideoPlayer(
//               customVideoPlayerController: customVideoPlayerController),
//         ),
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15) +
//                 EdgeInsets.only(top: Get.height / 35),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.lesson.title ?? "",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 22 * MediaQuery.of(context).textScaleFactor),
//                 ),
//                 const SizedBox(
//                   height: 35,
//                 ),
//                 Expanded(
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       child: Text(
//                         widget.lesson.description ?? "",
//                         textAlign: TextAlign.justify,
//                         style: TextStyle(
//                             fontSize: 16 * MediaQuery.of(context).textScaleFactor),
//                       ),
//                     ))
//               ],
//             ),
//           ),
//         )
//       ]),
//     );
//   }
// }