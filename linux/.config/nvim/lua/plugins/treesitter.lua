return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'python', 'yaml', 'jinja', 'bash' },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- Disable Treesitter's indentation for YAML files, as it can be unreliable.
      -- This allows Neovim's built-in indentation to work correctly.
      indent = {
        enable = true,
        disable = { 'yaml' },
      },
    }
  end,
}
