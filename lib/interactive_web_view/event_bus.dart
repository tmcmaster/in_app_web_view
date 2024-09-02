import 'package:in_app_web_view/utils/log.dart';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;

class EventBus {
  static final log = Log.d();

  static final instances = <String, EventBus>{};

  // Event Bus listening to the Flutter
  final flutterListeners = <void Function(String event)>[];
  // Flutter listening to the Event Bus
  final eventBusListeners = <void Function(String event)>[];

  EventBus._(String name) {
    log.d('EventBus: Initialising the event bus adapter');
    // TODO: need to integrate the name into the state name.
    const stateName = '_EventBusState';
    final export = js_util.createDartExport(this);
    js_util.setProperty(js_util.globalThis, stateName, export);
    // TODO: need to make this _EventBusInitialise use the stateName arg
    js_util.callMethod<void>(js_util.globalThis, '_EventBusInitialise', [stateName]);
  }

  factory EventBus.getInstance(String name) {
    if (!instances.containsKey(name)) {
      log.d('EventBus: Creating new adapter: $name');
      instances[name] = EventBus._(name);
    }
    return instances[name]!;
  }

  @js.JSExport()
  void addFlutterListener(void Function(String event) listener) {
    log.d('EventBus: Event Bus adding listener to Flutter');
    flutterListeners.add(listener);
  }

  @js.JSExport()
  void removeFlutterListener(void Function(String event) listener) {
    log.d('EventBus: Event Bus removing listener from Flutter');
    flutterListeners.remove(listener);
  }

  void addEventBusListener(void Function(String event) listener) {
    log.d('EventBus: Flutter adding listener to the Event Bus');
    eventBusListeners.add(listener);
  }

  void removeEventBusListener(void Function(String event) listener) {
    log.d('EventBus: Flutter removing listening from the Event Bus');
    eventBusListeners.remove(listener);
  }

  @js.JSExport()
  void emitToFlutter(String event) {
    log.d('EventBus: Emitting event to Flutter: $event');
    for (var listener in eventBusListeners) {
      listener(event);
    }
  }

  void emitFromFlutter(String event) {
    log.d('EventBus: Emitting event from Flutter: $event');
    for (var listener in flutterListeners) {
      listener(event);
    }
  }
}