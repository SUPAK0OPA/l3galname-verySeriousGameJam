/// @description Collisions and Physics
if !active { exit; }

switch global.playerState {
	case 1:
		if (inAir < 1) {
			x = lerp(x, spinnerID.x, 0.05);
			y = lerp(y, spinnerID.y, 0.05);
			image_angle -= speedX;
			speedX += xVel*2;
			obj_handler.playerPos = [obj_player.x - obj_camera.cameraPos[0], obj_player.y - obj_camera.cameraPos[1]]; // Relative Position to GUI
			inAir += (1/90) * global.timeSpeed;
			if (inAir >= 1) {
				inAir = 1;
				image_alpha = 2;
				instance_create_layer(0, 0, "Particles", obj_roomTransFade);
			}
		} else if (image_alpha > 0) {
			image_angle += sxCap * 10;
			image_alpha -= (1/40) * global.timeSpeed;
			image_xscale += 1/20 * global.timeSpeed;
			image_yscale += 1/20 * global.timeSpeed;
		}
		exit;
	case 2:
		if (inAir < 1) {
			x = lerp(x, spinnerID.x, 0.05);
			y = lerp(y, spinnerID.y - (sprite_height/2), 0.05);
			image_angle -= speedX;
			speedX += xVel*4;
			inAir += (1/30) * global.timeSpeed;
			if (inAir >= 1) {
				speedX = irandom_range(floor(sxCap/2), ceil(sxCap*2)) * rand_negPos();
				speedY = irandom_range(floor((jumpVel*2)*1.5), jumpVel);
				inAir = 1;
			}
		} else if (image_alpha > 0) {
			x += speedX;
			
			speedY += grav * global.timeSpeed;
			if (speedY > termVel) { speedY = termVel; }
			y += speedY;
			image_angle += (speedX / ceil(sxCap*1.5)) * 10;
			image_alpha -= (1/70) * global.timeSpeed;
		}
		exit;
}

#region Get out of solids that positioned into us in begin step

	var _rightWall = noone;
	var _leftWall = noone;
	var _bottomWall = noone;
	var _topWall = noone;
	
	var _list = ds_list_create();
	var _listSize = instance_place_list(x, y, obj_collisionMove, _list, false);

	// Loop through all colliding move platforms
	for (var i=0; i<_listSize; i++) {
		var _listInst = _list[| i];
		
		
		// Get closest wall in each direction
		//// Right walls
		if (_listInst.bbox_left - _listInst.speedX >= bbox_right-1) {
			if (!_rightWall || _listInst.bbox_left < _rightWall.bbox_left) { _rightWall = _listInst; }
		}
		//// Left walls
		if (_listInst.bbox_right - _listInst.speedX <= bbox_left+1) {
			if (!_leftWall || _listInst.bbox_right > _leftWall.bbox_right) { _leftWall = _listInst; }
		}
		//// Bottom walls
		if (_listInst.bbox_top - _listInst.speedY >= bbox_bottom-1) {
			if (!_bottomWall || _listInst.bbox_top < _bottomWall.bbox_top) { _bottomWall =  _listInst; }
		}
		//// Top walls
		if (_listInst.bbox_bottom - _listInst.speedY <= bbox_top+1) {
			if (!_topWall || _listInst.bbox_bottom > _topWall.bbox_bottom) { _topWall = _listInst; }
		}
	}

	ds_list_destroy(_list);

	// Get out of walls
	//// Right wall
	if instance_exists(_rightWall) {
		var _rightDist = bbox_right - x;
		x = _rightWall.bbox_left - _rightDist;
	} else
	//// Left wall
	if instance_exists(_leftWall) {
		x = _leftWall.bbox_right + (x - bbox_left);
	} else
	//// Bottom wall
	if instance_exists(_bottomWall) {
		y = _bottomWall.bbox_top - (bbox_bottom - y);
	} else
	//// Top Wall
	if instance_exists(_topWall) {
		var _targetY = _topWall.bbox_bottom + (y - bbox_top);
		// Check if there isn't wall in the way
		if !place_meeting(x, _targetY, obj_collision) {
			y = _targetY;
		}
	}

#endregion

movePlatSpdPrevTwo = preMovePlatSpdX*(!earlyMovePlatSpdX); // testing this

// Don't get left behind by moving platforms!
earlyMovePlatSpdX = false;
//if (instance_exists(myFloorPlat) && myFloorPlat.speedX != 0 && !place_meeting(x, y+termVel+1, myFloorPlat)) {
if (instance_exists(myFloorPlat) && myFloorPlat.speedX != 0 && place_meeting(x, y+termVel+1, myFloorPlat)) {
	// Go ahead and move back onto platform if no wall in the way
	if !place_meeting(x + myFloorPlat.speedX, y, obj_collision) {
		x += myFloorPlat.speedX;
		earlyMovePlatSpdX = true;
	}
}

