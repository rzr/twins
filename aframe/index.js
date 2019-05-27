AFRAME.registerComponent('robot', {
  schema: {
    torso: { type: 'number', default: 0},
    shoulder: { type: 'number', default: 0},
    arm: { type: 'number', default: 0},
    hand: { type: 'number', default: 0},
  },
 
  init: function() {
    console.log(this.data);
    var torso = document.createElement('a-entity');
    torso.setAttribute('id', 'torso');
    var torsoBox = document.createElement('a-box');
    torsoBox.setAttribute('material', { color: '#000' });
    torsoBox.setAttribute('scale', "2 1 2");
    torso.appendChild(torsoBox);
    this.el.appendChild(torso);

    var shoulderGroup = document.createElement('a-entity');
    shoulderGroup.setAttribute('rotation', '-45 0 0');
    shoulderGroup.setAttribute('position', "0 .5 0");
    var shoulder = document.createElement('a-entity');
    shoulder.setAttribute('id', 'shoulder');
    var shoulderJunction = document.createElement('a-cylinder');
    shoulderJunction.setAttribute('scale', ".4 1 .4");
    shoulderJunction.setAttribute('rotation', "0 0 90");
    shoulderJunction.setAttribute('material', { color: '#AAA' });
    shoulder.appendChild(shoulderJunction);
    
    var shoulderBox = document.createElement('a-box');
    shoulderBox.setAttribute('material', { color: '#0F0' });
    shoulderBox.setAttribute('scale', ".7 6 .7");
    shoulderBox.setAttribute('position', "0 3 0");
    shoulder.appendChild(shoulderBox);
    shoulderGroup.appendChild(shoulder);
    torso.appendChild(shoulderGroup);

    var armGroup = document.createElement('a-entity');
    armGroup.setAttribute('rotation', '-90 0 0');
    armGroup.setAttribute('position', "0 6 0");
    var arm = document.createElement('a-entity');
    arm.setAttribute('id', 'arm');

    var armJunction = document.createElement('a-cylinder');
    armJunction.setAttribute('scale', ".4 .71 .4");
    armJunction.setAttribute('rotation', "0 0 90");
    armJunction.setAttribute('material', { color: '#AAF' });
    arm.appendChild(armJunction);
    var armBox = document.createElement('a-box');
    armBox.setAttribute('material', { color: '#00F' });
    armBox.setAttribute('scale', ".4 3 .4");
    armBox.setAttribute('position', "0 1.5 0");
    arm.appendChild(armBox);
    armGroup.appendChild(arm);
    shoulder.appendChild(armGroup);
    
    var hand = document.createElement('a-entity');
    //hand.setAttribute('rotation', '-70 0 0');
    hand.setAttribute('position', "0 4 0");

    var handJunction = document.createElement('a-cylinder');
    handJunction.setAttribute('material', { color: '#0FF' });
    handJunction.setAttribute('scale', ".5 .8 .5");
    handJunction.setAttribute('position', "0 -1 0");
    hand.appendChild(handJunction); //TODO
    //palm.setAttribute('scale', '5 3 .5');

    var palm = document.createElement('a-torus');
    palm.setAttribute('arc', "180");
    palm.setAttribute('rotation', '0 0 90');
    palm.setAttribute('radius-tubular', '.1');
    palm.setAttribute('radius', '1');
    palm.setAttribute('material', { color: '#43A367'});

    var nails = document.createElement('a-box');
    nails.setAttribute('position', ' 1 0 0');
    nails.setAttribute('rotation', '0 0 90');
    nails.setAttribute('scale', '.1 .6 .6');
    nails.setAttribute('color', '#43A367');
    palm.appendChild(nails);
    hand.appendChild(palm);

    var handGroup = document.createElement('a-entity');
    handGroup.setAttribute('rotation', '0 0 10');
    var handEntity = document.createElement('a-entity');
    handEntity.setAttribute('id', 'hand');
    var thumb = document.createElement('a-torus');
    thumb.setAttribute('arc', '180');
    thumb.setAttribute('radius', '1');
    thumb.setAttribute('radius-tubular', '.09');
    thumb.setAttribute('material', { color: '#F00'});
    thumb.setAttribute('rotation', "0 0 180");
    var nail = document.createElement('a-box');
    nail.setAttribute('position', '-1 0.01 0');
    nail.setAttribute('scale', '.1 .6 .6');
    nail.setAttribute('rotation', '0 0 90');
    nail.setAttribute('material', { color: '#F00'});
    thumb.appendChild(nail);
    handEntity.appendChild(thumb);
    handGroup.appendChild(handEntity);
    hand.appendChild(handGroup);
    arm.appendChild(hand);
    this.hand = handEntity;
  },
  update: function(old) {
    var properties = this.data;
    for (var property of Object.keys(properties)) {
      var rotation = [ 0, 0, 0];
      switch(property) {
      case "torso":
        rotation[1] = properties[property];
        break;
      case "hand":
        rotation[2] = - (4 * properties[property]) + 57;
        break;
      case 'shoulder':
        rotation[0] = (properties[property] + 45 ) /2;
        break;
      case 'arm':
        rotation[0] = - properties[property];
        break;        
      default:
        rotation[0] = properties[property];
        break;
      }
      var el = document.getElementById(property);
      if (!el || !el.object3D)
        throw "Null: " + property;

      el.object3D.rotation.set(
        THREE.Math.degToRad(rotation[0]),
        THREE.Math.degToRad(rotation[1]),
        THREE.Math.degToRad(rotation[2]))
    }
  },
  change: function(properties) {
    console.log(properties);
  }

});

console.log('# index.js');
