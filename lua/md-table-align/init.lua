--- *md-table-align*  A Neovim plugin for aligning Markdown tables
---
--- MIT License Copyright (c) 2025 sh1Nome
---
---@toc

--- - Aligns columns to uniform width
--- - Respects alignment directives from separator rows
--- - Ensures minimum 1 space between pipes and content
--- - Pure Lua, with no external dependencies.
---@tag md-table-align-features
---@toc_entry Features

--- Use the |:MdTableAlign| command. This aligns the Markdown table containing
--- the cursor. The plugin only aligns on command execution - it does not
--- auto-align.
---@tag md-table-align-usage
---@toc_entry Usage

--- :MdTableAlign                                *:MdTableAlign*
---
---   Aligns the Markdown table containing the cursor.
---@tag md-table-align-commands
---@toc_entry Commands

--- The following is an example of optional key mapping: >
--- >lua
---   vim.keymap.set("n", "<leader>t", function()
---           require("md-table-align").align_table()
---   end, { desc = "Align a markdown table" })
--- <
---@tag md-table-align-keybindings
---@toc_entry Key mapping

local parse = require("md-table-align.parse")
local width = require("md-table-align.width")
local formatter = require("md-table-align.formatter")

local M = {}

--- Aligns the Markdown table containing the cursor.
---
--- This function performs the following steps:
--- 1. Finds the table boundaries around the cursor position
--- 2. Parses table cells and alignment directives from the separator row
--- 3. Calculates optimal column widths based on cell content
--- 4. Formats all rows with proper spacing and alignment
--- 5. Updates the buffer with the formatted table
---
--- If the cursor is not on a valid Markdown table, a notification is displayed.
---@tag md-table-align-api-align_table
---@toc_entry align_table()
function M.align_table()
	local current_buf = vim.api.nvim_get_current_buf()
	local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
	local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

	-- テーブルの境界を探す
	local table_info = parse.find_table(cursor_line, lines)
	if not table_info then
		vim.notify("Table not found at cursor", vim.log.levels.INFO)
		return
	end

	-- セルと配置情報を抽出する
	local parsed = parse.parse_table(lines, table_info.start_line, table_info.end_line, table_info.separator_line)

	-- 列幅を計算する
	local widths = width.calculate_column_widths(parsed.cells)

	-- すべての行をフォーマットする
	local formatted_lines = formatter.format_table(parsed.cells, parsed.alignments, widths)

	-- バッファをフォーマット済みテーブルで更新する
	vim.api.nvim_buf_set_lines(current_buf, table_info.start_line - 1, table_info.end_line, false, formatted_lines)
end

return M
