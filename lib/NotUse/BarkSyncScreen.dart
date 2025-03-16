// import 'dart:convert';
// import 'package:dog/Dog.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// // คลาส BarkSyncScreen
// class BarkSyncScreen extends StatefulWidget {
//   const BarkSyncScreen({Key? key}) : super(key: key);

//   @override
//   State<BarkSyncScreen> createState() => _BarkSyncScreenState();
// }

// class _BarkSyncScreenState extends State<BarkSyncScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<Dog> _dogs = [];
//   List<Dog> _matchedDogs = [];
//   List<Dog> _likedDogs = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _loadDogs();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<String> _fetchRandomDogImage() async {
//     final response =
//         await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'),).timeout(const Duration(seconds: 10));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['message'];
//     } else {
//       throw Exception('Failed to load dog image');
//     }
//   }
  

//   Future<void> _loadDogs() async {
//     // จำลองการโหลดข้อมูลจากฐานข้อมูล
//     await Future.delayed(const Duration(seconds: 1));

//     final List<String> imageUrls = [];
//     for (int i = 0; i < 5; i++) {
//       final imageUrl = await _fetchRandomDogImage();
//       imageUrls.add(imageUrl);
//     }

//     // ข้อมูลสุนัขจำลอง
//     final List<Dog> mockDogs = [
//       Dog(
//         id: '1',
//         name: 'น้องบีม',
//         age: 3,
//         gender: 'ผู้',
//         size: 'เล็ก',
//         description: 'ชอบวิ่งเล่น ร่าเริง เป็นมิตรกับทุกคน',
//         ownerName: 'ณัฐ',
//         imageUrl: imageUrls[0],
//       ),
//       Dog(
//         id: '2',
//         name: 'น้องมิ้นท์',
//         age: 2,
//         gender: 'เมีย',
//         size: 'เล็ก',
//         description: 'ขี้อ้อน ชอบนอนตัก ไม่ชอบเสียงดัง',
//         ownerName: 'เอม',
//         imageUrl: imageUrls[1],
//       ),
//       Dog(
//         id: '3',
//         name: 'น้องโก้',
//         age: 4,
//         gender: 'ผู้',
//         size: 'กลาง',
//         description: 'แอคทีฟ ชอบออกกำลังกาย เป็นมิตรกับสุนัขตัวอื่น',
//         ownerName: 'แบงค์',
//         imageUrl: imageUrls[2],
//       ),
//       Dog(
//         id: '4',
//         name: 'น้องมะลิ',
//         age: 3,
//         gender: 'เมีย',
//         size: 'กลาง',
//         description: 'ร่าเริง ชอบเล่นกับเพื่อน แอคทีฟมาก',
//         ownerName: 'จุ๋ม',
//         imageUrl: imageUrls[3],
//       ),
//       Dog(
//         id: '5',
//         name: 'น้องดำ',
//         age: 5,
//         gender: 'ผู้',
//         size: 'ใหญ่',
//         description: 'ใจดี เป็นมิตร ชอบเล่นกับเด็กและสุนัขตัวอื่น',
//         ownerName: 'เต้',
//         imageUrl: imageUrls[4],
//       ),
//     ];

//     // จำลองข้อมูลสุนัขที่จับคู่แล้ว
//     final List<Dog> mockMatches = [
//       Dog(
//         id: '6',
//         name: 'น้องปุกปุย',
//         age: 2,
//         gender: 'เมีย',
//         size: 'เล็ก',
//         description: 'ร่าเริง ขี้เล่น ชอบคนเยอะ',
//         ownerName: 'แพท',
//         imageUrl: imageUrls[5],
//       ),
//       Dog(
//         id: '7',
//         name: 'น้องบอมบ์',
//         age: 3,
//         gender: 'ผู้',
//         size: 'ใหญ่',
//         description: 'ใจดี เชื่อฟัง ฉลาด ชอบออกกำลังกาย',
//         ownerName: 'ไผ่',
//         imageUrl: imageUrls[6],
//       ),
//     ];

//     if (mounted) {
//       setState(() {
//         _dogs = mockDogs;
//         _matchedDogs = mockMatches;
//         _likedDogs = [];
//         _isLoading = false;
//       });
//     }
//   }

//   void _likeDog(Dog dog) {
//     setState(() {
//       _likedDogs.add(dog);
//       _dogs.remove(dog);
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content:
//             Text('คุณชอบ ${dog.name} แล้ว! เราจะแจ้งเตือนเมื่อจับคู่สำเร็จ'),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _passDog(Dog dog) {
//     setState(() {
//       _dogs.remove(dog);
//     });
//   }

