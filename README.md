## Cursorword

A concise, precise, and high-performance cursor word highlighting plugin for Neovim, implemented in Lua.

## Usage

`:Cursorword` command

| **Args**  | **Description**                             |
| --------- | ------------------------------------------- |
| `toggle`  | Toggle highlight the word under the cursor  |
| `enable`  | Enable highlight the word under the cursor  |
| `disable` | Disable highlight the word under the cursor |
| `next`    | Jump to next occurrence of the current word |
| `prev`    | Jump to previous occurrence of the current word |

## Configuration

```lua
require('cursorword').setup({
  max_word_length = 100,
  min_word_length = 2,
  highlight_in_insert_mode = false,  -- Enable/disable highlighting in insert mode (default: false)
  excluded = {
    filetypes = {},
    buftypes = { "prompt", "terminal" },
    patterns = {}
  },
  highlight = {
    underline = true,
  },
  keymaps = {
    next = "<leader>nw",  -- Jump to next occurrence (default: <leader>nw)
    prev = "<leader>pw",  -- Jump to previous occurrence (default: <leader>pw)
  },
})
```

### Jumping Between Word Occurrences

The plugin sets up default keymaps `<leader>nw` and `<leader>pw` for jumping between word occurrences. 

To disable default keymaps:

```lua
require('cursorword').setup({
  keymaps = false,  -- Disable all default keymaps
})
```

Or customize the keymaps:

```lua
require('cursorword').setup({
  keymaps = {
    next = "<leader>n",   -- Custom keymap for next occurrence  
    prev = "<leader>p",   -- Custom keymap for previous occurrence
  },
})
```

You can also use the Lua API functions directly:

```lua
-- Jump to next occurrence of the word under cursor
require('cursorword').jump_next()

-- Jump to previous occurrence of the word under cursor
require('cursorword').jump_prev()
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
