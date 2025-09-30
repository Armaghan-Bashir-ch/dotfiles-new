local keys = function()
    local keys = {
        {
            "<leader>H",
            function()
                require("harpoon"):list():add()
            end,
            desc = "Add Current Buffer To Harpoon Pinned File List",
        },
        {
            "<leader>h",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Harpoon Pinned Files Menu",
        },
        {
            "<M-[>",
            function()
                require("harpoon"):list():prev()
            end,
            desc = "Harpoon Previous File",
        },
        {
            "<M-]>",
            function()
                require("harpoon"):list():next()
            end,
            desc = "Harpoon Next File",
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
