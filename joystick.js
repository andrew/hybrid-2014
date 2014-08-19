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
    freq: 20
  });

  button = new five.Button({
    pin: 7,
    isPullup: true
  });

  joystick.on("axismove", function(err, timestamp) {
    x = scale(this.fixed.x);
    y = scale(this.fixed.y);

    exec("cliclick  m:"+format(x)+","+format(y));
  });

  button.on("down", function() {
    exec('cliclick c:.');
  });
});
