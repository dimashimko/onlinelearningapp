// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'theme_provider.dart'; // Import the theme provider class
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Light/Dark Theme Switcher'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Consumer<ThemeProvider>(
//               builder: (context, themeProvider, child) {
//                 return Switch(
//                   value: themeProvider.currentTheme == ThemeData.dark(),
//                   onChanged: (value) {
//                     themeProvider.toggleTheme();
//                   },
//                 );
//               },
//             ),
//             Text('Toggle Theme'),
//           ],
//         ),
//       ),
//     );
//   }
// }
