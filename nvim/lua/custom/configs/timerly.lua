local M = {}

M.setup = function()
  -- Increase the height and width to make the timer appear bigger
  local ok, state = pcall(require, "timerly.state")
  if ok then
    state.h = 25  -- Increased from default 14 to 25 for much bigger appearance
    state.xpad = 8  -- Increased from default 3 to 8 for wider appearance
    -- Override the width calculation to make it even wider
    state.w = 60  -- Set a fixed wider width
  end
end

return M