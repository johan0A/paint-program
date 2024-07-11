const std = @import("std");
const rl = @import("raylib");
const utils = @import("utils.zig");

pub const Canvas = struct {
    const Self = @This();

    rl_image: rl.Image,

    pub fn initBlank(width: i32, height: i32) Self {
        return .{
            .rl_image = rl.genImageColor(width, height, rl.Color.red),
        };
    }

    // must unload texture after drawing
    pub fn toTexture(self: *Self) rl.Texture2D {
        return self.rl_image.toTexture();
    }

    pub fn initFromFilePath(file_path: [*:0]const u8) Self {
        return .{
            .rl_image = rl.loadImage(file_path),
        };
    }

    // pub fn loadImagePrompt(self: *Self) void {
    //     const file_path = rl.
    // }

    pub fn drawCircle(self: *Self, posX: i32, posY: i32, color: rl.Color, radius: i32) void {
        self.rl_image.drawCircle(posX, posY, radius, color);
    }

    pub fn deinit(self: *Self) void {
        self.rl_image.unload();
    }
};
