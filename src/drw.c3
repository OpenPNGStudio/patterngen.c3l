/* SPDX-License-Identifier: BSD-2-Clause */
module patterngen::drw;

import std::math;
import std::core::mem::allocator;

struct Color {
    char r, g, b, a;
}

struct Vec2 {
    uint x, y;
}

struct Canvas {
    char[] image;
    Color *canvas;
    uint width, height;
}

fn void Canvas.init(&self, uint width, uint height, Allocator alloc)
{
    self.image = allocator::new_array(alloc, char, (ulong) height * width *
        Color.sizeof);
    self.canvas = (Color*) self.image.ptr;
    self.width = width;
    self.height = height;
}

fn void Canvas.draw_pixel(&self, uint x, uint y, Color c) @inline
{
    if (x >= self.width || y >= self.height) return;

    self.canvas[y * self.width + x] = c;
}

fn void Canvas.draw_rect(&self, uint x, uint y, uint width, uint height,
    Color c)
{
    if (x >= self.width || y >= self.height) return;

    if (x + width >= self.width) {
        width = self.width - x;
    }

    if (y + height >= self.height) {
        height = self.height - y;
    }

    for (uint w = 0; w < width; w++) {
        for (uint h = 0; h < height; h++) {
            self.draw_pixel(x + w, h + y, c);
        }
    }
}

fn void Canvas.draw_line(&self, uint x1, uint y1, uint x2, uint y2, Color c)
{
    int dx = math::abs((int) x2 - (int) x1);
    int dy = -math::abs((int) y2 - (int) y1);
    int sx = (x1 < x2) ? 1 : -1;
    int sy = (y1 < y2) ? 1 : -1;
    int err = dx + dy;

    while (true) {
        self.draw_pixel(x1, y1, c);
        if (x1 == x2 && y1 == y2) break;
        int e2 = 2 * err;
        if (e2 >= dy) { err += dy; x1 += sx; }
        if (e2 <= dx) { err += dx; y1 += sy; }
    }
}

fn void Canvas.draw_circle(&self, uint cx, uint cy, uint radius, Color c)
{
    uint r2 = radius * radius;
    for (int dy = (int) -radius; dy <= radius; dy++) {
        int y = cy + dy;
        if (y < 0 || y >= self.height) continue;
        int dx_limit = (int) math::sqrt(r2 - dy * dy);
        for (int dx = -dx_limit; dx <= dx_limit; dx++) {
            int x = cx + dx;
            self.draw_pixel(x, y, c);
        }
    }
}

fn void Canvas.draw_line2(&self, uint x1, uint y1, uint x2, uint y2,
    uint thickness, Color c)
{
    int dx = math::abs((int) x2 - (int) x1);
    int dy = -math::abs((int) y2 - (int) y1);
    int sx = (x1 < x2) ? 1 : -1;
    int sy = (y1 < y2) ? 1 : -1;
    int err = dx + dy;

    while (true) {
        self.draw_circle(x1, y1, thickness / 2, c);
        if (x1 == x2 && y1 == y2) break;
        int e2 = 2 * err;
        if (e2 >= dy) { err += dy; x1 += sx; }
        if (e2 <= dx) { err += dx; y1 += sy; }
    }
}

fn void Canvas.draw_poly(&self, Vec2[] pts, Color c, bool closed = false)
{
    if (pts.len < 2) return;

    for (int i = 0; i + 1 < pts.len; i++) {
        self.draw_line(pts[i].x, pts[i].y, pts[i + 1].x, pts[i + 1].y, c);
    }

    if (closed) {
        Vec2 end = pts[pts.len - 1];
        self.draw_line(end.x, end.y, pts[0].x, pts[0].y, c);
    }
}

fn void Canvas.draw_poly2(&self, Vec2[] pts, Color c, uint thickness,
    bool closed = false)
{
    if (pts.len < 2) return;

    for (int i = 0; i + 1 < pts.len; i++) {
        self.draw_line2(pts[i].x, pts[i].y, pts[i + 1].x, pts[i + 1].y,
            thickness, c);
    }

    if (closed) {
        Vec2 end = pts[pts.len - 1];
        self.draw_line2(end.x, end.y, pts[0].x, pts[0].y, thickness, c);
    }
}
