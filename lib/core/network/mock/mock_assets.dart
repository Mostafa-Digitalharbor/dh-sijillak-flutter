import 'dart:convert';

import 'package:flutter/services.dart';

/// Loads the JSON fixtures in `assets/mock/`. Every call decodes afresh, so
/// handlers can mutate what they get without affecting other readers.
class MockAssets {
  MockAssets([AssetBundle? bundle]) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Map<String, String> _cache = {};

  /// The decoded `data` payload of the fixture at [assetPath].
  Future<Object?> json(String assetPath) async {
    final raw = _cache[assetPath] ??= await _bundle.loadString(
      assetPath,
      cache: false,
    );
    return (jsonDecode(raw) as Map<String, dynamic>)['data'];
  }
}
