const std = @import("std");
const rl = @import("raylib");
const utils = @import("utils.zig");
const String = @import("string.zig");

const ClickableZoneState = struct {
    mouse_hover: bool,
    on_press: bool,
    on_release: bool,
    pressed: bool,
};

pub fn clickableRectangleZone(
    posX: i32,
    posY: i32,
    width: i32,
    height: i32,
    mouse_button: rl.MouseButton,
) ClickableZoneState {
    const mouse_pos = utils.getMousePos();

    const is_mouse_over =
        mouse_pos.x() >= posX and mouse_pos.y() >= posY and
        mouse_pos.x() <= posX + width and mouse_pos.y() <= posY + height;

    return .{
        .mouse_hover = is_mouse_over,
        .on_press = is_mouse_over and rl.isMouseButtonPressed(mouse_button),
        .on_release = is_mouse_over and rl.isMouseButtonReleased(mouse_button),
        .pressed = is_mouse_over and rl.isMouseButtonDown(mouse_button),
    };
}

pub fn textButton(
    text: [*:0]const u8,
    posX: i32,
    posY: i32,
    text_props: struct {
        fontSize: i32 = 50,
        color: rl.Color = rl.Color.white,
    },
    mouse_button: rl.MouseButton,
) ClickableZoneState {
    const width = rl.measureText(text, text_props.fontSize) + 10;
    const height = text_props.fontSize;

    const cliclable_rect = clickableRectangleZone(
        posX,
        posY,
        width,
        height,
        mouse_button,
    );

    if (cliclable_rect.mouse_hover) {
        const border_width = 5;
        rl.drawRectangle(posX + border_width, posY + border_width, width + border_width, height + border_width, rl.Color.red);
    }

    rl.drawRectangle(posX - 5, posY, width, height, rl.Color.black);
    rl.drawText(text, posX, posY, text_props.fontSize, text_props.color);

    return cliclable_rect;
}

pub const Tooltip = struct {
    const Self = @This();

    const tooltip_delay: f32 = 0.5;

    text: String,

    timer: f32,
    active: bool,

    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !Self {
        return .{
            .allocator = allocator,
            .text = try String.init(allocator),
            .timer = 0,
            .active = false,
        };
    }

    pub fn draw(self: *@This()) void {
        if (self.timer > tooltip_delay) {
            const width = rl.measureText(self.text.getNullTerminated(), 10);
            const height = 10;

            const pos_x = rl.getMouseX() + 10;
            const pos_y = rl.getMouseY() + 10;

            rl.drawRectangle(pos_x, pos_y, width, height, rl.Color.black);
            rl.drawText(self.text.getNullTerminated(), pos_x, pos_y, 10, rl.Color.white);
        }
    }

    pub fn tick(self: *@This()) void {
        self.timer += rl.getFrameTime();
        if (!self.active) {
            self.timer = 0;
        }
        self.active = false;
    }

    pub fn changeText(self: *@This(), new_text: []const u8) !void {
        const current_text = self.text.get();
        if (std.mem.eql(u8, current_text, new_text)) return;
        try self.text.replace(new_text);
        self.timer = 0;
    }
};

pub fn imagButton(posX: i32, posY: i32, width: i32, height: i32, mouse_button: rl.MouseButton, texture: rl.Texture2D) ClickableZoneState {
    const cliclable_rect = clickableRectangleZone(
        posX,
        posY,
        width,
        height,
        mouse_button,
    );

    if (cliclable_rect.mouse_hover) {
        const border_width = 5;
        rl.drawRectangle(posX + border_width, posY + border_width, width + border_width, height + border_width, rl.Color.red);
    }

    rl.drawRectangle(posX, posY, width, height, rl.Color.black);
    texture.drawEx(
        rl.Vector2.init(@floatFromInt(posX), @floatFromInt(posY)),
        0,
        @as(f32, @floatFromInt(width)) / @as(f32, @floatFromInt(texture.width)),
        rl.Color.white,
    );

    return cliclable_rect;
}
