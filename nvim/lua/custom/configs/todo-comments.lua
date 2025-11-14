return function()
    require("todo-comments").setup({
        keywords = {
            FIX = { icon = " ", color = "error", alt = { "ERROR", "FIXME", "BUG", "FIXIT", "ISSUE" } },
            TODO = { icon = " ", color = "info", alt = { "TASKS" } },
            AUTHOR = { icon = " ", color = "default", alt = { "TASKS" } },
            HACK = { icon = " ", color = "#d98655" },
            WARN = { icon = " ", color = "#d98655", alt = { "WARNING", "XXX" } },
            PERF = { icon = "󰍛 ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
            NOTE = { icon = " ", color = "#1ABC9C", alt = { "INFO" } },
            TEST = { icon = "󰙨 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            DEBUG = { icon = " ", color = "info", alt = { "TRACE", "LOG" } },
            IMPORTANT = { icon = " ", color = "#764ED1", alt = { "CRITICAL", "MUST", "NEEDED", "IMPT" } },
            QUESTION = { icon = "󰘥 ", color = "error", alt = { "Q", "ASK", "DOUBT" } },
            IDEA = { icon = " ", color = "info", alt = { "THOUGHT", "SUGGESTION", "BRAINSTORM" } },
            TEMP = { icon = " ", color = "warning", alt = { "TEMPORARY", "WIP" } },
            REVIEW = { icon = " ", color = "test", alt = { "CHECK", "APPROVE" } },
            DEPRECATED = { icon = " ", color = "error", alt = { "OLD", "REMOVE" } },
            SECURITY = { icon = " ", color = "error", alt = { "VULN", "SEC" } },
            REF = { icon = " ", color = "default", alt = { "REFACTOR" } },
            KEYBIND = { icon = " ", color = "hint", alt = { "SHORTCUT", "HOTKEY", "BIND" } },
            ALIASES = { icon = " ", color = "error", alt = { "SYNONYM", "ALTERNATE", "AKA" } },
            GESTURES = { icon = " ", color = "default", alt = { "GESTURE", "SWIPE", "TOUCH", "PINCH" } },
        },
    })
end
