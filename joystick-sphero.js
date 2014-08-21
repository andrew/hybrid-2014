var five = require("johnny-five"),
  board, joystick, button;

var Cylon = require('cylon');

function format(amount) {
  if(Math.abs(amount) < 5){ amount = 0; }

  if(amount < 0){
    return amount;
  } else {
    return '+'+ amount;
  }
}

function  scale(amount){
  return Math.round((amount - 0.5)*50);
}

board = new five.Board();

board.on("ready", function() {

  joystick = new five.Joystick({
    pins: ["A0", "A1"],
    freq: 20
  });

  button = new five.Button({
    pin: 7,
    isPullup: true
  });

  Cylon.robot({
    connection: { name: 'sphero', adaptor: 'sphero', port: '/dev/cu.Sphero-GGP-AMP-SPP' },
    device: {name: 'sphero', driver: 'sphero'},

    work: function(my) {

      my.sphero.on('connect', function() {
        console.log("Setting up Collision Detection...");
        my.sphero.detectCollisions();
        my.sphero.stop();
      });

      my.sphero.on('collision', function(data) {
        console.log('Ouch!');
      });


      joystick.on("axismove", function(err, timestamp) {
        x = (this.fixed.x - 0.5);
        y = this.fixed.y - 0.5;

        angle = Math.round(five.Board.constrain(Math.atan2(x, y)*(180/Math.PI)+90, 0, 359));
        speed = Math.round(five.Board.constrain(Math.sqrt(Math.pow(x,2)+Math.pow(y,2))*200, 0, 100));

        console.log(speed, angle);

        my.sphero.roll(speed, angle);
      });

      button.on("down", function() {
        my.sphero.setRandomColor();
      });

    }
  }).start();

});
