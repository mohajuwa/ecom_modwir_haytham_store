// import 'package:ecom_modwir/view/widget/services/cars/selection_modal.dart';
// import 'package:flutter/material.dart';

// void showSelectionModal<T>(
//   BuildContext context,
//   String title,
//   List<T> items,
//   Function(int) onSelect,
// ) {
//   final isDark = Theme.of(context).brightness == Brightness.dark;

//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => DraggableScrollableSheet(
//       initialChildSize: 0.7,
//       minChildSize: 0.5,
//       maxChildSize: 0.9,
//       snap: true,
//       snapSizes: const [0.5, 0.7, 0.9],
//       builder: (context, scrollController) => Container(
//         margin: EdgeInsets.only(
//           top: MediaQuery.of(context).padding.top + kToolbarHeight,
//         ),
//         decoration: BoxDecoration(
//           color: isDark ? Color(0xFF1E1E1E) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.9,
//         ),
//         child: SelectionModal(
//           title: title,
//           items: items,
//           onSelect: (index) {
//             onSelect(index);

//             Navigator.pop(context);
//           },
//           scrollController: scrollController,
//           isDark: isDark,
//         ),
//       ),
//     ),
//   );
// }
