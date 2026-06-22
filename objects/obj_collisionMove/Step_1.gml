/// @description Move in a circle
dir += rotSpd * global.timeSpeed;

//// Get target position
//var _targetX = xstart + lengthdir_x(radius, dir);
//var _targetY = ystart + lengthdir_y(radius, dir);

////speedX = _targetX - x;
//speedY = _targetY - y;

// Move up and down
// Move diagonally
var _targetY = 0;
var distanceY = (ystart-(16*5)) - ystart;
var _targetX = 0;
var distanceX = (xstart+(16*2)) - (xstart-(16*2));
var position = 0;
var dirRemainder = dir - floor(dir);

switch ceil(dir % 4) {
	case 1:
		position = animcurve_channel_evaluate(animCurve, dirRemainder);
		_targetY = ystart + (distanceY * position);
		_targetX = (xstart-(16*2)) + (distanceX * position);
	break;
	case 2:
		_targetY = ystart + distanceY;
		_targetX = (xstart-(16*2)) + distanceX;
	break;
	case 3:
		position = animcurve_channel_evaluate(animCurve, dirRemainder);
		_targetY = (ystart+distanceY) - (distanceY * position); // case 1 but in reverse;
		_targetX = ((xstart-(16*2))+distanceX) - (distanceX * position);
	break;
	case 4:
		_targetY = ystart;
		_targetX = (xstart-(16*2));
	break;
}

// Move
//x += speedX;
//y += speedY;
xReal = _targetX;
yReal = _targetY;

speedX = xReal - xPrev;
speedY = yReal - yPrev;

xPrev = xReal;
yPrev = yReal;

reposition();