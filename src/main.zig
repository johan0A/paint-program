const std = @import("std");
const math = std.math;
const rl = @import("raylib");
const utils = @import("utils.zig");
const Canvas = @import("canvas_elements.zig").Canvas;

const ui_elements = @import("ui_elements.zig");

const Vector2D = utils.Vector2D;

pub var global_ctx: struct {
    camera: rl.Camera2D,
} = .{
    .camera = rl.Camera2D{
        .offset = rl.Vector2{ .x = 0, .y = 0 },
        .target = rl.Vector2{ .x = 0, .y = 0 },
        .rotation = 0,
        .zoom = 2,
    },
};

pub fn main() anyerror!void {
    rl.setConfigFlags(.{
        .msaa_4x_hint = true,
        .window_resizable = true,
        .window_highdpi = false,
    });

    rl.setTraceLogLevel(.log_none);

    rl.initWindow(800, 450, "raylib-zig [core] example - basic window");
    defer rl.closeWindow();

    rl.setTargetFPS(144);

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var line = std.ArrayList(Vector2D(i32)).init(allocator);
    defer line.deinit();

    var button_state: struct {
        pos: Vector2D(i32),
        grabbed: bool,
    } = .{
        .pos = Vector2D(i32).init(100, 100),
        .grabbed = false,
    };

    var canvas = Canvas.initBlank(800, 450);
    canvas.drawCircle(100, 100, rl.Color.blue, 100);

    while (!rl.windowShouldClose()) {
        {
            if (rl.isMouseButtonDown(.mouse_button_middle)) {
                global_ctx.camera.offset = global_ctx.camera.offset.add(rl.getMouseDelta());
            }
            global_ctx.camera.zoom += rl.getMouseWheelMove() * 0.1 * global_ctx.camera.zoom;
            global_ctx.camera.zoom = if (global_ctx.camera.zoom >= 0) global_ctx.camera.zoom else 0;
        }

        var canvas_texture = canvas.toTexture();
        defer canvas_texture.unload();

        rl.setTextureFilter(canvas_texture, .texture_filter_anisotropic_16x);

        rl.beginDrawing();
        defer rl.endDrawing();
        rl.clearBackground(rl.Color.white);
        {
            rl.drawFPS(0, 0);
        }
        global_ctx.camera.begin();
        defer global_ctx.camera.end();
        {
            canvas_texture.draw(0, 0, rl.Color.white);

            if (ui_elements.textButton("HELLO!", button_state.pos.x(), button_state.pos.y(), .{}, .mouse_button_left).on_press) {
                button_state.grabbed = true;
            }
            if (!rl.isMouseButtonDown(.mouse_button_left)) {
                button_state.grabbed = false;
            }
            if (button_state.grabbed) {
                const camera = global_ctx.camera;
                button_state.pos.values[0] += @intFromFloat(rl.getMouseDelta().x / camera.zoom);
                button_state.pos.values[1] += @intFromFloat(rl.getMouseDelta().y / camera.zoom);
            }
        }
    }
}

test {
    std.testing.refAllDeclsRecursive(@This());
}
