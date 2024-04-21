local util = require("juggler.util")

local M = {}

local state = {}

function M.setup()
  local function safe_nvim_buf_get_var(buffer, key)
    local status, result = pcall(vim.api.nvim_buf_get_var, buffer, key)
    if status then
      return result
    else
      return 0
    end
  end

  local buffers = util.filter(vim.api.nvim_list_bufs(), function(buf)
    -- Filter out unlisted buffers
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end)
  local recent_buffers = {}

  for _, buf in ipairs(buffers) do
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    if bufname == "" then
      bufname = "[No Name]"
    end
    local lastused = safe_nvim_buf_get_var(buf, "lastused")
    table.insert(recent_buffers, { id = buf, name = bufname, lastused = lastused, selected = false })
  end

  table.sort(recent_buffers, function(a, b)
    return a.lastused > b.lastused
  end)

  state = recent_buffers
end

function M.get()
  return state
end

function M.select(n)
  for i = 1, #state do
    state[i].selected = false
  end
  if n > #state then
    n = #state
  end
  state[n].selected = true
end

function M.selected()
  for i = 1, #state do
    if state[i].selected then
      return state[i]
    end
  end
end

return M
