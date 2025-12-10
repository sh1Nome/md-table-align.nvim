---@class FormatterModule
local M = {}

---文字列を指定幅にパディングする
---@param str string パディングする文字列
---@param width integer 目標幅
---@param alignment string "left"、"center"、"right"
---@return string パディング済み文字列
local function pad_string(str, width, alignment)
  local str_len = vim.fn.strwidth(str)

  if str_len >= width then
    return str
  end

  local padding = width - str_len

  if alignment == "right" then
    -- 右寄せ：左にスペース、右にコンテンツ
    return string.rep(" ", padding) .. str
  elseif alignment == "center" then
    -- 中央揃え：均等にスペースを配分
    local left_pad = math.floor(padding / 2)
    local right_pad = padding - left_pad
    return string.rep(" ", left_pad) .. str .. string.rep(" ", right_pad)
  else
    -- 左寄せ：左にコンテンツ、右にスペース
    return str .. string.rep(" ", padding)
  end
end

---データ行をパディングとパイプでフォーマットする
---@param cells string[] セル内容
---@param widths integer[] 列幅
---@param alignments string[] 列の配置方式
---@return string フォーマット済み行
local function format_row(cells, widths, alignments)
  local formatted_cells = {}
  for i = 1, #widths do
    local alignment = alignments[i] or "left"
    local cell_content = cells[i] or ""
    local padded = pad_string(cell_content, widths[i], alignment)
    table.insert(formatted_cells, padded)
  end
  return "| " .. table.concat(formatted_cells, " | ") .. " |"
end

---配置マーカー付きセパレータ行を作成する
---@param widths integer[] 列幅
---@param alignments string[] 列の配置方式
---@return string セパレータ行
local function create_separator(widths, alignments)
  local sep_cells = {}
  for i = 1, #widths do
    local alignment = alignments[i] or "left"
    local width = widths[i]
    local sep_content

    if alignment == "right" then
      sep_content = string.rep("-", width - 1) .. ":"
    elseif alignment == "center" then
      sep_content = ":" .. string.rep("-", width - 2) .. ":"
    else
      sep_content = ":" .. string.rep("-", width - 1)
    end

    table.insert(sep_cells, sep_content)
  end
  return "| " .. table.concat(sep_cells, " | ") .. " |"
end

---ヘッダー、セパレータ、データ行を含む完全なテーブルをフォーマットする
---@param cells string[][] セル行列
---@param alignments string[] 列の配置方式
---@param widths integer[] 列幅
---@return string[] フォーマット済みテーブル行 例：{"| Name | Age |", "|:-----|:--:|", "| Alice | 30 |"}
function M.format_table(cells, alignments, widths)
  local formatted_lines = {}

  -- ヘッダー行をフォーマット
  if #cells > 0 then
    table.insert(formatted_lines, format_row(cells[1], widths, alignments))
  end

  -- セパレータを追加
  table.insert(formatted_lines, create_separator(widths, alignments))

  -- データ行をフォーマット
  for i = 2, #cells do
    table.insert(formatted_lines, format_row(cells[i], widths, alignments))
  end

  return formatted_lines
end

return M
