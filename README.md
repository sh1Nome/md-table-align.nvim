# md-table-align.nvim

A Neovim plugin for aligning Markdown tables.

![demo](demo.gif)

## Features

- Aligns columns to uniform width
- Respects alignment directives from separator rows
- Ensures minimum 1 space between pipes and content

## Installation

Use your favorite package manager.

## Usage

### Command

```vim
:MdTableAlign
```

Aligns the Markdown table containing the cursor. The plugin only aligns on command execution—it does not auto-align.

### Key Mapping (Optional)

```lua
vim.keymap.set('n', '<leader>ta', ':MdTableAlign<CR>', { noremap = true, silent = true })
```

