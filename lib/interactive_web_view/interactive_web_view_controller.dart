import 'package:in_app_web_view/interactive_web_view/event_bus.dart';
import 'package:in_app_web_view/utils/log.dart';

class InteractiveWebViewController {
  static final log = Log.d();

  final String name;
  late EventBus eventBus;
  final void Function(String)? onEvent;

  InteractiveWebViewController({
    required this.name,
    this.onEvent,
  }) {
    eventBus = EventBus.getInstance(name);
    eventBus.addEventBusListener(receiveEvent);
  }

  void sendEvent(event) {
    log.d('InteractiveWebViewController : sendEvent : $event');
    eventBus.emitFromFlutter(event);
  }

  void receiveEvent(event) {
    log.d('InteractiveWebViewController : receiveEvent : $event');
    onEvent?.call(event);
  }

  dispose() {
    eventBus.removeEventBusListener(receiveEvent);
  }
}
