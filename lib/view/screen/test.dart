  // Widget _buildSortDropdown() {
  //   return PopupMenuButton<PriceSort>(
  //     icon: Icon(Icons.filter_list_rounded, color: AppColor.primaryColor),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     onSelected: (sort) => controller.sortServicesByPrice(sort),
  //     itemBuilder: (context) => [
  //       PopupMenuItem(
  //         value: PriceSort.lowToHigh,
  //         child: Row(
  //           children: [
  //             Icon(Icons.arrow_upward_rounded, size: 18, color: AppColor.grey2),
  //             const SizedBox(width: 8),
  //             Text('low_to_high'.tr, style: MyTextStyle.smallBold),
  //           ],
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: PriceSort.highToLow,
  //         child: Row(
  //           children: [
  //             Icon(Icons.arrow_downward_rounded,
  //                 size: 18, color: AppColor.grey2),
  //             const SizedBox(width: 8),
  //             Text('high_to_low'.tr, style: MyTextStyle.smallBold),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
