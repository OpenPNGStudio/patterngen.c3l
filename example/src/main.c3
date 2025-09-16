/* SPDX-License-Identifier: BSD-2-Clause */
module example;
import std::io;

import patterngen::drw;
import raylib5::rl;

fn int main(String[] args)
{
    Generator gen = patterngen::init("Sharks are very cool sea creatures!");

    int screenWidth = 800;
    int screenHeight = 450;

    Canvas c = gen.gen(mem, screenWidth, screenHeight);

    rl::initWindow(screenWidth, screenHeight, "patterngen");
    rl::setTargetFPS(60);

    Image newImg = {
        .data = c.image.ptr,
        .width = c.width,
        .height = c.height,
        .mipmaps = 1,
        .format = PixelFormat.UNCOMPRESSED_R8G8B8A8,
    };

    Texture2D texture = rl::loadTextureFromImage(newImg);

    while (!rl::windowShouldClose()) {
        rl::beginDrawing();
        rl::clearBackground(rl::RAYWHITE);
        rl::drawTexture(texture, 0, 0, rl::WHITE);
        rl::endDrawing();
    }
    rl::closeWindow();
    return 0;
}
