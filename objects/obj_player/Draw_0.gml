/// @description Insert description here
if !active { exit; }

switch global.playerState {
	case 0:
		var thing = speedX / sxCap;
		draw_sprite_pos(sprite_index, 0, bbox_left-floor(thing*4)+(squish*2), bbox_top-(squish*4), bbox_right-floor(thing*4)-(squish*2), bbox_top-(squish*4), bbox_right-(squish*2), y, bbox_left+(squish*2), y, c_white);
	break;
	case 2:
		draw_self();
	break;
}

//draw_text(x, y-80, speedX);

//if instance_exists(myFloorPlat) { draw_text(x, y-100, myFloorPlat.speedY); }
//else { draw_text(x, y-100, 0); }
//draw_text(x, y-120, movePlatSpdY);
//draw_text(x, y-80, place_meeting(x, y, obj_collision));
