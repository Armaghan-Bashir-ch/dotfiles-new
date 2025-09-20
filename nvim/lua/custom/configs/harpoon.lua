local keys = function()
    local keys = {
        {
            "<leader>H",
            function()
                require("harpoon"):list():add()
            end,
            desc = "Harpoon File",
        },
        {
            "<leader>h",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Harpoon Quick Menu",
        },
        {
            "<Leader>[",
            function()
                local harpoon = require("harpoon")
                harpoon:list():prev()
            end,
            desc = "Harpoon Prev",
        },
        {
            "<Leader>]",
            function()
                local harpoon = require("harpoon")
                harpoon:list():next()
            end,
            desc = "Harpoon Next",
        },
    }

    for i = 1, 9 do
        table.insert(keys, {
            "<leader>" .. i,
            function()
                require("harpoon"):list():select(i)
            end,
            desc = "Harpoon to File " .. i,
        })
    end
    return keys
end

return keys
