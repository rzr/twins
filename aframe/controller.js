// -*- mode: js; js-indent-level:2;  -*-
// SPDX-License-Identifier: MPL-2.0

/**
 *
 * Copyright 2018-present Samsung Electronics France SAS, and other contributors
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/
 */

var app = {
  pause: 'no',
  property: 'hand',
  url: (localStorage.url || 'http://localhost:8888'),
  suffix: '',
  useWs: (localStorage.useWs || 'yes'),
  wsUrl: (localStorage.wsUrl || 'ws://localhost:8888'),
  delay: 500,
  verbose: (localStorage.verbose || 'no'),
  bearer: localStorage.bearer,
  root: localStorage.root || 'robot'
};

let interval = null;
let ws = null;

function verbose(arg)
{
  if (app.verbose === 'yes') {
    console.log(arg);
  }
}

function update(properties)
{
  verbose('update: ');
  verbose(properties);
  document.title = JSON.stringify(properties);
  var root = document.getElementById(app.root);
  for (var property of Object.keys(properties)) {
    root.setAttribute(app.root, property, properties[property]);
  }
}

function query()
{
  var url = `${app.url}/properties`;
  verbose(`log: fetch: ${url}`);
  fetch(url)
    .then((response) => {
      return response.json();
    }, (reason) => {
      verbose(reason);
      if (app.suffix && app.suffix.length()) {
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
    })
    .catch((err) => {
      console.error(err);
      if (confirm('Error: Connection issue, Please update settings')) {
        window.location.href = 'settings.html';
      }
    });
}


function poll(delay)
{
  var that = this;
  if (!delay) {
    delay = app.delay;
  }
  verbose(`log: loop: waiting delay: ${delay}`);
  this.interval = setInterval(() => {
    if (app.pause === 'yes') {
      verbose(`log: stopping: ${app.pause}`);
      that.inverval = clearInterval(that.interval);
    }
    query();
  }, Number(delay));
}


function start()
{
  let searchParams = null;
  if (document.location.search) {
    searchParams = (new URL(document.location)).searchParams;
  }
  if (searchParams) {
    for (let entry of searchParams.entries())
      app[entry[0]] = entry[1];
  }

  verbose(app);
  for (let key of Object.keys(app)) {
    localStorage[key] = String(app[key]);
  }

  let useWebsockets = ("WebSocket" in window) && (app.useWs === 'yes');
  if (useWebsockets) {
    let wsUrl = app.wsUrl;
    if (app.bearer)
      wsUrl += `?jwt=${app.bearer}`;
    verbose(wsUrl);
    ws = new WebSocket(wsUrl);
    ws.onclose = function (evt) {
      /// CLOSE_ABNORMAL
      if (evt.code === 1006) {
        poll();
      }
    }
    ws.onmessage = function (evt) {
      verbose(evt);
      if (app.pause === 'yes') {
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
  app.pause = (status) ? 'yes' : 'no';
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
}, Number(app.delay));
