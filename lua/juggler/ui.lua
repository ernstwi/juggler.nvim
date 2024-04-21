local util = require("juggler.util")

local M = {}

local function join(t, s)
  local res = {}
  local n = #t
  for i = 1, n do
    table.insert(res, t[i])
    if i < n then
      table.insert(res, s)
    end
  end
  return res
end

function M.draw(buffers)
  local chunks = util.map(buffers, function(buf)
    return { buf.name, buf.selected and "Underlined" or "None" }
  end)
  local res = join(chunks, { " | ", "None" })
  vim.api.nvim_echo(res, false, {})
end

return M
