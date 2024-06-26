local M = {}

-- Split a string into an array of characters
---@param s string
---@return string[]
function M.split(s)
  local chars = {}
  for i = 1, #s do
    chars[i] = string.sub(s, i, i)
  end
  return chars
end

---@param t table
---@return table
function M.map(t, func)
  local res = {}
  for i, v in ipairs(t) do
    res[i] = func(v)
  end
  return res
end

---@param t table
---@return table
function M.filter(t, condition)
  local res = {}
  for _, v in ipairs(t) do
    if condition(v) then
      table.insert(res, v)
    end
  end
  return res
end

---@param t table
---@return table
function M.slice(t, start, stop)
  local result = {}
  for i = start, stop do
    table.insert(result, t[i])
  end
  return result
end

return M
