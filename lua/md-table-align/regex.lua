---@class RegexModule
local M = {}

---パイプで区切られたセルを抽出する（前後のスペース付き）
---@param line string
---@return string[] セルのリスト（トリムなし、行末の空セルは除外）
function M.extract_cells(line)
  local cells = {}
  for cell in line:gmatch("|([^|]*)") do
    table.insert(cells, cell)
  end
  -- 行末の空セル（最後のパイプの後）を除外
  if #cells > 0 then
    local trimmed = cells[#cells]:match("^%s*(.-)%s*$") or ""
    if trimmed == "" then
      table.remove(cells)
    end
  end
  return cells
end

---文字列の前後のスペースをトリムする
---@param str string
---@return string トリム済み文字列
function M.trim(str)
  return str:match("^%s*(.-)%s*$") or ""
end

---行がテーブル行かチェック（パイプで始まり終わる）
---@param line string
---@return boolean
function M.is_table_line(line)
  return line:match("^%s*|") and line:match("|%s*$")
end

---文字列が配置マーカー付きセパレータセルかチェック
---マッチ例：「---」「:--」「--:」「:-:」
---@param str string トリム済み文字列
---@return boolean
function M.is_separator_cell(str)
  return str:match("^:?%-+:?$") ~= nil
end

---配置マーカーから配置方式を判定する
---@param str string トリム済みセパレータセル
---@return string "left, center, right"
function M.get_alignment(str)
  if str:match("^:%-+:$") then
    return "center"
  elseif str:match("^%-+:$") then
    return "right"
  else
    return "left"
  end
end

return M
