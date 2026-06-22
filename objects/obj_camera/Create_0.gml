/// @description Insert description here
cameraW = 640*1;
cameraH = 360*1;
cameraTarget = global.cameraTarget;
cameraPos = [0, 0];
cameraSpeed = 0.2; // Work in percentage

global.camera = camera_create_view(0, 0, cameraW, cameraH);

view_enabled = true;
view_visible[0] = true;
view_set_camera(0, global.camera);

if surface_exists(global.surf) {
	view_surface_id[0] = global.surf;
}