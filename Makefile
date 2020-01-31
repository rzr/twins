#!/bin/make -f
# -*- makefile -*-
# SPDX-License-Identifier: MPL-2.0
#{
# Copyright 2018-present Samsung Electronics France SAS, and other contributors
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/# .
#}

default: help
	@echo "log: $@: $^"

project?=twins
runtime?=iotjs
webthing_url?=http://${project}.glitch.me
example_file=index.js
run_args?=
target_port?=8888
target_host?=localhost
target_url?=http://${target_host}:${target_port}
export target_url
simulator_port=42088
simulator_host?=localhost
simulator_url?=http://${target_host}:${simulator_port}/?useWs=no

lib_srcs?=$(wildcard *.js lib/*.js | sort | uniq)
srcs?=${lib_srcs}

iotjs_modules_dir ?= ${CURDIR}/iotjs_modules
export iotjs_modules_dir

webthing-iotjs_url ?= https://github.com/rzr/webthing-iotjs
webthing-iotjs_revision ?= webthing-iotjs-0.12.1-1
webthing-iotjs_dir ?= ${iotjs_modules_dir}/webthing-iotjs
iotjs_modules_dirs += ${webthing-iotjs_dir}

deploy_modules_dir?=${CURDIR}/tmp/deploy/iotjs_modules
deploy_module_dir?= ${deploy_modules_dir}/${project}
deploy_dirs+= ${deploy_module_dir}
deploy_dirs+= ${deploy_modules_dir}/webthing-iotjs
deploy_srcs+= $(addprefix ${deploy_module_dir}/, ${srcs})

curl?=curl \
 -H "Accept: application/json" \
 -H "Content-type: application/json" \
 ${curl_args}

sleep_secs?=1


%: ${runtime}/%
	@echo "log: $@: $^"

run: ${runtime}/start
	@echo "log: $@: $^"

help:
	@echo "# Usage:"
	@echo "# make runtime=${runtime} start"

setup: Makefile
	@echo "# log: $@: $^"
	@iotjs -h 2>&1 | grep -o 'Usage: iotjs' > /dev/null || echo "Error: iotjs not usable"

check:
	@echo "TODO: implements $@"

test:
	@echo "TODO: implements $@"

modules: ${runtime}/modules
	@echo "log: $@: $^"

node/modules: package.json
	npm install

node/start: ${example_file} modules
	${@D} $< ${run_args}


iotjs/start: ${example_file} ${iotjs_modules_dirs}
	iotjs $< ${run_args}


iotjs/client:
	curl -i ${target_url}
	curl -i ${target_url}/properties

iotjs/client/web:
	curl -i ${webthing_url}
	curl -i ${webthing_url}/properties


LICENSE: /usr/share/common-licenses/MPL-2.0
	cp -a $< $@


iotjs/modules: ${iotjs_modules_dirs}
	ls $^

${webthing-iotjs_dir}: Makefile
	@echo "log: $@: $^"
	git clone --recursive --depth=1 \
 --branch "${webthing-iotjs_revision}" \
 "${webthing-iotjs_url}" \
 "$@"
	${MAKE} -C $@ ${runtime}/modules

deploy: ${deploy_srcs} ${deploy_dirs}
	ls $<

${deploy_module_dir}/%: %
	@echo "# TODO: minify: $< to $@"
	install -d ${@D}
	install $< $@

${deploy_modules_dir}/webthing-iotjs: ${iotjs_modules_dir}/webthing-iotjs
	make -C $< deploy deploy_modules_dir="${deploy_modules_dir}" project="${@F}"

property/%:
	${curl} ${target_url}/properties/${@F}
	@echo ""
	${curl} -X PUT -d '{ "${@F}": ${value} }' ${target_url}/properties/${@F}
	@echo ""
	sleep ${sleep_secs}

properties:
	${curl} -i ${target_url}/properties

zero:
	${MAKE} property/torso value=0
	${MAKE} property/shoulder value=0
	${MAKE} property/arm value=0
	${MAKE} property/hand value=0

hand: # [0 45]
	${MAKE} property/${@F} value=0
	${MAKE} property/${@F} value=10
	${MAKE} property/${@F} value=20
	${MAKE} property/${@F} value=30
	${MAKE} property/${@F} value=40
	${MAKE} property/${@F} value=10
	${MAKE} property/${@F} value=0
	${MAKE} property/${@F} value=-5
	${MAKE} property/${@F} value=0

arm: # [-45 +45]
	${MAKE} property/${@F} value=0
	${MAKE} property/${@F} value=45
	${MAKE} property/${@F} value=-45
	${MAKE} property/${@F} value=0

shoulder: #[ -45, 45]
	${MAKE} property/shoulder value=-45
	${MAKE} property/shoulder value=0
	${MAKE} property/shoulder value=45
	${MAKE} property/shoulder value=0

demo: zero
	${MAKE} property/hand value=40
	${MAKE} property/arm value=-15
	${MAKE} property/shoulder value=20
	${MAKE} property/arm value=-20
	${MAKE} property/shoulder value=45
	${MAKE} property/hand value=20
	${MAKE} property/hand value=0
	${MAKE} property/arm value=0
	${MAKE} property/arm value=15
	${MAKE} property/shoulder value=0
	${MAKE} property/shoulder value=-45
	${MAKE} property/shoulder value=0
	${MAKE} property/arm value=-20
	${MAKE} property/shoulder value=20
	${MAKE} property/shoulder value=45
	${MAKE} property/arm value=-20
	${MAKE} property/hand value=10
	${MAKE} property/hand value=20
	${MAKE} property/hand value=30
	${MAKE} property/hand value=40
	${MAKE} zero

remote:
	${MAKE} demo

simulate:
	${MAKE} start runtime=node

view: aframe
	cd $< && \
 npm install && \
 PORT=${simulator_port} npm start

devel:
	xterm -e "make simulate" &
	xterm -e "make view" &
	x-www-browser ${simulator_url} &
	make rule/front rule/back

rule/back:
	${MAKE} property/shoulder value=-45
	${MAKE} property/arm value=45


rule/front:
	${MAKE} property/arm value=-45
	${MAKE} property/shoulder value=45

