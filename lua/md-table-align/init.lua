local parse = require("md-table-align.parse")
local width = require("md-table-align.width")
local formatter = require("md-table-align.formatter")

---@class MdTableAlign
local M = {}

---カーソル位置のMarkdownテーブルをフォーマットする
---処理フロー：テーブル検出 → セル解析 → 幅計算 → フォーマット → バッファ更新
---@return nil
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
  local parsed = parse.parse_table(
    lines,
    table_info.start_line,
    table_info.end_line,
    table_info.separator_line
  )

  -- 列幅を計算する
  local widths = width.calculate_column_widths(parsed.cells)

  -- すべての行をフォーマットする
  local formatted_lines = formatter.format_table(parsed.cells, parsed.alignments, widths)

  -- バッファをフォーマット済みテーブルで更新する
  vim.api.nvim_buf_set_lines(
    current_buf,
    table_info.start_line - 1,
    table_info.end_line,
    false,
    formatted_lines
  )
end

return M
