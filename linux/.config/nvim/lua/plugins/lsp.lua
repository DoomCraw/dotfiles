return {
  -- Mason for managing LSPs, DAP, linters, and formatters.
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  -- Bridge between Mason and lspconfig.
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = {
          'ansiblels',
          'pyright',
          'yamlls',
          'lua_ls',
          'bashls',
        },
      }
    end,
  },
  -- Core LSP configuration.
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local servers = { 'ansiblels', 'pyright', 'yamlls', 'lua_ls', 'bashls' }
      for _, lsp in ipairs(servers) do
        vim.lsp.config ( lsp, {
            capabilities = capabilities,
          }
        )
      end

      -- LSP Keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Hover' })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP Go to Definition' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP Go to References' })
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP Code Action' })
    end,
  },
}
