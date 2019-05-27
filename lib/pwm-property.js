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
var console = require('console'); // Disable logs here by editing to '!console.log'
var log = console.log || function () {};
var verbose = console.log || function () {};
var webthing = require('webthing-iotjs');

var Property = webthing.Property;
var Value = webthing.Value;

var pwm = require('pwm');

function PwmOutProperty(thing, name, value, metadata, config) {
  var self = this;
  webthing.Property.call(this, thing, name || "PwmOut", new webthing.Value(Number(value)), {
    '@type': 'LevelProperty',
    title: metadata && metadata.title || "Level: ".concat(name),
    type: 'number',
    minimum: config.minimum,
    maximum: config.maximum,
    description: metadata && metadata.description || "PWM Actuator"
  });
  {
    this.config = config;
    if (! this.config.pwm) {
      this.config.pwm = {
        pin: 0, //TODO
        dutyCycle: .5, // TODO convert
        period: .02 // 50Hz
      };
    }
    if (typeof this.config.pwm.dutyCycle == 'undefined') {    
      if (typeof this.config.convert != 'undefined') {
        this.config.pwm.dutyCycle = this.config.pwm.convert(config.minimum + config.maximum / 2);
      } else {
        this.config.pwm.dutyCycle = 0.5;
      }
    }
    verbose('log: opening: ' + metadata.description);
    verbose(this.config.pwm);
    this.port = pwm.open(this.config.pwm, function (err, port) {
      verbose("log: PWM: "  +  self.getName() + ": open: " + err);
      if (err) {
        console.error("error: PWM: ".concat(self.getName(), ": Fail to open: ").concat(err));
        throw err;
      }
      self.port.freq = 1 / self.config.pwm.period;
      self.port.setFrequencySync(self.port.freq);
      self.port.setEnableSync(true);

      self.value.valueForwarder = function (value) {
        if (typeof self.config.pwm.convert != 'undefined') {
          value = self.config.pwm.convert(value);
        }
        verbose(self.port.freq);
        self.port.setDutyCycleSync(Number(value));
      };
    });
  }

  this.close = function () {
    verbose("log: PWM: ".concat(self.getName(), ": close:"));
    try {
      self.port && self.port.closeSync();
    } catch (err) {
      console.error("error: PWM: ".concat(self.getName(), ": Fail to close: ").concat(err));
      return err;
    }
  };

  return this;
}

// TODO In/Out

module.exports = PwmOutProperty;

if (module.parent === null) {
  var app = new PwmOutProperty;
}
