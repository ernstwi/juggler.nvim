local ui = require("juggler.ui")
local util = require("juggler.util")

local function test_join(filenames, separator, max_width, expected)
  local in_groups = util.map(filenames, function(filename)
    return { filename, "hl" }
  end)

  local res_groups = ui.join(in_groups, { separator, "hl" }, max_width)

  local res_text = table.concat(util.map(res_groups, function(group)
    return group[1]
  end))

  assert(res_text == expected, "expected " .. expected .. ", got " .. res_text)
end

test_join({ "1234", "6789" }, "|", 0, "")
test_join({ "1234", "6789" }, "|", 1, ">")
test_join({ "1234", "6789" }, "|", 2, "1>")
test_join({ "1234", "6789" }, "|", 5, "1234>")
test_join({ "1234", "6789" }, "|", 6, "1234|>")
test_join({ "1234", "6789" }, "|", 7, "1234|6>")
test_join({ "1234", "6789" }, "|", 9, "1234|6789")

print("ui tests passed")
