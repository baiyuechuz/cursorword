local M = {}

local function jump_to_word(direction, enabled_state)
  if not enabled_state.enabled then
    return
  end

  local api = vim.api
  local fn = vim.fn
  local get_line = api.nvim_get_current_line
  local get_cursor = api.nvim_win_get_cursor
  local matchstrpos = fn.matchstrpos

  local cursor_pos = get_cursor(0)
  local cursor_line = cursor_pos[1]
  local cursor_column = cursor_pos[2]
  local current_line = get_line()

  local matches = matchstrpos(current_line:sub(1, cursor_column + 1), [[\w*$]])
  local current_word = matches[1]

  if current_word ~= "" then
    matches = matchstrpos(current_line, [[^\w*]], cursor_column + 1)
    current_word = current_word .. matches[1]
  end

  if current_word == "" or #current_word < 2 then
    return
  end

  local buf_lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local word_positions = {}

  for line_num, line_content in ipairs(buf_lines) do
    local start_pos = 1
    while true do
      local word_start, word_end = line_content:find(vim.pesc(current_word), start_pos)
      if not word_start then
        break
      end

      local char_before = word_start == 1 and "" or line_content:sub(word_start - 1, word_start - 1)
      local char_after = word_end == #line_content and "" or line_content:sub(word_end + 1, word_end + 1)

      local is_word_start = word_start == 1 or not char_before:match("[%w_]")
      local is_word_end = word_end == #line_content or not char_after:match("[%w_]")

      if is_word_start and is_word_end then
        table.insert(word_positions, { line_num, word_start - 1 })
      end

      start_pos = word_end + 1
    end
  end

  if #word_positions <= 1 then
    return
  end

  local current_idx = nil
  for i, pos in ipairs(word_positions) do
    if pos[1] == cursor_line and math.abs(pos[2] - cursor_column) <= #current_word then
      current_idx = i
      break
    end
  end

  if not current_idx then
    return
  end

  local next_idx
  if direction == "next" then
    next_idx = current_idx == #word_positions and 1 or current_idx + 1
  else
    next_idx = current_idx == 1 and #word_positions or current_idx - 1
  end

  local target_pos = word_positions[next_idx]
  api.nvim_win_set_cursor(0, { target_pos[1], target_pos[2] })
end

M.jump_next = function(enabled_state)
  jump_to_word("next", enabled_state)
end

M.jump_prev = function(enabled_state)
  jump_to_word("prev", enabled_state)
end

return M

