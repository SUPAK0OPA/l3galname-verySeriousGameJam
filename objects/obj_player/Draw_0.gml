/// @description Insert description here
draw_self();
draw_text(x, y-80, speedX);

if instance_exists(myFloorPlat) { draw_text(x, y-100, myFloorPlat.speedY); }
else { draw_text(x, y-100, 0); }
draw_text(x, y-120, movePlatSpdY);
