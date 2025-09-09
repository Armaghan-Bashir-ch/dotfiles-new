local config = function()
  -- Code to run after plenary.nvim is loaded
  local Job = require "plenary.job"
  local async = require "plenary.async"

  -- Path to wakatime-cli
  local wakatime_cli_path = os.getenv "HOME" .. "/.wakatime/wakatime-cli"

  -- Check if the wakatime-cli exists
  local function is_wakatime_cli_available()
    return vim.fn.filereadable(wakatime_cli_path) == 1
  end

  -- Define an asynchronous function to get today's WakaTime usage
  local get_wakatime_time = async.void(function()
    if not is_wakatime_cli_available() then
      vim.notify("WakaTime CLI not found at " .. wakatime_cli_path, vim.log.levels.WARN)
      return
    end

    local tx, rx = async.control.channel.oneshot()
    local ok, job = pcall(Job.new, Job, {
      command = wakatime_cli_path,
      args = { "--today" },
      on_exit = function(j, _)
        tx(j:result()[1] or "No data")
      end,
    })
    if not ok then
      vim.notify("Failed to create WakaTime job: " .. job, vim.log.levels.ERROR)
      return
    end

    job:start()
    local result = rx()
    if result then
      print(result) -- Print the result to Neovim's command line
    end
  end)

  -- Define a command to execute the async function
  vim.api.nvim_create_user_command("FetchWakaTime", function()
    async.run(get_wakatime_time)
  end, {})

  -- Optional: Set an autocommand to fetch WakaTime data on a regular basis
  vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
      async.run(get_wakatime_time)
    end,
    desc = "Fetch WakaTime data when the cursor is held in place",
  })
end

return config
