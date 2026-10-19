import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_config.dart';
import '../routing/app_router.dart';

/// Dev-only helper used for screen-by-screen visual comparison with the
/// design. It does nothing unless the app runs in debug mode with
/// `--dart-define=DESIGN_DEBUG=true`.
///
///  * `GET /?route=/home`  jumps the running app to a route
///  * `GET /tree`          dumps text/box geometry of the current screen as JSON
///
/// Reach it with `adb forward tcp:8765 tcp:8765`.
Future<void> startDebugRouteServer() async {
  if (!kDebugMode || !AppConfig.designDebug) return;
  try {
    final server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      AppConfig.designDebugPort,
    );
    server.listen((request) {
      if (request.uri.path == '/tree') {
        request.response
          ..headers.contentType = ContentType.json
          ..write(jsonEncode(_dumpTree()))
          ..close();
        return;
      }
      final route = request.uri.queryParameters['route'];
      if (route != null) appRouter.go(route);
      request.response
        ..write(route == null ? 'no route' : 'ok')
        ..close();
    });
  } catch (_) {
    // Port in use or sockets unavailable: the helper is optional.
  }
}

List<Map<String, Object?>> _dumpTree() {
  final out = <Map<String, Object?>>[];
  final root = WidgetsBinding.instance.rootElement?.renderObject;
  if (root == null) return out;
  final dpr =
      WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
  void visit(RenderObject node) {
    if (node is RenderBox && node.hasSize && node.attached) {
      final o = node.localToGlobal(Offset.zero);
      final s = node.size;
      if (node is RenderParagraph) {
        out.add({
          't': 'text',
          'x': o.dx,
          'y': o.dy,
          'w': s.width,
          'h': s.height,
          's': node.text.toPlainText(),
          'fs': node.text.style?.fontSize,
        });
      } else if (node is RenderDecoratedBox) {
        final d = node.decoration;
        if (d is BoxDecoration) {
          out.add({
            't': 'box',
            'x': o.dx,
            'y': o.dy,
            'w': s.width,
            'h': s.height,
            'c': d.color?.toARGB32(),
            'b': d.border != null,
          });
        }
      }
    }
    node.visitChildren(visit);
  }

  visit(root);
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  out.add({
    't': 'meta',
    'dpr': dpr,
    'padTop': view.padding.top / dpr,
    'padBottom': view.padding.bottom / dpr,
    'w': view.physicalSize.width / dpr,
    'h': view.physicalSize.height / dpr,
  });
  return out;
}
