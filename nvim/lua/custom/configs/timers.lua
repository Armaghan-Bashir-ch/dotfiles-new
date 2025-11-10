local M = {}

M.setup = function()
    return {
        persistent = true,
        default_timer = {
            icon = "󱎫",
            log_level = vim.log.levels.INFO,
            message = "Message When Time Is Over",
            title = "Title",
        },
        dashboard = {
            update_interval = 1000,
            width = 0.5,
            height = 0.5,
        },
    }
end

return M
