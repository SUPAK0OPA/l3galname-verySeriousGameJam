// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function move_y(_spdY, _returnOnGround=false, _semiPass=false){
	var _ySpeed = _spdY;
	var subpixel = 0.5;
	var _yCheck = 0;
	var floorPlatExists = false;
	
	if (instance_exists(obj_collision) && _spdY < 0 && place_meeting(x, y+_spdY, obj_collision)) {
		//// Jump into sloped ceilings
		var _slopeSlide = false;
		
		if (_returnOnGround && self.moveDir == 0) {
			// Slide Up-Left
			if !place_meeting(x - abs(_spdY) - 1, y + _spdY, obj_collision) {
				while place_meeting(x, y + _spdY, obj_collision) { x -= 1; }
				_slopeSlide = true;
			}
			
			// Slide Up-Right
			if !place_meeting(x + abs(_spdY) + 1, y + _spdY, obj_collision) {
				while place_meeting(x, y + _spdY, obj_collision) { x += 1; }
				_slopeSlide = true;
			}
		}
		
		if !_slopeSlide {
			var pixelCheck = subpixel * sign(_spdY);
		
			while !place_meeting(x, y+pixelCheck, obj_collision) {
				y += pixelCheck;
			}
		
			// Bonk
			if (_returnOnGround && _ySpeed < 0) { self.inAir = 0; }
		
			_ySpeed = 0;
		}
	}
	
	#region Floor Y Collision
	
	// Check for solid and semisolid platforms underneath
	var _clampSpdY = max(0, _spdY);
	var _list = ds_list_create(); // Create a DS list to store all objects ran into
	var _array = array_create(0);
	if instance_exists(obj_collision) { array_push(_array, obj_collision); }
	if instance_exists(obj_semisolid) { array_push(_array, obj_semisolid); }
	
	// Do the check and add onjects to list
	var _listSize = instance_place_list(x, y+1 + _clampSpdY + self.termVel, _array, _list, false);
	
	//// Check for semisolid below (fix for high value/resolutions)
	_yCheck = y+1 + _clampSpdY;
	floorPlatExists = instance_exists(self.myFloorPlat);
	if floorPlatExists { _yCheck += max(0, self.myFloorPlat.speedY); }
	var _semiSolid = check_semiSolid_platform(x, _yCheck);
	
	// Loop through collisions, return if it's top is below
	for(var i=0; i<_listSize; i++) {
		var _listInst = _list[| i];
		
		// Avoid magnetism
		if (_listInst != self.forgetSemiSolid
			&& (_listInst.speedY <= _spdY || floorPlatExists) 
			&& (_listInst.speedY > 0 || place_meeting(x, y+1 + _clampSpdY, _listInst)) )
			|| (_listInst == _semiSolid) { //// High speed/res fix
				
			if (_listInst.object_index == obj_collision || 
				object_is_ancestor(_listInst.object_index, obj_collision) || 
				floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.speedY)) {
			
				// Return highest colliison object
				if (!floorPlatExists || 
					_listInst.bbox_top + _listInst.speedY <= self.myFloorPlat.bbox_top + self.myFloorPlat.speedY ||
					_listInst.bbox_top + _listInst.speedY <= bbox_bottom) {
					
					self.myFloorPlat = _listInst;
					floorPlatExists = instance_exists(self.myFloorPlat);
				}
			
			}
		}
	}
	
	ds_list_destroy(_list);
	
	// Make sure we don't miss semisolid's while going down slopes
	if instance_exists(self.downSlopeSemiSolid) { self.myFloorPlat = self.downSlopeSemiSolid; }
	
	// Check floor platform is actually below object
	if (floorPlatExists && !place_meeting(x, y + self.termVel, self.myFloorPlat)) {
		self.myFloorPlat = noone;
		floorPlatExists = false;
	}
	
	// Land on ground platform if available
	if floorPlatExists {
		// Scoot up precisely
		subpixel = 0.5;
		while (!place_meeting(x, y + subpixel, self.myFloorPlat) && !place_meeting(x, y, obj_collision)) { y += subpixel; }
		//Make sure object isn't below the top of semisolid
		if (self.myFloorPlat.object_index == obj_semisolid || object_is_ancestor(self.myFloorPlat.object_index, obj_semisolid)) {
			while place_meeting(x, y, self.myFloorPlat) { y -= subpixel; }
		}
		
		y = floor(y);
		
		// Collide with ground
		_ySpeed = 0;	
		if _returnOnGround {
			set_onGround(true, self.object_index);
			//self.onGround = true;
			//if (object_get_name(object_index) == "obj_player") { self.hangTime = self.hangFrames; }
		}
	}
	
	#endregion
	
	#region Fall through a semisolid
	
	if _semiPass {
		// Make sure there's a floor platform that's a semisolid
		if (floorPlatExists 
		&& (self.myFloorPlat.object_index == obj_semisolid || object_is_ancestor(self.myFloorPlat.object_index, obj_semisolid)) ) {
			// Check if we CAN go below semisolid
			_yCheck = max(1, self.myFloorPlat.speedY+1);
			if !place_meeting(x, y + _yCheck, obj_collision) {
				
				// Move below platform
				y++;
				
				// Inherit any downward platform speed
				_ySpeed = _yCheck - 1;
			
				// Forget platform to not get caught again
				self.forgetSemiSolid = self.myFloorPlat;
			
				set_onGround(false, self.object_index);
				floorPlatExists = false;
			}
		}
	}
	
	#endregion
	
	#region Final moving platform collision + movement
	
	// Snap to moving platforms if moving vertically
	if (floorPlatExists && ( self.myFloorPlat.speedY != 0
		|| self.myFloorPlat.object_index == obj_collisionMove
		|| object_is_ancestor(self.myFloorPlat.object_index, obj_collisionMove)
		|| self.myFloorPlat.object_index == obj_semisolidMove
		|| object_is_ancestor(self.myFloorPlat.object_index, obj_semisolidMove) )) {
			
		// Snap to top of floor platform
		if (!place_meeting(x, self.myFloorPlat.bbox_top, obj_collision) && self.myFloorPlat.bbox_top >= bbox_bottom-self.termVel) {
			y = self.myFloorPlat.bbox_top;
		}
		
		// Made redundant by region below
				//// Going up into a wall while on a semisolid platform
				//if (self.myFloorPlat.speedY < 0 && place_meeting(x, y + self.myFloorPlat.speedY, obj_collision)) {
				//	// Get pushed down through semisolid floor platform
				//	if (self.myFloorPlat.object_index == obj_semisolid || object_is_ancestor(self.myFloorPlat.object_index, obj_semisolid)) {
				//		// Get pushed down
				//		var subpixel = 0.25;
				//		while place_meeting(x, y + self.myFloorPlat.speedY, obj_collision) { y += subpixel; }
				//		// If pushed into solid wall while heading down, push back out
				//		while place_meeting(x, y, obj_collision) { y -= subpixel; }
				//		y = round(y);
				//	}
			
				//	// Cancel myFloorPlat variable
				//	set_onGround(false);
				//}
	}
	
	#endregion
	
	#region Get pushed down through semisolid by moving solid platform
	
	if (floorPlatExists && (self.myFloorPlat.object_index == obj_semisolid || object_is_ancestor(self.myFloorPlat.object_index, obj_semisolid))
		&& place_meeting(x, y, obj_collision)) {
		// If stuck in a wall, try to move below semisolid
		// If still stuck, then object is "crushed"
		
		/// Don't check too far, don't want to warp below walls
		var _maxPushDist = 10;
		var _pushedDist = 0;
		var _startY = y;
		while (place_meeting(x, y, obj_collision) && _pushedDist <= _maxPushDist) {
			y++;
			_pushedDist++;
		}
		
		set_onGround(false, self.object_index);
		floorPlatExists = false;
		
		// If still in wall, then crushed, get brought back to start y to avoid weirdness
		if (_pushedDist > _maxPushDist) { y = _startY; }
	}
	
	#endregion
	
	// Save vertical movement speed
	if floorPlatExists {
		if (self.myFloorPlat.speedY >= 0) {
			if (self.movePlatBuffer[1] > 0) {
				self.movePlatBuffer[1]--;
			} else {
				if (self.speedY >= 0) { self.movePlatSpdY = self.myFloorPlat.speedY; }
				self.movePlatBuffer[1] = 0;
			}
		} else {
			self.movePlatSpdY = self.myFloorPlat.speedY;
			self.movePlatBuffer[1] = 5 / global.timeSpeed;
		}
	}
	
	return _ySpeed;
}