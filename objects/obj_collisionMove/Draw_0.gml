draw_self();
draw_text(x, y-20, dir);
draw_text(x, y-36, ceil(dir % 4));

var dirRemainder = dir - floor(dir);
draw_text(x, y-48, dirRemainder);