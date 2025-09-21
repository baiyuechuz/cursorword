local M = {}

M.default_configs = {
  max_word_length = 100,
  min_word_length = 2,
  highlight_in_insert_mode = false,
  excluded = {
    filetypes = {},
    buftypes = {
      "prompt",
      "terminal",
    },
    patterns = {},
    words = {
      "TODO",
      "FIXME",
      "NOTE",
      "HACK",
      "XXX",
    },
  },
  highlight = {
    underline = true,
  },
  keymaps = {
    next = "]w",
    prev = "[w",
  },
}

local function merge_config(default_opts, user_opts)
  local default_options_type = type(default_opts)

  if default_options_type == type(user_opts) then
    if default_options_type == "table" and default_opts[1] == nil then
      for k, v in pairs(user_opts) do
        default_opts[k] = merge_config(default_opts[k], v)
      end
    else
      default_opts = user_opts
    end
  elseif default_opts == nil then
    default_opts = user_opts
  end
  return default_opts
end

M.merge_config = function(user_opts)
  return merge_config(M.default_configs, user_opts)
end

local function arr_contains(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

local function matches_file_patterns(file_name, file_patterns)
  for _, pattern in ipairs(file_patterns) do
    if file_name:match(pattern) then
      return true
    end
  end
  return false
end

M.check_disabled = function(excluded, bufnr)
  local api = vim.api
  return arr_contains(excluded.buftypes, api.nvim_get_option_value("buftype", { buf = bufnr or 0 }))
    or arr_contains(excluded.filetypes, api.nvim_get_option_value("filetype", { buf = bufnr or 0 }))
    or matches_file_patterns(api.nvim_buf_get_name(bufnr or 0), excluded.patterns)
end

return M

