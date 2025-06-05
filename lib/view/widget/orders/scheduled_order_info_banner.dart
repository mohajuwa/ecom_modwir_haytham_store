// lib/view/widget/scheduled_order_info_banner.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ScheduledOrderInfoBanner extends StatelessWidget {
  final int? isScheduled;
  final String? scheduledDatetime;

  const ScheduledOrderInfoBanner({
    super.key,
    this.isScheduled,
    this.scheduledDatetime,
  });

  @override
  Widget build(BuildContext context) {
    String? displayScheduledText;

    if (isScheduled == 1 &&
        scheduledDatetime != null &&
        scheduledDatetime!.isNotEmpty) {
      try {
        DateTime parsedScheduledDateTime = DateTime.parse(scheduledDatetime!);
        final locale = Get.locale?.toString();

        // Format the date part: "DayOfWeek, Month Day, Year"
        // Example: "Tuesday, June 3, 2025"
        String formattedDatePart =
            DateFormat('EEEE, MMM d, yyyy', locale) // Using yyyy for full year
                .format(parsedScheduledDateTime);

        // Format the time part: "Hour:Minute AM/PM"
        // Example: "09:30 AM"
        String formattedTimePart =
            DateFormat('hh:mm a', locale).format(parsedScheduledDateTime);

        // Combine with translated "at"
        // Make sure you have 'at_time'.tr defined in your localization files
        displayScheduledText =
            "${'scheduled_for'.tr} $formattedDatePart ${'at_time'.tr} $formattedTimePart";
      } catch (e) {
        print("Error parsing scheduledDatetime: $scheduledDatetime - $e");
        displayScheduledText = "${'scheduled'.tr}: ${'invalid_date_format'.tr}";
      }
    }

    if (displayScheduledText != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.event_available_outlined,
              color: Colors.orange.shade600,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayScheduledText,
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Khebrat',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
