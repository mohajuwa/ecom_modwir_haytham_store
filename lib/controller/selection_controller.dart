import 'package:get/get.dart';

class SelectionController<T> extends GetxController {
  final RxString searchQuery = ''.obs;
  final RxList<T> filteredItems = <T>[].obs;
  final RxnString suggestion = RxnString();
  late List<T> allItems;
  late String Function(T) label;

  void init(List<T> items, String Function(T) itemLabel) {
    allItems = items;
    label = itemLabel;
    filteredItems.assignAll(items);
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    final normalizedQuery = _normalizeArabic(query);
    filteredItems.assignAll(allItems.where((item) {
      final normalizedLabel = _normalizeArabic(label(item));
      return normalizedLabel.contains(normalizedQuery);
    }));

    suggestion.value =
        filteredItems.isEmpty ? _findClosestMatch(normalizedQuery) : null;
  }

  String _normalizeArabic(String input) {
    return input
        .replaceAll(RegExp(r'[إأآا]'), 'ا')
        .replaceAll(RegExp(r'[ى]'), 'ي')
        .replaceAll(RegExp(r'[ة]'), 'ه')
        .replaceAll(RegExp(r'[ؤئ]'), 'و')
        .replaceAll(RegExp(r'[ًٌٍَُِّْ]'), '')
        .toLowerCase();
  }

  String? _findClosestMatch(String query) {
    String? closest;
    int minDistance = 999;

    for (var item in allItems) {
      final distance = _levenshtein(query, _normalizeArabic(label(item)));
      if (distance < minDistance && distance < 5) {
        minDistance = distance;
        closest = label(item);
      }
    }

    return closest;
  }

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<List<int>> dp =
        List.generate(s.length + 1, (_) => List.filled(t.length + 1, 0));
    for (int i = 0; i <= s.length; i++) dp[i][0] = i;
    for (int j = 0; j <= t.length; j++) dp[0][j] = j;

    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        int cost = s[i - 1] == t[j - 1] ? 0 : 1;
        dp[i][j] = [dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost]
            .reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[s.length][t.length];
  }
}
