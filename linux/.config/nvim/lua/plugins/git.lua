return {
  -- Adds git signs to the signcolumn.
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  -- Core Git commands.
  {
    'tpope/vim-fugitive',
  },
  -- Lazygit integration.
  {
    'kdheepak/lazygit.nvim',
    cmd = { 'LazyGit' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      vim.keymap.set('n', '<leader>gg', '<cmd>LazyGit<CR>', { desc = 'Open LazyGit' })
    end,
  },
}
