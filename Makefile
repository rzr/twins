#!/bin/make -f
# -*- makefile -*-
# SPDX-License-Identifier: MPL-2.0
#{
# Copyright 2018-present Samsung Electronics France SAS, and other contributors
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.*
#}

default: help
	@echo "log: $@: $^"

runtime?=iotjs
webthing_url?=http://rzr-twins.glitch.me
example_file=index.js
run_args?=

iotjs_modules_dir?=${CURDIR}/iotjs_modules

webthing-iotjs_url?=https://github.com/rzr/webthing-iotjs
#TODO: pin version
webthing-iotjs_revision?=master
webthing-iotjs_dir?=${iotjs_modules_dir}/webthing-iotjs
iotjs_modules_dirs+=${webthing-iotjs_dir}

%: ${runtime}/%
	@echo "log: $@: $^"


help:
	@echo "# Usage:"
	@echo "# make runtime=${runtime} start"

iotjs/start: ${example_file} ${iotjs_modules_dirs}
	iotjs $< ${run_args}

iotjs/modules: ${iotjs_modules_dirs}
	ls $<

LICENSE: /usr/share/common-licenses/MPL-2.0
	cp -a $< $@

${webthing-iotjs_dir}: Makefile
	git clone --recursive --depth 1 ${webthing-iotjs_url} -b ${webthing-iotjs_revision} $@
	make -C $@ deploy deploy_modules_dir=${iotjs_modules_dir}

