class EventBusIframe {
  constructor() {
    console.log('EventBusIframe: constructor');
    this.events = {};
    window.addEventListener('message', this.receiveEvent.bind(this));
  }

  addEventListener(eventType, listener) {
    console.log('EventBusIframe.addEventListener: ', eventType);
    if (!this.events[eventType]) {
      this.events[eventType] = [];
    }
    this.events[eventType].push(listener);
  }

  removeEventListener(eventType, listenerToRemove) {
    console.log('EventBusIframe.removeEventListener: ', eventType);
    if (!this.events[eventType]) return;
    this.events[eventType] = this.events[eventType].filter(listener => listener !== listenerToRemove);
  }

  receiveEvent(event) {
    console.log('EventBusIframe.receiveEvent: ', event);
    const eventType = event.type;
    if (!this.events[eventType]) return;
    this.events[eventType].forEach(listener => listener(event));
  }

  publishEvent(event) {
    console.log('EventBusIframe.publishEvent: ', event);
     window.parent.postMessage(event, '*');
  }
}

const eventBus = new EventBusIframe();

export { eventBus };