// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:nearbys/controller/sender_controller.dart';
// import 'package:nearbys/controller/vision_conroller.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'qr_scanner.dart';
//
// class SenderHome extends ConsumerStatefulWidget {
//   const SenderHome({super.key});
//
//   @override
//   ConsumerState<SenderHome> createState() => _SenderHomeState();
// }
//
// class _SenderHomeState extends ConsumerState<SenderHome> {
//   final SenderController controller = SenderController();
//
//   @override
//   void initState() {
//     super.initState();
//     debugPrint("APP STARTED");
//     controller.initPermissions();
//     controller.addListener(_refreshUI);
//   }
//
//   void _refreshUI() {
//     if (mounted) setState(() {});
//   }
//
//   void openQrScanner() {
//     debugPrint("Opening QR scanner");
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => QrScanner(
//           onScanned: (data) async {
//             debugPrint("QR SCANNED: $data");
//             controller.setReceiverId(data);
//             await Future.delayed(const Duration(milliseconds: 300));
//             controller.startDiscovery();
//           },
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.disposeController();
//     controller.removeListener(_refreshUI);
//     super.dispose();
//   }
//
//   Widget _imageSlot(int index) {
//     Uint8List? imageBytes =
//     index == 0 ? controller.imageBytes0 : controller.imageBytes1;
//
//     bool isLoading =
//     index == 0 ? controller.isChecking0 : controller.isChecking1;
//
//     return GestureDetector(
//       onTap: () async {
//         await controller.pickImage(index, context, ref);
//       },
//       child: Container(
//         width: double.infinity,
//         height: 300,
//         decoration: BoxDecoration(
//           color: const Color(0xFFEAF3FF),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: const Color(0xFFB7D3FF), width: 1.2),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x22000000),
//               blurRadius: 12,
//               offset: Offset(0, 6),
//             ),
//           ],
//         ),
//         child: imageBytes == null
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.camera_alt_outlined,
//                 size: 48, color: Color(0xFF4F8BFF)),
//             const SizedBox(height: 10),
//             Text(
//               index == 0 ? "Left Eye" : "Right Eye",
//               style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF2C5BFF)),
//             ),
//           ],
//         )
//             : Stack(
//           fit: StackFit.expand,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//               child: Image.memory(
//                 imageBytes,
//                 fit: BoxFit.cover,
//                 gaplessPlayback: true,
//                 filterQuality: FilterQuality.low,
//               ),
//             ),
//             if (isLoading)
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.35),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Eye Vision Test"),
//         backgroundColor: const Color(0xFF4F8BFF),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFFF3F8FF),
//             borderRadius: BorderRadius.circular(24),
//             boxShadow: const [
//               BoxShadow(
//                 color: Color(0x22000000),
//                 blurRadius: 18,
//                 offset: Offset(0, 10),
//               ),
//             ],
//           ),
//           padding: const EdgeInsets.all(12),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const SizedBox(height: 5),
//                 const Text(
//                   "Capture Both Eye Images",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1F3C88)),
//                 ),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   child: _imageSlot(0),
//                 ),
//                 const SizedBox(height: 24),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6),
//                   child: _imageSlot(1),
//                 ),
//                 const SizedBox(height: 25),
//                 const Divider(),
//                 const SizedBox(height: 15),
//                 const Text(
//                   "Connect to Receiver",
//                   style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1F3C88)),
//                 ),
//                 const SizedBox(height: 15),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: (controller.image0 != null &&
//                         controller.image1 != null &&
//                         !controller.isChecking0 &&
//                         !controller.isChecking1)
//                         ? () async {
//                       if (controller.connectedEndpoint != null) {
//                         await controller.resetFlow();
//                         return;
//                       }
//
//                       if (controller.isDiscovering) {
//                         await controller.stopDiscovery();
//                       } else {
//                         openQrScanner();
//                       }
//                     }
//                         : null,
//                     child: Text(
//                       controller.connectedEndpoint != null
//                           ? "Rescan Receiver QR"
//                           : controller.isDiscovering
//                           ? "Stop Discovery"
//                           : "Scan Receiver QR",
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
