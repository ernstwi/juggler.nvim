local util = require("juggler.util")

---@class StyledChar
---@field c string
---@field hl string

local M = {}

---@return StyledChar[]
---@param buffers Buffer[]
---@param opts Options
function M.compile(buffers, opts, max_width)
  local cs = {} ---@type StyledChar[]
  for i, buf in ipairs(buffers) do
    for _, c in ipairs(util.split(buf.name)) do
      table.insert(cs, {
        c = c,
        hl = buf.selected and opts.highlight_group_active or opts.highlight_group_inactive,
      })
    end
    if i < #buffers then
      table.insert(cs, { c = "|", hl = opts.highlight_group_separator })
    end
  end

  if #cs <= max_width then
    return cs
  end

  while #cs > max_width do
    table.remove(cs) -- Remove last element
  end

  -- Replace the last character with a ">"
  cs[#cs] = { c = ">", hl = opts.highlight_group_separator }

  return cs
end

function M.render(buffers, opts)
  local max_width = vim.o.columns - 1
  local cs = M.compile(buffers, opts, max_width)
  local tuples = util.map(cs, function(c)
    return { c.c, c.hl }
  end)
  vim.api.nvim_echo(tuples, false, {})
end

return M
