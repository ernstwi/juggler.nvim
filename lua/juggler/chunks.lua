local util = require("juggler.util")

local M = {}

---@alias chunk table<string, string> A tuple of two strings

local function shorten_string(str)
  return string.sub(str, 1, #str - 1)
end

local function shorten_chunk(chunk)
  return {
    shorten_string(chunk[1]),
    chunk[2],
  }
end

function M.shorten(chunks)
  local last = chunks[#chunks]
  if #last[1] == 1 then
    table.remove(chunks, #chunks)
  else
    chunks[#chunks] = shorten_chunk(last)
  end
end

function M.text(chunks)
  return table.concat(util.map(chunks, function(chunk)
    return chunk[1]
  end))
end

return M
