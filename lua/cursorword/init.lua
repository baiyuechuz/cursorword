local config = require("cursorword.config")
local highlight = require("cursorword.highlight")
local jump = require("cursorword.jump")

local M = {}

local state = {
  enabled = false,
  prev_line = -1,
  prev_start_column = math.huge,
  prev_end_column = -1,
}

local enable = function(opts)
  state.enabled = true
  highlight.setup_highlighting(opts, state, config)
end

local disable = function()
  highlight.disable_highlighting(state)
  state.enabled = false
end

local toggle = function(opts)
  if state.enabled then
    disable()
  else
    enable(opts)
  end
end

M.setup = function(user_opts)
  local opts = config.merge_config(user_opts)

  vim.api.nvim_create_user_command("Cursorword", function(args)
    local arg = string.lower(args.args)
    if arg == "enable" then
      enable(opts)
    elseif arg == "disable" then
      disable()
    elseif arg == "toggle" then
      toggle(opts)
    elseif arg == "next" then
      jump.jump_next(state)
    elseif arg == "prev" then
      jump.jump_prev(state)
    end
  end, {
    nargs = 1,
    complete = function()
      return { "enable", "disable", "toggle", "next", "prev" }
    end,
    desc = "Enable/disable cursorword or jump to next/previous occurrence",
  })

  if opts.keymaps then
    if opts.keymaps.next then
      vim.keymap.set("n", opts.keymaps.next, function()
        jump.jump_next(state)
      end, { desc = "Jump to next word occurrence" })
    end
    if opts.keymaps.prev then
      vim.keymap.set("n", opts.keymaps.prev, function()
        jump.jump_prev(state)
      end, { desc = "Jump to previous word occurrence" })
    end
  end

  enable(opts)
end

M.jump_next = function()
  jump.jump_next(state)
end

M.jump_prev = function()
  jump.jump_prev(state)
end

return M

