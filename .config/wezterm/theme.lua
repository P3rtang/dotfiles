local wezterm = require 'wezterm'
local modules = {}

modules.apply = function(config)
    config.color_scheme = 'Catppuccin Macchiato'

    config.window_background_opacity = 0.8
    config.win32_system_backdrop = 'Acrylic'

    config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }

    config.font = wezterm.font_with_fallback {
        'Comic Mono',
        'JetBrains Mono',
    }

    config.line_height = 1.20
    config.font_size = 14
    config.cell_width = 1
end

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on(
'format-tab-title',
function(tab, tabs, panes, config, hover, max_width)
    local title = tab_title(tab)
    if tab.is_active then
        return {
            { Background = { Color = '#8aadf4' } },
            { Foreground = { Color = '#000000' } },
            { Text = ' ' .. title .. ' ' },
        }
    end
    return title
end
)

return modules
