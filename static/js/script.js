(function() {
    'use strict';

    var ws = new WebSocket('ws://localhost:1102/chat');

    ws.onmessage = function(e) {
        console.log(e.data);
    };

    ws.onopen = function() {
        ws.send('How are you doing?');
    };
}());
