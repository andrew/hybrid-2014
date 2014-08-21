// http://www.htmltetris.com/

var five = require("johnny-five"),
  board, joystick, button;

var exec = require('child_process').exec;

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
    freq: 200
  });

  button = new five.Button({
    pin: 7,
    isPullup: true
  });

  joystick.on("axismove", function(err, timestamp) {
    x = this.fixed.x - 0.5;
    y = this.fixed.y - 0.5;
    // left or right arrows
    if(Math.abs(x) > 0.2){
      if(x < 0) {
        console.log('left');
        exec('cliclick kp:arrow-left');
      } else {
        console.log('right');
        exec('cliclick kp:arrow-right');
      }
    }

    // up or down arrows
    if(Math.abs(y) > 0.2){
      if(y < 0) {
        console.log('up');
        exec('cliclick kp:arrow-up');
      } else {
        console.log('down');
        exec('cliclick kp:arrow-down');
      }
    }

  });

  button.on("down", function() {
    console.log('space');
    exec('cliclick kp:space');
  });
});
