// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Flutter Pagination Example'),
//         ),
//         body: PaginationExample(),
//       ),
//     );
//   }
// }
//
// class PaginationExample extends StatefulWidget {
//   @override
//   _PaginationExampleState createState() => _PaginationExampleState();
// }
//
// class _PaginationExampleState extends State<PaginationExample> {
//   final PagingController<int, QueryDocumentSnapshot> _pagingController =
//   PagingController(firstPageKey: 0);
//
//   Future<QuerySnapshot<Map<String, dynamic>>> fetchPage(int pageNumber) async {
//     final query = FirebaseFirestore.instance
//         .collection('YOUR_FIREBASE_COLLECTION_NAME')
//         .orderBy('createdAt')
//         .limit(10)
//         .startAfterDocument(lastDocument); // Adjust sorting criteria, limit, and collection name
//     return await query.get();
//   }
//
//   void _fetchPage(int pageKey) {
//     fetchPage(pageKey).then((newItems) {
//       if (newItems.docs.isNotEmpty) {
//         final lastDocument = newItems.docs.last;
//         _pagingController.appendPage(newItems.docs, pageKey + 1);
//       } else {
//         _pagingController.appendLastPage([]);
//       }
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPage(0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PagedListView<int, QueryDocumentSnapshot>(
//       pagingController: _pagingController,
//       builderDelegate: PagedChildBuilderDelegate<QueryDocumentSnapshot>(
//         itemBuilder: (context, item, index) {
//           return ListTile(
//             title: Text(item['title']),
//             subtitle: Text(item['description']),
//             // Add any other widget that you want to show for each item
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }
// }
