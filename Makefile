base_url?=https://webthing-iotjs-robot.glitch.me/properties
www_host?=192.168.1.12
www_url?=http://${www_host}/~${USER}/${www_dir}
www_dir?=d
target_host?=192.168.1.13
target_url?=http://${target_host}:8888
make=make

test:
	curl -X PUT -d '{ "Torso": -90 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": -90 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm": -90 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": -90 }'  ${base_url}/Hand
	sleep 10

	curl -X PUT -d '{ "Torso": 0 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": 0 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm": 0 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": 0 }'  ${base_url}/Hand
	sleep 10

	curl -X PUT -d '{ "Torso": 45 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": 45 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm": 45 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": 45 }'  ${base_url}/Hand
	sleep 10

	curl -X PUT -d '{ "Torso": 90 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": 90 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm": 90 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": 90 }'  ${base_url}/Hand
	sleep 10

	curl -X PUT -d '{ "Torso": -160 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": -45 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm":  -90 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": 40 }'  ${base_url}/Hand
	sleep 10

	curl -X PUT -d '{ "Torso": -140 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": -75 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm":  -80 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": 80 }'  ${base_url}/Hand
	sleep 10

stable:
	curl -X PUT -d '{ "Torso": -160 }'  ${base_url}/Torso
	curl -X PUT -d '{ "Shoulder": -45 }'  ${base_url}/Shoulder
	curl -X PUT -d '{ "Arm":  -90 }'  ${base_url}/Arm
	curl -X PUT -d '{ "Hand": 40 }'  ${base_url}/Hand


start:
	while true ; do make test ; sleep 60 ; done

rule/webthing-iotjs/property/%:
	curl ${target_url}/properties/${@F}
	curl -X PUT -d '{ "${@F}": ${value} }' ${target_url}/properties/${@F}
	sleep 2

zero:
	${make} rule/webthing-iotjs/property/Torso value=0
	${make} rule/webthing-iotjs/property/Shoulder value=0
	${make} rule/webthing-iotjs/property/Arm value=0
	${make} rule/webthing-iotjs/property/Hand value=0


rule/webthing-iotjs/%:
	${make} rule/webthing-iotjs/property/${@F} value=0
	${make} rule/webthing-iotjs/property/${@F} value=-90
	${make} rule/webthing-iotjs/property/${@F} value=0
	${make} rule/webthing-iotjs/property/${@F} value=90
	${make} rule/webthing-iotjs/property/${@F} value=0

rule/webthing-iotjs/Shoulder: #[ -90, 45]
	${make} rule/webthing-iotjs/property/Shoulder value=-90
	${make} rule/webthing-iotjs/property/Shoulder value=10
	${make} rule/webthing-iotjs/property/Shoulder value=30
	${make} rule/webthing-iotjs/property/Shoulder value=45
	${make} rule/webthing-iotjs/property/Shoulder value=0

rule/webthing-iotjs/Arm: # [-45 +45]
	${make} rule/webthing-iotjs/property/${@F} value=0
	${make} rule/webthing-iotjs/property/${@F} value=45
	${make} rule/webthing-iotjs/property/${@F} value=-45
	${make} rule/webthing-iotjs/property/${@F} value=0

rule/webthing-iotjs/Hand: # [0 45]
	${make} rule/webthing-iotjs/property/${@F} value=0
	${make} rule/webthing-iotjs/property/${@F} value=40
#	${make} rule/webthing-iotjs/property/${@F} value=10
	${make} rule/webthing-iotjs/property/${@F} value=-5
	${make} rule/webthing-iotjs/property/${@F} value=0


demo: zero
	${make} rule/webthing-iotjs/property/Hand value=0
	${make} rule/webthing-iotjs/property/Hand value=20
	${make} rule/webthing-iotjs/property/Arm value=15
	${make} rule/webthing-iotjs/property/Shoulder value=-20
	${make} rule/webthing-iotjs/property/Shoulder value=-40
	${make} rule/webthing-iotjs/property/Shoulder value=-60
	${make} rule/webthing-iotjs/property/Hand value=-5
	${make} rule/webthing-iotjs/property/Shoulder value=-30
	${make} rule/webthing-iotjs/property/Shoulder value=0
	${make} rule/webthing-iotjs/property/Shoulder value=45
	${make} rule/webthing-iotjs/property/Arm value=10
	${make} rule/webthing-iotjs/property/Arm value=-15
