/// @description Camera work here
if (global.cameraTarget == undefined || !instance_exists(global.cameraTarget)) { global.cameraTarget = obj_camera; }
cameraTarget = global.cameraTarget;

// Screen Shake
tick += global.shakeTick * global.timeSpeed;
shake[0] = global.shake[0]*(rShake * sin(tick))*rand_negPos();
shake[1] = global.shake[1]*(rShake * cos(tick))*rand_negPos();
rShake -= shakeDecay * global.timeSpeed;
if (rShake < 0) { rShake = 0; }
if (tick > 65535) { tick = 0; } // 2^16 or 16 bits worth

var _camWReal = cameraW / cameraScale;
var _camHReal = cameraH / cameraScale;
var targetX = cameraTarget.x - (_camWReal/2);
var targetY = cameraTarget.y - (_camHReal/2);

// Clamp to the room
if (global.cameraClamp[0][0] && targetX < 0) {
	targetX = 0;
} else if (global.cameraClamp[0][1] && targetX + _camWReal > room_width) {
	targetX = room_width - _camWReal;
}

if (global.cameraClamp[1][0] && targetY< 0) {
	targetY = 0;
} else if (global.cameraClamp[1][1] && targetY + _camHReal > room_height) {
	targetY = room_height - _camHReal;
}


cameraPos = [lerp(cameraPos[0], targetX, cameraSpeed) + shake[0], lerp(cameraPos[1], targetY, cameraSpeed) + shake[1]];

camera_set_view_size(global.camera, _camWReal, _camHReal);
camera_set_view_pos(global.camera, cameraPos[0], cameraPos[1]);