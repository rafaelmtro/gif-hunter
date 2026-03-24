import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stores the ID of the GIF currently open in the detail modal, or null if none.
final openGifIdProvider = StateProvider<String?>((ref) => null);
