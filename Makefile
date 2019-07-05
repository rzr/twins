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

project?=twins
runtime?=iotjs
webthing_url?=http://${project}.glitch.me
example_file=index.js
run_args?=
port?=8888
target_url?=http://localhost:${port}
export target_url

lib_srcs?=$(wildcard *.js lib/*.js | sort | uniq)
srcs?=${lib_srcs}

iotjs_modules_dir?=${CURDIR}/iotjs_modules

webthing-iotjs_url?=https://github.com/rzr/webthing-iotjs
#TODO: pin version
webthing-iotjs_revision?=master
webthing-iotjs_dir?=${iotjs_modules_dir}/webthing-iotjs
iotjs_modules_dirs+=${webthing-iotjs_dir}

deploy_modules_dir?=${CURDIR}/tmp/deploy/iotjs_modules
deploy_module_dir?= ${deploy_modules_dir}/${project}
deploy_dirs+= ${deploy_module_dir}
deploy_dirs+= ${deploy_modules_dir}/webthing-iotjs
deploy_srcs+= $(addprefix ${deploy_module_dir}/, ${srcs})


%: ${runtime}/%
	@echo "log: $@: $^"


help:
	@echo "# Usage:"
	@echo "# make runtime=${runtime} start"

iotjs/start: ${example_file} ${iotjs_modules_dirs}
	iotjs $< ${run_args}

iotjs/modules: ${iotjs_modules_dirs}
	ls $<

iotjs/client:
	curl -i ${target_url}
	curl -i ${target_url}/properties

iotjs/client/web:
	curl -i ${webthing_url}
	curl -i ${webthing_url}/properties

deploy: ${deploy_srcs} ${deploy_dirs}
	ls $<

LICENSE: /usr/share/common-licenses/MPL-2.0
	cp -a $< $@

${webthing-iotjs_dir}: Makefile
	git clone --recursive --depth 1 ${webthing-iotjs_url} -b ${webthing-iotjs_revision} $@
	make -C $@ deploy deploy_modules_dir=${iotjs_modules_dir}

${deploy_module_dir}/%: %
	@echo "# TODO: minify: $< to $@"
	install -d ${@D}
	install $< $@

${deploy_modules_dir}/webthing-iotjs: ${iotjs_modules_dir}/webthing-iotjs
	make -C $< deploy deploy_modules_dir="${deploy_modules_dir}"


property/%:
	curl ${target_url}/properties/${@F}
	curl -X PUT -d '{ "${@F}": ${value} }' ${target_url}/properties/${@F}
	sleep 2

zero:
	${MAKE} property/torso value=0
	${MAKE} property/shoulder value=0
	${MAKE} property/arm value=0
	${MAKE} property/hand value=0

demo: zero
	${MAKE} property/hand value=0
	${MAKE} property/hand value=20
	${MAKE} property/arm value=15
	${MAKE} property/shoulder value=-20
	${MAKE} property/shoulder value=-40
	${MAKE} property/shoulder value=-60
	${MAKE} property/hand value=-5
	${MAKE} property/shoulder value=-30
	${MAKE} property/shoulder value=0
	${MAKE} property/shoulder value=45
	${MAKE} property/arm value=10
	${MAKE} property/arm value=-15
