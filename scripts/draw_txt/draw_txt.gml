// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_txt(_x, _y, str=""){
    var xx = _x;
    var yy = _y;
    var char = "";
    var char2 = "";
    
    var strLen = string_length(str);
    for(var i=0; i<strLen; i++) {
        char = string_char_at(str, i+1);
        //special character check
        if char = "`" {
            char = "";
            char2 = string_char_at(str, i+2);
            switch char2 {
                case "n":
                    xx = _x;
                    yy += 8;
                    i++;
                    continue;
            }
        }
        //draw letter and change variables
        draw_sprite_ext(spr_SMBFont, string_pos(char, soup)-1, xx, yy, 1, 1, 0, c_white, 1);
        xx += 8;
    }
}
