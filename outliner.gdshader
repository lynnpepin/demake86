shader_type canvas_item;
//render_mode blend_mix;
// See
// https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_2d_shader.html
// https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/shader_functions.html
// https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html

/*
// identity: fragment () { COLOR = texture(TEXTURE, UV); }
// identity: do nothing; "COLOR" iclundes modulation
*/

// todo: source_color? hint_color? hint_albedo?
//uniform vec4 outline_color : source_color = vec4(35.0/255.0, 23.0/255.0, 18.0/255.0, 1.0);
uniform vec4 outline_color : source_color = vec4(
    // famicube 32
    //0.13725490196078433, 0.09019607843137255, 0.07058823529411765, 
    // famicube 26
    0.30980392156862746, 0.08235294117647059, 0.027450980392156862,
    1.0);

// tldr:
// "fragment" is a method ran per-pixel, screenspace
//   there is also vertex() light() etc (there are FROXELS i have gotta write some eventually)
// COLOR = vec4(...) to set the pixel color


void fragment () {
    // "texture" is a method
    vec4 starting_sprite = COLOR;//texture(TEXTURE, UV);
    
    // 1px width converted to texture space
    vec2 px_unit = 1.0 / vec2(textureSize(TEXTURE, 0));

    
    // Check if any of the neighboring sprites has a color
    // (note to self: I BET I CAN IMPLEMENT RESO AS A SHADER)
    float a = 0.0;
    a += texture(TEXTURE, UV + vec2(px_unit.x, 0)).a;
    a += texture(TEXTURE, UV + vec2(-px_unit.x, 0)).a;
    a += texture(TEXTURE, UV + vec2(0, px_unit.y)).a;
    a += texture(TEXTURE, UV + vec2(0, -px_unit.y)).a;
    a = min(a, 1.0);

    // equivalent to if is_transparent = (a > 0.0)
    //float should_be_outlined = (1.0 if (starting_sprite.a > 0.0) else 0.0);
    float should_be_outlined = step(starting_sprite.a, 0.0);
    
    // Finally, set each sprite
    // mix(A, B, x) == (A if x else B)
    //COLOR = mix(starting_sprite, outline_color, a);
    COLOR = mix(
        starting_sprite,
        mix(starting_sprite, outline_color, a),
        should_be_outlined
    );

}