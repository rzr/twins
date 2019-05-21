var app = {
  pause: false,
  property: 'torso',
  url: 'https://webthing-iotjs-robot.glitch.me',
  suffix: '',
  useWs: false,
  wsUrl: 'ws://localhost:8888',
  delay: 500,
  verbose: false,
};

app.url = 'http://192.168.1.13:8888';

let interval = null;
let ws = null;

function verbose(arg)
{
  if (app.verbose) {
    console.log(arg);
  }
}

function update(properties)
{
  verbose(properties);
  document.title = properties;
  var robot = document.getElementById('robot');
  for (var property of Object.keys(properties)) {
    robot.setAttribute('robot', property, properties[property]);
  }
}

function query()
{
    var property = app.property;
    var url = `${app.url}/properties`;
    verbose(`log: fetch: ${url}`);
    fetch(url)
      .then((response) => {
        return response.json();
      }, (reason) => {
        verbose(reason);
        if (false) {
          app.url = String(window.location)
            .substring(0, String(window.location).lastIndexOf("/"))
            + '/json';
          app.suffix = '/index.html';
        }
        verbose(`log: Fallback to static: ${app.url}`);
      })
      .then((json) => {
        verbose(`log: payload: ${JSON.stringify(json)}`);
        update(json);
      });
}


function poll(delay)
{
  if (!delay) {
    delay = app.delay;
  }
  verbose(`log: loop: waiting delay: ${delay}`);
  interval = setInterval(() => {
    if (app.pause) {
      verbose(`log: stopping: ${app.pause}`);
      inverval = clearInterval(interval);
    }
    query();
  }, delay);
}


function start()
{
  let wsUrl = app.wsUrl.value;
  let useWebsockets = ("WebSocket" in window) && app.useWsl

  let searchParams = null;
  if (document.location.search) {
    searchParams = (new URL(document.location)).searchParams;
  }
  if (searchParams) {
    for (var entry of searchParams.entries())
      app[entry[0]] = entry[1];
  }

  if (useWebsockets) {
    ws = new WebSocket(wsUrl);
    ws.onclose = function (evt) {
      /// CLOSE_ABNORMAL
      if (evt.code === 1006) {
        poll();
      }
    }
    ws.onmessage = function (evt) {
      if (app.pause) {
        ws.close();
      }
      update(JSON.parse(evt.data).data);
    }
  } else {
    if (ws) ws.close();
    query();
    poll();
  }
}

function toggle(status)
{
  app.pause = status;
  if (status) {
    start();
  } else {
    if (ws) {
      ws.close();
      ws = null;
    }
    if (interval) {
      clearInterval(interval);
    }
  }
}

setTimeout(function() {
 start();
}, app.delay);
