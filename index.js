// -*- mode: js; js-indent-level:2;  -*-
// SPDX-License-Identifier: MPL-2.0

/**
 *
 * Copyright 2018-present Samsung Electronics France SAS, and other contributors
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.*
 */
var console = require('console'); // Disable logs here by editing to '!console.log'
var log = console.log || function () {};
var verbose = console.log || function () {};

var webthing;

try {
  webthing = require('../webthing');
} catch (err) {
  webthing = require('webthing-iotjs');
}

var Property = webthing.Property;
var Value = webthing.Value;

var Thing = webthing.Thing;
var WebThingServer = webthing.WebThingServer;
var SingleThing = webthing.SingleThing; // Update with different board here if needed

function PwmOutProperty(thing, name, value, metadata, config) {
  var self = this;
  Property.call(this, thing, name || "PwmOut", new Value(Number(value)), {
    '@type': 'LevelProperty',
    title: metadata && metadata.title || "Level: ".concat(name),
    type: 'number',
    minimum: config.minimum || (1 - .4) / 20,
    maximum: config.maximum || (2 + .4) / 20,
    description: metadata && metadata.description || "PWM Actuator on pin=".concat(config.pin)
  });
  {
    this.config = config;
    self.value.valueForwarder = function (value) {
      verbose('forward: ' + value);
    };
  }

  this.close = function () {
    log("log: PWM: ".concat(self.getName(), ": close:"));
  };

  return this;
}


function PwmThing(name, type, description) {
  var self = this;
  Thing.call(this, name || 'PWM', type || [], description || 'A web connected PWM');
  {

    var offset = .4;
    var period = 20;
    this.pinProperties = [
      new PwmOutProperty(this, 'Torso', 0, {
        description: 'Torso'
      }, {
        pin: 1,
        minimum: -90,
        maximum: +90,
      }),
      new PwmOutProperty(this, 'Shoulder', 0, {
        description: 'Shoulder'
      }, {
        pin: 1,
        minimum: 0,
        maximum: +30,
      }),
      new PwmOutProperty(this, 'Arm', 0, {
        description: 'Arm'
      }, {
        pin: 1,
        minimum: 15,
        maximum: +45,
      }),
      new PwmOutProperty(this, 'Hand', 0, {
        description: 'Hand'
      }, {
        pin: 0,
        minimum: -90,
        maximum: +90,
      }),
    ];

    this.pinProperties.forEach(function (property) {
      self.addProperty(property);
    });


    this.close = function () {
      self.pinProperties.forEach(function (property) {
        property.close && property.close();
      });
    };
  }
}

var BoardThing = PwmThing;

function runServer() {
  var port = process.argv[3] ? Number(process.argv[3]) : 8888;
  var url = "http://localhost:".concat(port);
  var thing = new BoardThing();
  var server = new WebThingServer(new SingleThing(thing), port);
  process.on('SIGINT', function () {
    server.stop();

    var cleanup = function () {
      thing && thing.close();
      process.exit();
    };

    cleanup();
  });
  server.start();
}

runServer();
