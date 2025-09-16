/* SPDX-License-Identifier: BSD-2-Clause */
module patterngen;

import std::math::random;

fn void bg(Random rng, Canvas *canvas)
{
    Color bg_c = { (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF), 0xFF };

    canvas.clear(bg_c);
}

fn void gradient(Random rng, Canvas *canvas)
{
    Color c1 = { (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF), 0xFF };
    Color c2 = { 0xFF - c1.r, 0xFF - c1.g, 0xFF - c1.b, 0xFF };

    for (uint y = 0; y < canvas.height; y++) {
        float t = (float) y / ((float) canvas.height - 1);
        Color res = lerp_color(c1, c2, t);
        for (uint x = 0; x < canvas.width; x++) {
            canvas.draw_pixel(x, y, res);
        }
    }
}


fn Color lerp_color(Color c1, Color c2, float time) @local
{
    var apply = fn char(char a, char b, float t) => 
        (char) (a + ((float) b - a) * t + 0.5f);

    return (Color) {
        apply(c1.r, c2.r, time),
        apply(c1.g, c2.g, time),
        apply(c1.b, c2.b, time),
        apply(c1.a, c2.a, time),
    };
}
