/// @description Move in a circle
dir += rotSpd * global.timeSpeed;

// Get target position
var _targetX = xstart + lengthdir_x(radius, dir);
var _targetY = ystart + lengthdir_y(radius, dir);

speedX = _targetX - xReal;
speedY = _targetY - yReal;

// Move
xReal += speedX;
yReal += speedY;

reposition();