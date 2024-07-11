const std = @import("std");
const math = std.math;

const rl = @import("raylib");

const main = @import("main.zig");

pub fn Vector2D(T: type) type {
    return struct {
        values: @Vector(2, T),

        pub fn x(self: Vector2D(T)) T {
            return self.values[0];
        }

        pub fn y(self: Vector2D(T)) T {
            return self.values[1];
        }

        pub fn init(_x: T, _y: T) Vector2D(T) {
            return .{
                .values = .{ _x, _y },
            };
        }

        pub fn selfMax(self: *Vector2D(T), other: Vector2D(T)) void {
            // TODO: use simd
            self.values[0] = if (self.values[0] > other.values[0]) self.values[0] else other.values[0];
            self.values[1] = if (self.values[1] > other.values[1]) self.values[1] else other.values[1];
        }

        pub fn max(self: *Vector2D(T), other: Vector2D(T)) Vector2D(T) {
            // TODO: use simd
            return Vector2D(T).init(
                if (self.values[0] > other.values[0]) self.values[0] else other.values[0],
                if (self.values[1] > other.values[1]) self.values[1] else other.values[1],
            );
        }

        pub fn lenght(self: Vector2D(T)) T {
            return math.sqrt(self.values[0] * self.values[0] + self.values[1] * self.values[1]);
        }

        pub fn selfSetLength(self: *Vector2D(T), new_length: T) void {
            // TODO: use simd
            const current_lenght = self.lenght();
            self.values[0] *= new_length / current_lenght;
            self.values[1] *= new_length / current_lenght;
        }

        pub fn setLength(self: *Vector2D(T), new_length: T) Vector2D(T) {
            // TODO: use simd
            return Vector2D(T).init(
                self.values[0] * new_length / self.lenght(),
                self.values[1] * new_length / self.lenght(),
            );
        }

        pub fn selfScale(self: *Vector2D(T), scale_factor: T) void {
            // TODO: use simd
            self.values[0] *= scale_factor;
            self.values[1] *= scale_factor;
        }

        pub fn scale(self: Vector2D(T), scale_factor: T) Vector2D(T) {
            // TODO: use simd
            return Vector2D(T).init(
                self.values[0] * scale_factor,
                self.values[1] * scale_factor,
            );
        }

        pub fn dot(self: Vector2D(T), other: Vector2D(T)) T {
            // TODO: use simd
            return self.values[0] * other.values[0] + self.values[1] * other.values[1];
        }
    };
}

pub fn screenSpaceToWorldSpace(
    posX: i32,
    posY: i32,
) Vector2D(i32) {
    const camera = main.global_ctx.camera;
    // return .{
    //     .x = @intFromFloat(@as(f32, @floatFromInt(posX)) / camera.zoom - camera.offset.x / camera.zoom),
    //     .y = @intFromFloat(@as(f32, @floatFromInt(posY)) / camera.zoom - camera.offset.y / camera.zoom),
    // };
    return Vector2D(i32).init(
        @intFromFloat(@as(f32, @floatFromInt(posX)) / camera.zoom - camera.offset.x / camera.zoom),
        @intFromFloat(@as(f32, @floatFromInt(posY)) / camera.zoom - camera.offset.y / camera.zoom),
    );
}

pub fn getWorldMousePos() Vector2D(i32) {
    return screenSpaceToWorldSpace(rl.getMouseX(), rl.getMouseY());
}
