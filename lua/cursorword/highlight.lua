local M = {}

local PLUG_NAME = "cursorword"

local function matchdelete(window_state)
  local w = vim.w
  local fn = vim.fn
  if w.cursorword ~= nil then
    pcall(fn.matchdelete, w.cursorword)
    w.cursorword = nil
    window_state.prev_start_column = math.huge
    window_state.prev_end_column = -1
  end
end

local function highlight_same(configs, window_state)
  if not window_state.enabled then
    return
  end

  local api = vim.api
  local fn = vim.fn
  local get_line = api.nvim_get_current_line
  local get_cursor = api.nvim_win_get_cursor
  local matchstrpos = fn.matchstrpos
  local matchadd = fn.matchadd

  if not configs.highlight_in_insert_mode and api.nvim_get_mode().mode:sub(1, 1) == "i" then
    matchdelete(window_state)
    return
  end

  local cursor_pos = get_cursor(0)
  local cursor_column = cursor_pos[2]
  local cursor_line = cursor_pos[1]

  if
    window_state.prev_line == cursor_line
    and cursor_column >= window_state.prev_start_column
    and cursor_column < window_state.prev_end_column
  then
    return
  end
  window_state.prev_line = cursor_line

  matchdelete(window_state)

  local line = get_line()

  if fn.type(line) == vim.v.t_blob then
    return
  end

  local matches = matchstrpos(line:sub(1, cursor_column + 1), [[\w*$]])
  local word = matches[1]

  if word ~= "" then
    window_state.prev_start_column = matches[2]
    matches = matchstrpos(line, [[^\w*]], cursor_column + 1)
    word = word .. matches[1]
    window_state.prev_end_column = matches[3]

    local word_len = #word
    if word_len < configs.min_word_length or word_len > configs.max_word_length then
      return
    end

    vim.w.cursorword = matchadd(PLUG_NAME, [[\(\<\|\W\|\s\)\zs]] .. word .. [[\ze\(\s\|[^[:alnum:]_]\|$\)]], -1)
  end
end

M.setup_highlighting = function(configs, window_state, config_module)
  local api = vim.api
  local group = api.nvim_create_augroup(PLUG_NAME, { clear = true })
  api.nvim_set_hl(0, PLUG_NAME, configs.highlight)

  local disabled = config_module.check_disabled(configs.excluded, 0)
  if not disabled then
    highlight_same(configs, window_state)
  end

  api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      api.nvim_set_hl(0, PLUG_NAME, configs.highlight)
    end,
  })

  local skip_cursormoved = false

  api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = group,
    callback = function()
      skip_cursormoved = true
      vim.defer_fn(function()
        disabled = config_module.check_disabled(configs.excluded, 0)
        if not disabled then
          highlight_same(configs, window_state)
        end
      end, 8)
    end,
  })

  api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = group,
    callback = function()
      if skip_cursormoved then
        skip_cursormoved = false
      elseif not disabled then
        highlight_same(configs, window_state)
      end
    end,
  })

  api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    group = group,
    callback = function()
      matchdelete(window_state)
    end,
  })
end

M.disable_highlighting = function(window_state)
  matchdelete(window_state)
  vim.api.nvim_del_augroup_by_name(PLUG_NAME)
end

return M

