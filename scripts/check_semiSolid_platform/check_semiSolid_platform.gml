// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function check_semiSolid_platform(_x, _y) {
	// Create return variable
	var _rtrn = noone;
	
	// Not moving upwards, then check for normal collision
	if (speedY >= 0 && place_meeting(_x, _y, obj_semisolid)) {
		
		// Create a ds list to store all collisions of obj_semisolid
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x, _y, obj_semisolid, _list, false);
		
		// Loop through collisions and only return if it's top is below player
		for (var i=0; i<_listSize; i++) {
			var _listInst = _list[| i]
			if (_listInst != self.forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.speedY)) {
				// Return ID of semisolid platform
				_rtrn = _listInst;
				i = _listSize;
			}
		}
		
		ds_list_destroy(_list);
	}
	
	return _rtrn;
}