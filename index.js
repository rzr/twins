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
var console = require('console');
// Disable logs here by editing to '!console.log'
var log = console.log || function () {};
var verbose = console.log || function () {};

if (process && process.iotjs && process.iotjs.board) {
  module.exports = require('lib/index');
} else {
  module.exports = require('./lib/simulator/index.js');
}

if (module.parent === null) {
 module.exports.start();
}
