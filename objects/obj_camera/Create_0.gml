/// @description Insert description here
cameraW = 256;
cameraH = 224;
cameraTarget = global.cameraTarget;
cameraPos = [0, 0];
cameraSpeed = 0.2; // Work in percentage
cameraScale = 1;

// Camera Shake
rShake = 0;
tick = 0;
shake = [0, 0];
shakeDecay = 0.25

global.camera = camera_create_view(0, 0, cameraW, cameraH);

view_enabled = true;
view_visible[0] = true;
view_set_camera(0, global.camera);

if surface_exists(global.surf2) {
	view_surface_id[0] = global.surf2;
}

ogValues = {
	_shakeDecay : shakeDecay
};