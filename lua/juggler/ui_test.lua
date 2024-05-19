local ui = require("juggler.ui")
local util = require("juggler.util")

local function test(filenames, separator, max_width, expected)
  local buffers = util.map(filenames, function(filename)
    return {
      id = 0,
      name = filename,
      lastused = 0,
      selected = false,
    }
  end)

  local chars = ui.compile(buffers, { separator = separator }, max_width)

  local text = table.concat(util.map(chars, function(c)
    return c.c
  end))

  assert(text == expected, "expected " .. expected .. ", got " .. text)
end

test({ "1234", "6789" }, "|", 0, "")
test({ "1234", "6789" }, "|", 1, ">")
test({ "1234", "6789" }, "|", 2, "1>")
test({ "1234", "6789" }, "|", 5, "1234>")
test({ "1234", "6789" }, "|", 6, "1234|>")
test({ "1234", "6789" }, "|", 7, "1234|6>")
test({ "1234", "6789" }, "|", 9, "1234|6789")

print("ui tests passed")
