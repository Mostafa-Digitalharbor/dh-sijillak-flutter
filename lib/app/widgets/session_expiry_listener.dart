import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../core/network/session_events.dart';

/// Calls [onExpired] whenever [events] reports that the session ended behind
/// the user's back (the backend rejected the refresh token). The app root
/// uses it to send the user to the welcome screen.
class SessionExpiryListener extends StatefulWidget {
  const SessionExpiryListener({
    required this.events,
    required this.onExpired,
    required this.child,
    super.key,
  });

  final SessionEvents events;
  final VoidCallback onExpired;
  final Widget child;

  @override
  State<SessionExpiryListener> createState() => _SessionExpiryListenerState();
}

class _SessionExpiryListenerState extends State<SessionExpiryListener> {
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(SessionExpiryListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) _listen();
  }

  void _listen() {
    unawaited(_subscription?.cancel());
    _subscription = widget.events.expired.listen((_) => widget.onExpired());
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
