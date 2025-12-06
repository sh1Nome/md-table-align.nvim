---@class WidthModule
local M = {}

---各列の最大幅を計算する
---
---アルゴリズム:
---  1. セルの行列を受け取る（例: {{"Name", "Age"}, {"Alice", "30"}}）
---  2. 各列（col）について、すべての行（row）のセル内容の長さを比較
---  3. その列のセルの中で最も長いもの（max_width）を記録
---  4. ただし、最低でも3文字（Markdownセパレータ "---" の長さ）は確保する
---  5. 結果を widths 配列に格納
---
---例: cells = {{"Name", "Age"}, {"Alice", "30"}}
---     → widths = [5, 3]
---     Name(4字) vs Alice(5字) → 5, Age(3字) vs 30(2字) → 3
---
---@param cells string[][] セル内容の行列（例：{{"Name", "Age"}, {"Alice", "30"}}）
---@return integer[] 列幅の配列（各列の最大幅、最小3）
function M.calculate_column_widths(cells)
  -- セルが空の場合は空の配列を返す
  if #cells == 0 then
    return {}
  end

  local widths = {}
  -- 最初の行の列数を取得（全行が同じ列数と仮定）
  local num_cols = #cells[1]

  -- 各列ごとにループして、その列の最大幅を見つける
  for col = 1, num_cols do
    -- 列幅の初期値：Markdownセパレータ "---" の最小長は3文字
    local max_width = 3
    
    -- 同じ列について、すべての行をループ
    for row = 1, #cells do
      -- 注意：行によって列数が異なる場合がある
      -- 例：1行目は3列、2行目は2列（不完全なテーブル）
      -- col <= #cells[row] で「この行にこの列が存在するか」を確認
      if col <= #cells[row] then
        -- セルが存在する場合、その文字数を取得
        local cell_len = #cells[row][col]
        -- これまでの最大幅と比較し、より長い方を記録
        max_width = math.max(max_width, cell_len)
      end
    end
    
    -- この列の最大幅を widths 配列に追加
    table.insert(widths, max_width)
  end

  return widths
end

return M
