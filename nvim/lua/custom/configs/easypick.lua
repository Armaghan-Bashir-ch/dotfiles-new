return function()
  local easypick = require "easypick"

  -- only required for the example to work
  local get_default_branch = "git remote show origin | grep 'HEAD branch' | cut -d' ' -f5"
  local base_branch = vim.fn.system(get_default_branch) or "main"

  easypick.setup {
    pickers = {
      {
        name = "changed_files",
        command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
        previewer = easypick.previewers.branch_diff { base_branch = base_branch },
      },

      {
        name = "conflicts",
        command = "git diff --name-only --diff-filter=U --relative",
        previewer = easypick.previewers.file_diff(),
      },
      {
        name = "hidden_files",
        command = "find . -type f -path './.*/*' ! -path './.git/*'",
        previewer = easypick.previewers.file_diff(),
      },
    },
  }
end
