local util = require("juggler.util")
local c = require("juggler.chunks")

local M = {}

---@param chunks chunk[]
---@param separator chunk
---@param max_width integer
---@return chunk
function M.join(chunks, separator, max_width, cutoff_highlight)
  if max_width == 0 then
    return {}
  end

  -- Insert separator between each chunk
  local res = {}
  for i, chunk in ipairs(chunks) do
    table.insert(res, chunk)
    if i < #chunks then
      table.insert(res, separator)
    end
  end

  if #c.text(res) <= max_width then
    return res
  end

  while #c.text(res) > max_width do
    c.shorten(res)
  end

  -- Replace the last character of the last chunk with a ">"
  local last = res[#res]
  last[1] = string.sub(last[1], 1, #last[1] - 1)
  table.insert(res, { ">", cutoff_highlight })

  return res
end

function M.draw(buffers, opts)
  local chunks = util.map(buffers, function(buf)
    return {
      buf.name,
      buf.selected and opts.highlight_group_active or opts.highlight_group_inactive,
    }
  end)
  local res =
    M.join(chunks, { " | ", opts.highlight_group_separator }, vim.o.columns - 1, opts.highlight_group_separator)
  vim.api.nvim_echo(res, false, {})
end

return M
