return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {"<C-p>", ":FzfLua<CR>" },
  },
  config = function()
    -- calling `setup` is optional for customization
    require("fzf-lua").setup({})
  end
}
