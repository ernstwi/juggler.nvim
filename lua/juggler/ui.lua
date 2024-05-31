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

  -- Fit to max width

  -- Make sublists for left and right of the selected buffer
  local left = {} ---@type StyledChar[]
  local selection = {} ---@type StyledChar[]
  local right = {} ---@type StyledChar[]
  local current = left
  for _, c in ipairs(cs) do
    if c.hl == opts.highlight_group_active then
      current = right -- Switch to right
      table.insert(selection, c)
    else
      table.insert(current, c)
    end
  end

  if #selection == 0 then
    left = {}
    selection = { cs[1] }
    right = util.slice(cs, 2, #cs + 1)
  end

  -- Pad selection to the left and right
  local res = selection
  local add_right = true
  while #res < max_width do
    if add_right then
      add_right = false
      if #right > 0 then
        table.insert(res, #res + 1, table.remove(right, 1))
      end
    else
      add_right = true
      if #left > 0 then
        table.insert(res, 1, table.remove(left))
      end
    end
  end

  -- If there are left over characters, add "<", ">" to endings
  if #left > 0 then
    res[1] = { c = "<", hl = opts.highlight_group_separator }
  end
  if #right > 0 then
    res[#res] = { c = ">", hl = opts.highlight_group_separator }
  end

  return res
end

function M.render(buffers, opts)
  local max_width = vim.o.columns - 2
  local cs = M.compile(buffers, opts, max_width)
  local tuples = util.map(cs, function(c)
    return { c.c, c.hl }
  end)
  vim.api.nvim_echo(tuples, false, {})
end

return M
