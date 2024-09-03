import 'package:in_app_web_view/interactive_web_view/event_bus_flutter.dart';
import 'package:in_app_web_view/utils/log.dart';

class InteractiveWebViewController {
  static final log = Log.d();

  final String name;
  late EventBusFlutter eventBus;
  final void Function(Map<String, dynamic>)? onEvent;

  InteractiveWebViewController({
    required this.name,
    this.onEvent,
  }) {
    eventBus = EventBusFlutter.getInstance(name);
    eventBus.addEventBusListener(receiveEvent);
  }

  void sendEvent(Map<String, dynamic> event) {
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
