local minidoc = require("mini.doc")

if _G.MiniDoc == nil then
	minidoc.setup()
end

MiniDoc.generate({ "lua/md-table-align/init.lua" }, "doc/md-table-align.txt")
