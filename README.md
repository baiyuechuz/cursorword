## Cursorword

A concise, precise, and high-performance cursor word highlighting plugin for Neovim, implemented in Lua.

## Usage

`:Cursorword` command

| **Args**  | **Description**                             |
| --------- | ------------------------------------------- |
| `toggle`  | Toggle highlight the word under the cursor  |
| `enable`  | Enable highlight the word under the cursor  |
| `disable` | Disable highlight the word under the cursor |

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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
