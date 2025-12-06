vim.api.nvim_create_user_command("MdTableAlign", function()
  require("md-table-align").align_table()
end, {})
