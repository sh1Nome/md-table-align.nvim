---@class RegexModule
local M = {}

---パイプで区切られたセルを抽出する（前後のスペース付き）
---エスケープされたパイプ（\|）はセル内容として保持される
---@param line string
---@return string[] セルのリスト（トリムなし、行末の空セルは除外）
function M.extract_cells(line)
	local cells = {}
	local current_cell = ""

	-- 最初のパイプの位置を探す
	local first_pipe_pos = line:find("|")
	if not first_pipe_pos then
		return cells
	end

	-- 最初のパイプの次の位置から処理開始
	local i = first_pipe_pos + 1
	local len = #line

	while i <= len do
		local char = line:sub(i, i)

		if char == "\\" then
			-- バックスラッシュとその次の文字をセルに追加
			local next_char = line:sub(i + 1, i + 1)
			current_cell = current_cell .. char .. next_char
			i = i + 2
		elseif char == "|" then
			-- 非エスケープのパイプはセル区切り
			table.insert(cells, current_cell)
			current_cell = ""
			i = i + 1
		else
			-- その他の文字をセルに追加
			current_cell = current_cell .. char
			i = i + 1
		end
	end

	-- 行末の空セル（最後のパイプの後）を除外
	if #cells > 0 then
		local trimmed = M.trim(cells[#cells])
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

---指定位置の文字がエスケープされているかチェック（直前の\ の個数が奇数か）
---@param line string
---@param pos integer 1-indexed
---@return boolean エスケープされている場合 true
local function is_escaped(line, pos)
	if pos <= 1 then
		return false
	end
	local backslash_count = 0
	local i = pos - 1
	while i >= 1 and line:sub(i, i) == "\\" do
		backslash_count = backslash_count + 1
		i = i - 1
	end
	return backslash_count % 2 == 1
end

---行がテーブル行かチェック（非エスケープのパイプで始まり終わる）
---@param line string
---@return boolean
function M.is_table_line(line)
	-- 先頭の非空白位置を探す
	-- () は位置をキャプチャして、スペース・タブをスキップした後のインデックスを返す
	local first_non_space = line:match("^%s*()")
	if not first_non_space then
		return false
	end

	-- 末尾の非空白位置を探す
	local last_non_space = 0
	for i = #line, 1, -1 do
		if line:sub(i, i) ~= " " and line:sub(i, i) ~= "\t" then
			last_non_space = i
			break
		end
	end

	if last_non_space == 0 then
		return false
	end

	-- 先頭と末尾がパイプであり、エスケープされていないか確認
	local first_char_is_pipe = line:sub(first_non_space, first_non_space) == "|"
	local last_char_is_pipe = line:sub(last_non_space, last_non_space) == "|"

	if not first_char_is_pipe or not last_char_is_pipe then
		return false
	end

	return not is_escaped(line, first_non_space) and not is_escaped(line, last_non_space)
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
---@return string "left, center, right, plain"
function M.get_alignment(str)
	if str:match("^:%-+:$") then
		return "center"
	elseif str:match("^%-+:$") then
		return "right"
	elseif str:match("^:%-+$") then
		return "left"
	else
		return "plain"
	end
end

return M
