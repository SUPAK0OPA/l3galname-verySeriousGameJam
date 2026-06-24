/// @desc Variable Init
speedX = ( irandom_range(1, 3) * rand_negPos() ) * global.timeSpeed; // This weird math makes it rand neg or pos
speedY = irandom_range(-3, 2) * global.timeSpeed;
xFriction = 0.05;
yFriction = 0.15;
thing = irandom_range(1, 3);
thing2 = 1/40;

var scale = irandom_range(1, 2);
image_xscale = scale;
image_yscale = scale;

// Store original values
ogValues = {
	_xFriction : xFriction,
	_yFriction : yFriction,
	_thing2 : thing2
};

event_user(0);