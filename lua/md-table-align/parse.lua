---@class ParseModule
local M = {}
local regex = require("md-table-align.regex")

---行がセパレータ行かチェック（:---, ---, :-: など）
---@param line string
---@return boolean
local function is_separator_line(line)
  if not regex.is_table_line(line) then
    return false
  end
  local cells = regex.extract_cells(line)
  for _, cell in ipairs(cells) do
    local trimmed = regex.trim(cell)
    if trimmed == "" then
      return false
    end
    if not regex.is_separator_cell(trimmed) then
      return false
    end
  end
  return true
end

---カーソル行からテーブルの境界を探す
---上方向にスキャンして開始行を、下方向にスキャンして終了行を探す
---@param line_num integer カーソル行番号（1-indexed）
---@param lines string[] バッファの内容
---@return {start_line: integer, end_line: integer, separator_line: integer}|nil
function M.find_table(line_num, lines)
  if line_num < 1 or line_num > #lines then
    return nil
  end

  if not regex.is_table_line(lines[line_num]) then
    return nil
  end

  -- 上方向にスキャンしてテーブル開始行を探す
  local start_line = line_num
  while start_line > 1 and regex.is_table_line(lines[start_line - 1]) do
    start_line = start_line - 1
  end

  -- 最初の2行以内にセパレータを探す
  local separator_line = nil
  for i = start_line, math.min(start_line + 1, #lines) do
    if is_separator_line(lines[i]) then
      separator_line = i
      break
    end
  end

  if not separator_line then
    return nil
  end

  -- 下方向にスキャンしてテーブル終了行を探す
  local end_line = separator_line
  while end_line < #lines and regex.is_table_line(lines[end_line + 1]) do
    end_line = end_line + 1
  end

  return {
    start_line = start_line,
    end_line = end_line,
    separator_line = separator_line
  }
end

---テーブルをセルと配置情報に解析する
---セル内容を抽出し、セパレータ行から列の配置方式を判定する
---@param lines string[] バッファの内容
---@param start integer 開始行（1-indexed）
---@param end_line integer 終了行（1-indexed）
---@param separator integer セパレータ行（1-indexed）
---@return {cells: string[][], alignments: string[]} 例：{cells={{"Name", "Age"}, {"Alice", "30"}}, alignments={"left", "center"}}
function M.parse_table(lines, start, end_line, separator)
  local cells = {}

  -- セパレータ以外の行からセルを抽出する
  for i = start, end_line do
    if i ~= separator then
      local row = {}
      for _, cell in ipairs(regex.extract_cells(lines[i])) do
        table.insert(row, regex.trim(cell))
      end
      table.insert(cells, row)
    end
  end

  -- セパレータのパターンから配置方式を判定する
  local alignments = {}
  for _, cell in ipairs(regex.extract_cells(lines[separator])) do
    local trimmed = regex.trim(cell)
    table.insert(alignments, regex.get_alignment(trimmed))
  end

  return {
    cells = cells,
    alignments = alignments
  }
end

return M
