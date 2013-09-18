var ws = new WebSocket('ws://localhost:1102/chat'),
    uid,
    messEl = createMessageElement();

ws.onmessage = function(e) {
    var command = e.data.split(' ')[0];
    switch (command) {
    case 'new-uid':
        uid = e.data.split(' ')[1];
        ws.send(uid + ' join #help');
        break;
    case 'privmsg':
        var el = messEl.cloneNode(true),
            msg = JSON.parse(e.data.split(' ')[1]);

        el.querySelector('.timestamp').textContent = msg.time;
        el.querySelector('.nickname').textContent = msg.source;
        el.querySelector('.content').textContent = msg.args;

        document.querySelector('#messages').appendChild(el);
        break;
    }
};

ws.onopen = function() {
    ws.send('0 connect ' + Math.random().toString(36).substring(7));
};

function createMessageElement() {
    var el = document.createElement('div');
    el.className = 'message';

    var time = document.createElement('div');
    time.className = 'timestamp';
    el.appendChild(time);

    var nick = document.createElement('div');
    nick.className = 'nickname';
    el.appendChild(nick);

    var msg = document.createElement('div');
    msg.className = 'content';
    el.appendChild(msg);

    return el;
}
