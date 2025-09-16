/* SPDX-License-Identifier: BSD-2-Clause */
module patterngen;

import std::math::random;
import std::io;

fn void bubbles(Random rng, Canvas *canvas)
{
    Color bg = { (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF), 0xFF };

    canvas.clear(bg);

    usz count = random::next_in_range(rng, 100, 500);

    while (--count) {
        Color c = { (char) random::next(rng, 0xFF),
            (char) random::next(rng, 0xFF),
            (char) random::next(rng, 0xFF), 0xFF };

        uint radius = random::next_in_range(rng, canvas.height / 16,
            canvas.height / 8);

        canvas.draw_circle(
            random::next(rng, canvas.width), random::next(rng, canvas.height),
            radius / 2, c);
    }
}

fn void clouds(Random rng, Canvas *canvas)
{
    Color c1 = { (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF),
        (char) random::next(rng, 0xFF), 0xFF };
    Color c2 = { 0xFF - c1.r, 0xFF - c1.g, 0xFF - c1.b, 0xFF };

    canvas.clear(c1);

    usz count = random::next_in_range(rng, 100, 500);

    while (--count) {

        uint radius = random::next_in_range(rng, canvas.height / 16,
            canvas.height / 8);

        canvas.draw_circle(
            random::next(rng, canvas.width), random::next(rng, canvas.height),
            radius / 2, c2);
    }
}
