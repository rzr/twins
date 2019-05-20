AFRAME.registerComponent('motor', {
  schema: {
    angle: { type: 'number', default: 0},
    color: { type: 'color', default: 'gray'}
  },
  
  init: function() {
    this.child = document.createElement('a-box');
    this.child.setAttribute('color', this.data.color);
    this.el.appendChild(this.child);
  },
  update: function(old) {
    console.log('update');
    var angle = Number(this.data.angle);
    this.child.object3D.rotation.set(0, Number(this.data.angle), 0);
  }
});
