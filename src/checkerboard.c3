/* SPDX-License-Identifier: BSD-2-Clause */
module patterngen;

import std::math::random;

fn void checkerboard(Generator *self, Canvas *canvas)
{
    Color c1 = { (char) random::next(&self.rng, 0xFF),
        (char) random::next(&self.rng, 0xFF),
        (char) random::next(&self.rng, 0xFF), 0xFF };
    Color c2 = { (char) random::next(&self.rng, 0xFF),
        (char) random::next(&self.rng, 0xFF),
        (char) random::next(&self.rng, 0xFF), 0xFF };

    ushort h = (ushort) random::next_in_range(&self.rng, canvas.height / 16, canvas.height / 4);
    ushort w = (ushort) random::next_in_range(&self.rng, canvas.width / 16, canvas.width / 4); 

    for (ushort y = 0; y < canvas.height; y += h) {
        for (ushort x = 0; x < canvas.width; x += w) {
            bool diff = (bool) random::next_in_range(&self.rng, 0, 1);
            canvas.draw_rect(x, y, w, h, diff ? c1 : c2);
        }
    }
}
