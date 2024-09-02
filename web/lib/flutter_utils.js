class EventBus {
    constructor(iframeName) {
        console.log('EventBus: Initialising EventBus');
        this.iframeName = iframeName;

        const self = this;
        window._EventBusInitialise = function (webViewName) {
            console.log('EventBus: Web View Name:', webViewName);
            window._EventBusInitialise = function () {
                console.log("EventBus: Call _stateSet only once!");
            };
            self.initialise(webViewName);
        }
    }

    initialise(webViewName) {
        console.log('EventBus.initialise: ');
        window.addEventListener('message', this.listenToWebView.bind(this));
        window._EventBusState.addFlutterListener(this.listenToFlutter.bind(this));
    }

    dispose() {
        console.log('EventBus.dispose: ');
        window.addEventListener(this.listenToWebView);
        window._EventBusState.removeFlutterListener(this.listenToFlutter.bind(this));
    }

    listenToWebView(event) {
        console.log('EventBus.listenToWebView: ', event);
        window._EventBusState.emitToFlutter(event.data);
    }

    emitToWebView(event) {
        console.log('EventBus.emitToWebView: ', event);
        const iframe = document.querySelector(`iframe`);
        if (iframe && iframe.contentWindow) {
            iframe.contentWindow.postMessage(event, '*');
        }
    }

    listenToFlutter(event) {
        console.log('EventBus.listenToFlutter: ', event);
        this.updateCounterSpan(event);
        this.emitToWebView(event);
    }

    emitToFlutter(event) {
        console.log('EventBus.emitToFlutter: ', event);
        window._EventBusState.emitToFlutter(event);
    }

    updateCounterSpan(value) {
        console.log('EventBus.updateCounterSpan: ', value);
        document.getElementById('counter').innerText = value;
    }
}

function flutterInit(config = {}) {
    const cfg = {
        iframeId: 'interactive_web_view',
        flutterId: 'flutter_target',
        ...config
    };
    const {iframeId, flutterId} = cfg;
    return new Promise((accept, reject) => {
        window.addEventListener('load', function() {
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
            this.eventBus = new EventBus(iframeId);
            accept(this.eventBus);
        });
    });
}

export { EventBus, flutterInit };