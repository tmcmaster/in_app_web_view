class EventBusHTML {
    constructor(config = {}) {
        this.cfg = {
            ...config
        };

        console.log('EventBusHTML: Initialising EventBus', this.cfg);
        
        this.eventListenerMap = {};
        const self = this;
        window._EventBusInitialise = function (webViewName) {
            console.log('EventBusHTML: Web View Name:', webViewName);
            window._EventBusInitialise = function () {
                console.log("EventBusHTML: Call _stateSet only once!");
            };
            self.initialise();
        }
    }

    // Setup  connection with Flutter
    initialise() {
        console.log('EventBusHTML.initialise: ');
        window.addEventListener('message', this._eventFromIframe.bind(this));
        window._EventBusState.addFlutterListener(this._eventFromFlutter.bind(this));
    }

    // Disconnect connection with Flutter
    dispose() {
        console.log('EventBusHTML.dispose: ');
        window.addEventListener(this._eventFromIframe);
        window._EventBusState.removeFlutterListener(this._eventFromFlutter.bind(this));
    }

    publishEvent(event) {
        console.log('EventBusHTML.publishEvent: ', event);
        this._publishEvent({
            source: 'html',
            type: event.type,
            data: event.data,
        });
    }

    addEventListener(eventType, listener) {
        (this.eventListenerMap[eventType] ??= []).push(listener);
    }

    removeEventListener(eventType, listener) {
        const listeners = this.eventListenerMap[eventType];
        if (listeners) {
            const index = listeners.indexOf(listener);
            if (index !== -1) {
                listeners.splice(index, 1);
            }
            if (listeners.length === 0) {
                delete this.eventListenerMap[eventType];
            }
        }
    }

    _publishEvent(event) {
        console.log('EventBusHTML.publishEvent: ', event);
        this._emitToHtml(event);
        this._emitToIframe(event);
        this._emitToFlutter(event);
    }

    _eventFromIframe(event) {
        const eventData = event.data;
        console.log('EventBusHTML.eventFromIframe: ', eventData);
        this._publishEvent({
            source: 'iframe',
            type: eventData.type,
            data: eventData.data,
        });
    }

    _eventFromFlutter(eventString) {
        const event = JSON.parse(eventString);
        console.log('EventBusHTML.eventFromFlutter: ', event);
        this._publishEvent({
            source: 'flutter',
            type: event.type,
            data: event.data,
        });
    }

    _emitToHtml(event) {
        if (event.source !== 'html') {
            console.log('EventBusHTML.emitToHtml: ', event);
            (this.eventListenerMap[event.type] ?? [])
                .forEach(listener => listener(event));
        }
    }

    _emitToIframe(event) {
        if (event.source !== 'iframe') {
            console.log('EventBusHTML.emitToIframe: ', event);
            const iframe = document.querySelector(`iframe`);
            if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage(event, '*');
            }
        }
    }

    _emitToFlutter(event) {
        if (event.source !== 'flutter') {
            console.log('EventBusHTML.emitToFlutter: ', event);
            window._EventBusState.emitToFlutter(JSON.stringify(event));
        }
    }
}


function flutterInit(config = {}) {
    const cfg = {
        iframeId: 'interactive_web_view',
        flutterId: 'flutter_target',
        initFunction: '_EventBusState',
        eventBus: false,
        ...config
    };

    return new Promise((accept,reject) => {
        window.addEventListener('load', function() {
            const { iframeId, flutterId, eventBus } = cfg;

            const outerEventBus = new EventBusHTML(cfg);

            _flutter.loader.loadEntrypoint({
                serviceWorker: {
                    serviceWorkerVersion: serviceWorkerVersion,
                },
                onEntrypointLoaded: function(engineInitializer) {
                    engineInitializer.initializeEngine({
                        hostElement: document.querySelector(`#${flutterId}`),
                    }).then(function(appRunner) {
                        appRunner.runApp();
                    });
                }
            });

            accept(eventBus ? outerEventBus : null);
        });
    });
}

export { flutterInit };