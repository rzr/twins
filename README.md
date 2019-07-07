# TWINS #

[![GitHub forks](https://img.shields.io/github/forks/rzr/twins.svg?style=social&label=Fork&maxAge=2592000)](https://GitHub.com/rzr/twins/network/)
[![license](https://img.shields.io/badge/license-MPL--2.0-blue.svg)](LICENSE)
[![NPM](https://img.shields.io/npm/v/twins.svg)](https://www.npmjs.com/package/twins)
[![IRC Channel](https://img.shields.io/badge/chat-on%20freenode-brightgreen.svg)](https://kiwiirc.com/client/irc.freenode.net/#tizen)

[![NPM](https://nodei.co/npm/twins.png)](https://npmjs.org/package/twins)


## INTRODUCTION: ##

Web Of Twins proof of concept

[![Concept](https://image.slidesharecdn.com/web-of-twins-20190604rzr-190604205255/95/weboftwins20190604rzr-1-638.jpg)](http://www.slideshare.net/slideshow/embed_code/key/16GRRsNuiRCfa6#weboftwins20190604rzr# "weboftwins20190604rzr")


## USAGE: ##


```sh
make start
#| iotjs index.js 
#| Listening:
#| http://localhost:8888/

url=http://localhost:8888
curl $url/properties
#| {"torso":0,"shoulder":0,"arm":0,"hand":0}

curl -X PUT  -H "Content-type: application/json" -d '{ "hand": 10 }' $url/properties/hand
#| {"hand":10}

make demo
```

Then twin can be visualized using:

* <http://rzr.github.io/twins/aframe/?url=http://localhost:8888>


## GUIDE: ##

* <https://github.com/rzr/twins/wiki/DigitalTwins>


## DEMO: ##

[![PoC](https://i.giphy.com/media/XCsnIn6WlWNOeT2etZ/giphy.gif)](https://purl.org/rzr/digitaltwins-webthings-iotjs-20190512rzr#digitaltwins-webthings-iotjs-20190512rzr# "digitaltwins-webthings-iotjs-20190512rzr")


## RESOURCES: ##

* <https://purl.org/rzr/digitaltwins-webthings-iotjs-20190512rzr#>
