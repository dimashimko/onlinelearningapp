// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Pagination with Firestore',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: PaginatedListScreen(),
//     );
//   }
// }
//
// class PaginatedListScreen extends StatefulWidget {
//   @override
//   _PaginatedListScreenState createState() => _PaginatedListScreenState();
// }
//
// class _PaginatedListScreenState extends State<PaginatedListScreen> {
//   final PagingController<int, DocumentSnapshot> _pagingController =
//       PagingController(firstPageKey: 0);
//
//   @override
//   void initState() {
//     super.initState();
//     _pagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey);
//     });
//   }
//
//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       // Assuming you have a Firestore collection named 'items'
//       var querySnapshot = await FirebaseFirestore.instance
//           .collection('items')
//           .orderBy('createdAt') // replace with your sorting field
//           .startAfterDocument(
//             pageKey == 0 ? null : _pagingController.itemList!.last!,
//           )
//           .limit(10)
//           .get();
//
//       final isLastPage = querySnapshot.docs.length < 10;
//       if (isLastPage) {
//         _pagingController.appendLastPage(querySnapshot.docs);
//       } else {
//         final nextPageKey = querySnapshot.docs.last;
//         _pagingController.appendPage(querySnapshot.docs, nextPageKey);
//       }
//     } catch (error) {
//       _pagingController.error = error;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Paginated List Example'),
//       ),
//       body: PagedListView<int, DocumentSnapshot>(
//         pagingController: _pagingController,
//         builderDelegate: PagedChildBuilderDelegate(
//           itemBuilder: (context, item, index) {
//             return ListTile(
//               title: Text('Item ${item['name']}'),
//             );
//           },
//           firstPageErrorIndicatorBuilder: (context) {
//             return Column(
//               children: [
//                 Text('Error loading first page'),
//                 ElevatedButton(
//                   onPressed: () => _pagingController.refresh(),
//                   child: Text('Try again'),
//                 ),
//               ],
//             );
//           },
//           newPageErrorIndicatorBuilder: (context) {
//             return Column(
//               children: [
//                 Text('Error loading next page'),
//                 ElevatedButton(
//                   onPressed: () => _pagingController.retryLastFailedRequest(),
//                   child: Text('Try again'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
