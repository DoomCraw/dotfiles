return {
  -- Theme
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'tokyonight',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      }
    end,
  },

  -- Indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  -- File Explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup {}
      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })
    end,
  },

  -- Commenting
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
}
