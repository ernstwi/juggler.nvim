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

function M.draw(buffers, opts)
  local chunks = util.map(buffers, function(buf)
    return {
      buf.name,
      buf.selected and opts.highlight_group_active or opts.highlight_group_inactive,
    }
  end)
  local res = join(chunks, { " | ", opts.highlight_group_separator })
  vim.api.nvim_echo(res, false, {})
end

return M