//   void _unmatchDog(Dog dog) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('ยกเลิกการจับคู่'),
//         content: Text('คุณต้องการยกเลิกการจับคู่กับ ${dog.name} ใช่หรือไม่?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('ยกเลิก'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _matchedDogs.remove(dog);
//               });
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('ยกเลิกการจับคู่เรียบร้อยแล้ว'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//             child: const Text('ยืนยัน', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text('BarkSync - จับคู่น้องหมา'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'ค้นหา'),
//             Tab(text: 'ที่ชอบ'),
//             Tab(text: 'การจับคู่'),
//           ],
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildDiscoverTab(),
//                 _buildLikedTab(),
//                 _buildMatchesTab(),
//               ],
//             ),
//     );
//   }

//   Widget _buildDiscoverTab() {
//     if (_dogs.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.search_off,
//               size: 80,
//               color: Colors.blue,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'ไม่พบน้องหมาในพื้นที่ของคุณ',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'ลองขยายการค้นหาหรือกลับมาใหม่ในภายหลัง',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: _loadDogs,
//               icon: const Icon(Icons.refresh),
//               label: const Text('รีเฟรช'),
//             ),
//           ],
//         ),
//       );
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Expanded(
//             child: _dogs.isNotEmpty
//                 ? _buildDogCard(_dogs.first)
//                 : const Center(
//                     child: Text('ไม่พบน้องหมาเพิ่มเติม'),
//                   ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed:
//                     _dogs.isNotEmpty ? () => _passDog(_dogs.first) : null,
//                 icon: const Icon(Icons.close, color: Colors.white),
//                 label: const Text('ข้าม'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed:
//                     _dogs.isNotEmpty ? () => _likeDog(_dogs.first) : null,
//                 icon: const Icon(Icons.favorite, color: Colors.white),
//                 label: const Text('ชอบ'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.pink,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLikedTab() {
//     if (_likedDogs.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.favorite_border,
//               size: 80,
//               color: Colors.pink,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'คุณยังไม่ได้ถูกใจน้องหมาตัวไหนเลย',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'เริ่มค้นหาและกดถูกใจน้องหมาที่คุณสนใจ',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => _tabController.animateTo(0),
//               icon: const Icon(Icons.search),
//               label: const Text('เริ่มค้นหา'),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _likedDogs.length,
//       itemBuilder: (context, index) {
//         final dog = _likedDogs[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             leading: CircleAvatar(
//               backgroundColor: Colors.blue.shade100,
//               radius: 30,
//               child: Text(
//                 dog.name.substring(0, 1),
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             title: Text(
//               dog.name,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 4),
//                 Text('${dog.age} ปี • ${dog.gender}'),
//                 const SizedBox(height: 4),
//                 Text('เจ้าของ: ${dog.ownerName}'),
//               ],
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete_outline, color: Colors.red),
//               onPressed: () {
//                 setState(() {
//                   _likedDogs.remove(dog);
//                 });
//               },
//             ),
//             onTap: () => _showDogDetails(dog),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMatchesTab() {
//     if (_matchedDogs.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.pets,
//               size: 80,
//               color: Colors.blue,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'ยังไม่มีการจับคู่',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'เมื่อคุณและเจ้าของสุนัขอีกฝ่ายต่างถูกใจกัน\nจะปรากฏการจับคู่ที่นี่',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => _tabController.animateTo(0),
//               icon: const Icon(Icons.search),
//               label: const Text('เริ่มค้นหา'),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _matchedDogs.length,
//       itemBuilder: (context, index) {
//         final dog = _matchedDogs[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//           child: Column(
//             children: [
//               ListTile(
//                 contentPadding: const EdgeInsets.all(16),
//                 leading: CircleAvatar(
//                   backgroundColor: Colors.green.shade100,
//                   radius: 30,
//                   child: const Icon(Icons.check_circle, color: Colors.green),
//                 ),
//                 title: Text(
//                   dog.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 4),
//                     Text(' ${dog.age} ปี • ${dog.gender}'),
//                     const SizedBox(height: 4),
//                     Text('เจ้าของ: ${dog.ownerName}'),
//                   ],
//                 ),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.message, color: Colors.blue),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('เริ่มแชทกับ ${dog.ownerName}'),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   },
//                 ),
//                 onTap: () => _showDogDetails(dog),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     OutlinedButton(
//                       onPressed: () => _showDogDetails(dog),
//                       child: const Text('ดูโปรไฟล์'),
//                     ),
//                     OutlinedButton(
//                       onPressed: () => _unmatchDog(dog),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                       ),
//                       child: const Text('ยกเลิกการจับคู่'),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDogCard(Dog dog) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 image: DecorationImage(
//                   image: NetworkImage(dog.imageUrl), // ใช้รูปภาพจาก API
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         dog.name,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         '${dog.age} ปี',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${dog.gender} • ${dog.size}',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     dog.description,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       const Icon(Icons.person, size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(
//                         'เจ้าของ: ${dog.ownerName}',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Wrap(
//                     spacing: 8,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDogDetails(Dog dog) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(24),
//           height: MediaQuery.of(context).size.height * 0.7,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     dog.name,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade200,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Center(
//                   child: Icon(
//                     Icons.pets,
//                     size: 80,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   _buildInfoChip('${dog.age} ปี'),
//                   const SizedBox(width: 8),
//                   _buildInfoChip(dog.gender),
//                   const SizedBox(width: 8),
//                   _buildInfoChip(dog.size),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'เกี่ยวกับ',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 dog.description,
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'ความสนใจ',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 children: [
//                   const Icon(Icons.person, color: Colors.grey),
//                   const SizedBox(width: 8),
//                   Text(
//                     'เจ้าของ: ${dog.ownerName}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 child: const Text(
//                   'ตกลง',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildInfoChip(String label) {
//     return Chip(
//       label: Text(label),
//       backgroundColor: Colors.blue.shade100,
//     );
//   }
// }