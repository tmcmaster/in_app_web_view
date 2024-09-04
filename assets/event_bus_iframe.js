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
    console.log('EventBusIframe.receiveEvent: ', event.data);
    const eventType = event.data.type;
    const listenerList = this.events[eventType];
    if (listenerList) {
        listenerList.forEach((listener) => {
            listener(event.data);
        });
    }
  }

  publishEvent(event) {
    console.log('EventBusIframe.publishEvent: ', event);
     window.parent.postMessage(event, '*');
  }
}

const eventBus = new EventBusIframe();

export { eventBus };