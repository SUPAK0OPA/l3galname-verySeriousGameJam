/// @description Insert description here
event_inherited();

dir = 0;
////rotSpd = 360 / 180;
//rotSpd = 360 / 60;
rotSpd = 1/15;
radius = 32;
xPrev = 0;
yPrev = 0;

animCurve = animcurve_get_channel(ac_presets, "easeInLinear");