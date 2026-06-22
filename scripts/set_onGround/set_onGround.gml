// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function set_onGround(_val = true, _object = noone) {
	//if _val {
	//	onGround = true;
	//	hangTime = hangFrames / global.timeSpeed;
	//} else {
	//	onGround = false;
	//	hangTime = 0;
	//}
	if _val {
		onGround = true;
		if (object_get_name(_object) == "obj_player") { hangTime = hangFrames; }
	} else {
		onGround = false;
		myFloorPlat = noone;
		if (object_get_name(_object) == "obj_player") { hangTime = 0; }
	}
}