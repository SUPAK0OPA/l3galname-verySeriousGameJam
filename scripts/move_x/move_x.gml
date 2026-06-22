// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function move_x(_spdX, _spdY=0, _sxCapReal=0){
	if (instance_exists(obj_collision) && place_meeting(x + _spdX, y, obj_collision)) {
		var subpixel = 0.5;
		
		// Check for slope first
		if !place_meeting(x + _spdX, y - abs(_spdX) - 1, obj_collision) {
			while place_meeting(x + _spdX, y, obj_collision) { y -= subpixel; }
			return _spdX;
		} else {
			//// Next check for ceiling slope, else, regular collision if no slope
			
			// Ceiling slope
			if !place_meeting(x + _spdX, y + abs(_spdX) + 1, obj_collision) {
				while place_meeting(x + _spdX, y, obj_collision) { y += subpixel; }
				return _spdX;
			} else {
				// Scoot up precisely
				var pixelCheck = subpixel * sign(_spdX);
				while !place_meeting(x + pixelCheck, y, obj_collision) { x += pixelCheck; }
			
				// Set spdX to 0 to collide
				return 0;
			}
		}
	} else {
		
		// Go Down Slopes
		self.downSlopeSemiSolid = noone;
		if (_spdY >= 0 && !place_meeting(x + _spdX, y+1, obj_collision) && place_meeting(x + _spdX, y + abs(_spdX) + 1, obj_collision)) {
			// Check for semisolid in the way
			self.downSlopeSemiSolid = check_semiSolid_platform(x + _spdX, y + abs(_spdX)+1);
			//Precisely move down slope if no semisolid in the way
			var subpixel = 0.5;
			while !place_meeting(x + _spdX, y + subpixel, obj_collision) { y += subpixel; }
		}

	}
	
	#region movePlatX and Collision
	
	// Get movePlat speedX
	self.movePlatSpdX = 0;
	if instance_exists(self.myFloorPlat) {
		self.movePlatSpdX = self.myFloorPlat.speedX;
		self.preMovePlatSpdX = self.movePlatSpdX;
	}
	
	// Move with platform
	if !self.earlyMovePlatSpdX {
		if place_meeting(x + self.movePlatSpdX, y, obj_collision) {
			var subpixel = 0.5;
			var pixelCheck = subpixel * sign(self.movePlatSpdX);
			while !place_meeting(x + pixelCheck, y, obj_collision) { x += pixelCheck; }
		
			// Set movePlat speedX to 0 to finish collision
			self.movePlatSpdX = 0;
		}
	}
	
	#endregion
	
	return _spdX;
	//return _spdX + (self.preMovePlatSpdX*(!self.earlyMovePlatSpdX));
	//if ((self.preMovePlatSpdX*(!self.earlyMovePlatSpdX)) != 0) {
	//	return (self.moveDir * _sxCapReal) + self.preMovePlatSpdX;
	//} else {
	//	return _spdX;
	//}
}