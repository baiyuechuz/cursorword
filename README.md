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
})
```

### Jumping Between Word Occurrences

You can also use the Lua API functions directly:

```lua
-- Jump to next occurrence of the word under cursor
require('cursorword').jump_next()

-- Jump to previous occurrence of the word under cursor
require('cursorword').jump_prev()
```

Example key mappings:

```lua
vim.keymap.set('n', '<leader>n', function() require('cursorword').jump_next() end, { desc = 'Jump to next word occurrence' })
vim.keymap.set('n', '<leader>p', function() require('cursorword').jump_prev() end, { desc = 'Jump to previous word occurrence' })
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
