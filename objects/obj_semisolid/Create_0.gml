/// @description Insert description here
speedX = 0;
speedY = 0;

xReal = xstart;
yReal = ystart;
dirReal = image_angle;

function reposition() {
	anchorRadius = point_distance(global.roomCenterX, global.roomCenterY, xReal, yReal); //// Distance from center
	anchorAngle = point_direction(global.roomCenterX, global.roomCenterY, xReal, yReal); //// Angle (degrees) from center
	x = global.roomCenterX + lengthdir_x(anchorRadius, anchorAngle+global.screenDir);
	y = global.roomCenterY + lengthdir_y(anchorRadius, anchorAngle+global.screenDir);
	image_angle = dirReal + (global.screenDir-0);
}