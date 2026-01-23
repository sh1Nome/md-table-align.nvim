# md-table-align.nvim

A Neovim plugin for aligning Markdown tables.

![demo](./demo/demo.gif)

## Features

- Aligns columns to uniform width
- Respects alignment directives from separator rows
- Ensures minimum 1 space between pipes and content
- Pure Lua, with no external dependencies.

## Installation

Use your favorite package manager.

## Usage

### Command

```vim
:MdTableAlign
```

Aligns the Markdown table containing the cursor. The plugin only aligns on command execution - it does not auto-align.

### Key Mapping (Optional)

```lua
vim.keymap.set("n", "<leader>t", function()
	require("md-table-align").align_table()
end, { desc = "Align a markdown table" })
```

