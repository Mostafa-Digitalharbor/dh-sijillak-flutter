import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Calls [onReturn] each time the router comes back to [path] after showing
/// another location (a screen pushed over it was popped, or one that
/// replaced such a screen was closed). It watches the router rather than one
/// particular `push`, so every way of leaving and returning is covered.
class ReloadOnReturn extends StatefulWidget {
  const ReloadOnReturn({
    super.key,
    required this.path,
    required this.onReturn,
    required this.child,
  });

  /// Route path whose screen [child] belongs to.
  final String path;
  final VoidCallback onReturn;
  final Widget child;

  @override
  State<ReloadOnReturn> createState() => _ReloadOnReturnState();
}

class _ReloadOnReturnState extends State<ReloadOnReturn> {
  GoRouter? _router;
  late bool _visible;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.maybeOf(context);
    _visible = _isVisible;
    _router?.routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  /// The top-most location, including screens pushed over the current page.
  bool get _isVisible =>
      _router
          ?.routerDelegate
          .currentConfiguration
          .matches
          .lastOrNull
          ?.matchedLocation ==
      widget.path;

  void _onRouteChanged() {
    final visible = _isVisible;
    final returned = visible && !_visible;
    _visible = visible;
    if (returned) widget.onReturn();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
