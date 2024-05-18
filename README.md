# juggler.nvim

Reimplementation of [LustyJuggler](https://www.vim.org/scripts/script.php?script_id=2050) for Neovim.

## Todo

- Scrolling
- Differentiation of files with same basename

## Usage

1. Press `<leader>j` to display the most recently used buffers in the cmdline bar. Each buffer is mapped to a key on the home row.
2. Press a home row key to highlight buffer.
3. Press the same key again to switch to that buffer.

## Installation

Using `lazy.nvim`:

```lua
{
  "ernstwi/juggler.nvim",
  opts = {},
  keys = {
    {
      "<leader>j",
      function()
        require("juggler").activate()
      end,
      desc = "Juggler",
    },
  },
  dependencies = {
    "nvimtools/hydra.nvim",
  },
}
```

## Configuration

Default `opts`:

```lua
{
  -- Home row keys used to select buffer. Tweak this for alternative keyboard layouts.
  keys = "asdfghjkl",
  -- Highlight groups used for the cmdline UI.
  highlight_group_active = "Question",      -- The selected buffer.
  highlight_group_inactive = "None",        -- All other buffers.
  highlight_group_separator = "Whitespace", -- The `|` between buffers. Also used for the
                                            -- line cutoff indicator `>`.
}
```
