return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
  dependencies = { 'echasnovski/mini.nvim' },
  config = function()
    require 'custom.config.oil'
  end,
}
