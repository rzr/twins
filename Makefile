base_url?=https://webthing-iotjs-robot.glitch.me/properties

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
