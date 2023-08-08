import 'package:flutter_riverpod/flutter_riverpod.dart';

// Discover sidebar
final selectedValuesProvider = StateProvider<Set<String>>((ref) => {'普通发布', '赛事结论', '场地评论', '找人找队', '装备推荐', '赛事推广'});
final sortTweetsTimeProvider = StateProvider<bool>((ref) => false); // false -> decreasing, true -> increasing
final sortTweetsLikesProvider = StateProvider<bool>((ref) => false); // false -> decreasing, true -> increasing
final sortTweetsCommentsProvider = StateProvider<bool>((ref) => false); // false -> decreasing, true -> increasing
