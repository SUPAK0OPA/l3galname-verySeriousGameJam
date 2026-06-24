/// @desc Movement
x += speedX;
y += speedY;

if (abs(speedX) > 0.5) { speedX -= xFriction * sign(speedX); }

if (speedY > 0.1) { speedY -= yFriction; }
else if (speedY < -0.5) { speedY += yFriction; }

thing -= thing2;
if (thing <= 0) { instance_destroy(); }