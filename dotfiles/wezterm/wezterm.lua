local wezterm = require 'wezterm'

return {
    font = wezterm.font("PragmataProMonoLiga NF"),
    font_size = 18.0,
    color_scheme = "nord",
    enable_tab_bar = false,
    window_decorations = "RESIZE",
    window_padding = {
        left = 10,
        right = 10,
        bottom = 10,
        top = 10,
    },
}