/*
#region Crouching

	// Transition to crounch
	//// Manual = KEYS.DOWN | Auto = collision
	if (onGround && (global.inputs[KEYS.DOWN] > 0 || place_meeting(x, y, obj_collision)) ) {
		crouching = true;
	}
	//// Change collision mask
	if crouching { sprite_index = spr_playerManCrouch; }

	// Transition out of crouching
	//// Manual = !KEYS.DOWN | Auto = !onGround
	if (crouching && (!global.inputs[KEYS.DOWN] || !onGround)) {
		// Check if we CAN uncrouch
		sprite_index = spr_playerMan;
		if !place_meeting(x, y, obj_collision) {
			crouching = false;
		} else {
			sprite_index = spr_playerManCrouch;
		}
	}

#endregion
*/

#region X Movement
	moveDir = (global.inputs[KEYS.RIGHT] > 0) - (global.inputs[KEYS.LEFT] > 0);
	//var sxCapReal = sxCap * (1 + (global.inputs[KEYS.SELECT] > 0));
	var sxCapReal = sxCap;
	
	//if (movePlatSpdPrevTwo != preMovePlatSpdX*(!earlyMovePlatSpdX)) { speedX += preMovePlatSpdX; }
	
	speedX = move_x(speedX + (moveDir * xVel), speedY, sxCapReal);

	x += speedX;
	
	var posNeg = sign(speedX);
	if (moveDir == posNeg * -1 || moveDir == 0) {
		speedX -= xFriction * sign(speedX);
	}
	
	var sxCapPlus = 0;
	if (posNeg == sign(preMovePlatSpdX)) { sxCapPlus = abs(preMovePlatSpdX); }
	if (abs(speedX) > sxCapReal + sxCapPlus) {
		if (abs(speedX) - (xVel*2) < sxCapReal + sxCapPlus) {
			speedX = (sxCapReal+sxCapPlus) * posNeg;
		} else {
			speedX -= xVel * posNeg * (1 + (moveDir != 0));
		}
	}
	
	speedX = round(speedX * 100) / 100;
	if (abs(speedX) < 0.15*global.timeSpeed) { speedX = 0; }
	
	//movePlatSpdPrevTwo = preMovePlatSpdX*(!earlyMovePlatSpdX);
	
#endregion

#region Y Movement

	// Gravity
	if hangTime > 0 {
		hangTime--;
	} else {
		speedY += grav * global.timeSpeed;
		set_onGround(false);
	}
	
	//// Reset Jump Variables
	if onGround {
		jumpBuffer = true;
		inAir = 0;
		jumpTimer = jumpFrames;
		squish -= 1/8 * global.timeSpeed;
	} else {
		jumpTimer--;
		if (jumpTimer < 0) { jumpTimer = 0; }
		squish += 1/10 * global.timeSpeed;
	}
	
	squish = clamp(squish, 0, 1); // Squah & stretch (skew)

	// Set Falling Speed
	if (speedY > termVel) { speedY = termVel; }

	// Jump
	if (jumpBuffer && !global.inputs[KEYS.DOWN] && (global.inputs[KEYS.UP] > 0 && global.inputs[KEYS.UP] <= buffer && jumpTimer > 0)) {
		jumpBuffer = false;
	
		//// Start jump timer
		inAir = jumpCap;
		
		//// Apply boost
		
		
		set_onGround(false);
	}

	if !global.inputs[KEYS.UP] {
		inAir = 0;
	} else if (inAir > 0) {
		// Check for boost
		var yBoost = 0;
		if (movePlatSpdY < 0) { yBoost = movePlatSpdY / 2; }
		
		speedY = jumpVel + yBoost;
		inAir--;
	}
	
	// Apply
	speedY = move_y(speedY, true);
	if !place_meeting(x, y+speedY, obj_collision) { y += speedY; }
	
	//// Reset forgetSemiSolid
	if (instance_exists(forgetSemiSolid) && !place_meeting(x, y, forgetSemiSolid)) { forgetSemiSolid = noone; }
	
#endregion

if place_meeting(x, y, obj_evilSpinner) {
	speedX = 0;
	speedY = 0;
	inAir = 0;
	spinnerID = instance_place(x, y, obj_evilSpinner);
	global.playerState = 2;
}

if place_meeting(x, y, obj_winSpinner) {
	speedX = 0;
	speedY = 0;
	inAir = 0;
	spinnerID = instance_place(x, y, obj_winSpinner);
	global.playerState = 1;
}