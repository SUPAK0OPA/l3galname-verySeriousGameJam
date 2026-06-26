/// @description Varaible Init
sxCap = 2;
speedX = 0;
xVel = 0.4;
xFriction = 0.25;
moveDir = 0;

jumpVel = -4;
speedY = 0;
grav = 0.6;
termVel = 6;
jumpBuffer = true;

buffer = 5;
inAir = 0;
jumpCap = 11;
onGround = true;

// States
crouching = false;
active = false;

// Coyote Time
hangFrames = 2;
hangTime = 0;
jumpTimer = 0;
jumpFrames = 5;

// Moving Platforms
myFloorPlat = noone;
earlyMovePlatSpdX = false;
movePlatSpdX = 0;
preMovePlatSpdX = 0;
movePlatSpdY = 0;
movePlatBuffer = [0, 0];
movePlatSpdPrevTwo = 0;
downSlopeSemiSolid = noone;
forgetSemiSolid = noone;

squish = 0;
spinnerID = -1;
image_alpha = 1;

// Store original values
ogValues = {
	_sxCap : sxCap,
	_xVel : xVel,
	_xFriction : xFriction,
	_jumpVel : jumpVel,
	_grav : grav,
	_termVel : termVel,
	_buffer : buffer,
	_jumpCap : jumpCap,
	_hangFrames : hangFrames,
	_jumpFrames : jumpFrames
};

event_user(0); // Update values to be accurate to timespeed

// Player Functions
//function set_onGround(_val = true) {
//	//if _val {
//	//	onGround = true;
//	//	hangTime = hangFrames / global.timeSpeed;
//	//} else {
//	//	onGround = false;
//	//	hangTime = 0;
//	//}
//	if _val {
//		onGround = true;
//		hangTime = hangFrames;
//	} else {
//		onGround = false;
//		myFloorPlat = noone;
//		hangTime = 0;
//	}
//}