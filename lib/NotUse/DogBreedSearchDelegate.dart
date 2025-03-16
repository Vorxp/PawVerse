// import 'package:dog/BreedCard.dart';
// import 'package:dog/Dogbreed.dart';
// import 'package:flutter/material.dart';

// class DogBreedSearchDelegate extends SearchDelegate<String> {
//   final List<DogBreed> breeds;

//   DogBreedSearchDelegate(this.breeds);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = breeds
//         .where(
//             (breed) => breed.name.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.blue[50]!, Colors.amber[50]!],
//         ),
//       ),
//       child: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: results.length,
//         itemBuilder: (context, index) {
//           return BreedCard(breed: results[index]);
//         },
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = query.isEmpty
//         ? []
//         : breeds
//             .where((breed) =>
//                 breed.name.toLowerCase().contains(query.toLowerCase()))
//             .toList();

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.blue[50]!, Colors.amber[50]!],
//         ),
//       ),
//       child: ListView.builder(
//         itemCount: suggestions.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: AssetImage(suggestions[index].imageUrl),
//             ),
//             title: Text(suggestions[index].name),
//             onTap: () {
//               query = suggestions[index].name;
//               showResults(context);
//             },
//           );
//         },
//       ),
//     );
//   }
// }