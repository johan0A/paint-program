const rl = @import("raylib");

const utils = @import("utils.zig");

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
    const mouse_pos = utils.getWorldMousePos();

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
