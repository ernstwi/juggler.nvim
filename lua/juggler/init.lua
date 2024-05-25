local Hydra = require("hydra")

local buffers = require("juggler.buffers")
local ui = require("juggler.ui")
local util = require("juggler.util")

---@class Options
---@field keys string
---@field highlight_group_active string
---@field highlight_group_inactive string
---@field highlight_group_separator string

local M = {}

local hydra

---@param opts Options
function M.setup(opts)
  opts = opts or {}

  local defaults = {
    keys = "asdfghjkl",
    highlight_group_active = "Question",
    highlight_group_inactive = "None",
    highlight_group_separator = "Whitespace",
  }

  for key, value in pairs(defaults) do
    if opts[key] == nil then
      opts[key] = value
    end
  end

  -- Setup autocmd
  local augroup = vim.api.nvim_create_augroup("Juggler", {
    clear = false,
  })
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = augroup,
    callback = function()
      local current_buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_var(current_buf, "lastused", vim.loop.now())
    end,
  })

  -- Setup hydra
  local heads = {}
  local keys = util.split(opts.keys)

  for i, key in ipairs(keys) do
    table.insert(heads, {
      key,
      function()
        local prev = buffers.selected()
        buffers.select(i)
        local new = buffers.selected()

        -- New buffer selected, redraw
        if prev ~= new then
          ui.render(buffers.get(), opts)
          return
        end

        -- Selection confirmed, open buffer and exit hydra
        vim.api.nvim_set_current_buf(new.id)
        hydra:exit()
      end,
    })
  end

  hydra = Hydra({
    mode = "n",
    config = {
      hint = false,
      invoke_on_body = true,
      on_enter = function()
        buffers.setup()
        ui.render(buffers.get(), opts)
      end,
    },
    heads = heads,
  })
end

function M.activate()
  hydra:activate()
end

return M
