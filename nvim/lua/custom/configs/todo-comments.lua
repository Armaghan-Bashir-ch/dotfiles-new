return function()
    -- AUTHOR:
    require("todo-comments").setup({
        keywords = {
            TODO = { icon = " ", color = "#0000ff", alt = { "TASKS" } }, -- blue
            AUTHOR = { icon = " ", color = "#ffffff", alt = { "TASKS" } }, -- white
            HACK = { icon = " ", color = "#d6a967" }, -- purple
            WARN = { icon = " ", color = "#ffff00", alt = { "WARNING", "XXX" } }, -- yellow
            PERF = { icon = "󰍛 ", color = "#00CED1", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } }, -- cyan
            NOTE = { icon = " ", color = "#a484e0", alt = { "INFO", "\\_ " } }, -- gray
            TEST = { icon = "󰙨 ", color = "#00ff00", alt = { "TESTING", "PASSED", "FAILED" } }, -- green
            DEBUG = { icon = " ", color = "#1E90FF", alt = { "TRACE", "LOG" } }, -- blue
            IMPORTANT = { icon = " ", color = "#7C3AED", alt = { "CRITICAL", "MUST", "NEEDED", "IMPT" } }, -- purple
            QUESTION = { icon = "󰘥 ", color = "#E53935", alt = { "Q", "ASK", "DOUBT" } }, -- red
            IDEA = { icon = " ", color = "#38bdf8", alt = { "THOUGHT", "SUGGESTION", "BRAINSTORM" } }, -- blue
            TEMP = { icon = " ", color = "#ffff00", alt = { "TEMPORARY", "WIP" } }, -- yellow
            REVIEW = { icon = " ", color = "#20e86a", alt = { "CHECK", "APPROVE" } },
            DEPRECATED = { icon = " ", color = "#ff0000", alt = { "OLD", "REMOVE" } },
            SECURITY = { icon = " ", color = "#589dd6", alt = { "VULN", "SEC" } },
            REF = { icon = " ", color = "#00CED1", alt = { "REFACTOR" } },
            KEYBIND = { icon = " ", color = "#14b8a6", alt = { "SHORTCUT", "HOTKEY", "BIND" } }, -- teal
            ALIASES = { icon = " ", color = "#ff0000", alt = { "SYNONYM", "ALTERNATE", "AKA" } }, -- red
            GESTURES = { icon = " ", color = "#00D3D4", alt = { "GESTURE", "SWIPE", "TOUCH", "PINCH" } }, -- cyan
        },
    })
end
