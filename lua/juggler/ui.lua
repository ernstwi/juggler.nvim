local util = require("juggler.util")

local M = {}

---@alias chunk table<string, string> A tuple of two strings

local function chunks_to_text(chunks)
  return table.concat(util.map(chunks, function(chunk)
    return chunk[1]
  end))
end

local function shorten_string(str)
  return string.sub(str, 1, #str - 1)
end

local function shorten_chunk(chunk)
  return {
    shorten_string(chunk[1]),
    chunk[2],
  }
end

local function shorten_chunks(chunks)
  local last = chunks[#chunks]
  if #last[1] == 1 then
    table.remove(chunks, #chunks)
  else
    chunks[#chunks] = shorten_chunk(last)
  end
end

---@param chunks chunk[]
---@param separator chunk
---@param max_width integer
---@return chunk
function M.join(chunks, separator, max_width)
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

  if #chunks_to_text(res) <= max_width then
    return res
  end

  while #chunks_to_text(res) > max_width do
    shorten_chunks(res)
  end

  -- Replace the last character of the last chunk with a ">"
  local last = res[#res]
  last[1] = string.sub(last[1], 1, #last[1] - 1) .. ">"

  return res
end

function M.draw(buffers, opts)
  local chunks = util.map(buffers, function(buf)
    return {
      buf.name,
      buf.selected and opts.highlight_group_active or opts.highlight_group_inactive,
    }
  end)
  local res = M.join(chunks, { " | ", opts.highlight_group_separator }, vim.o.columns - 1)
  vim.api.nvim_echo(res, false, {})
end

return M
