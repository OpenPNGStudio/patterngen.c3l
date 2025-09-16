/* SPDX-License-Identifier: BSD-2-Clause */
module patterngen;

import std::math::random;
import std::core::mem::allocator;

struct Generator {
    Pcg128Random rng;
}

alias PatternFn = fn void(Random, Canvas *);

fn Generator init(String seed)
{
    Generator gen;
    gen.rng.set_seed(seed);

    return gen;
}

fn Canvas Generator.gen(&self, Allocator alloc, uint width, uint height)
{
    Canvas c;
    c.init(width, height, alloc);

    usz i = random::next(&self.rng, patterns.len);
    patterns[i](&self.rng, &c);

    return c;
}

PatternFn[] patterns @local = {
    &bg,
    &gradient,
    &checkerboard,
    &bubbles,
    &clouds,
};
