return {
  -- Provides Ansible syntax highlighting and other niceties.
  -- Filetype detection is handled in init.lua to ensure correctness.
  { 'pearofducks/ansible-vim' },

  -- Linter for Ansible and Python.
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        ['yaml.ansible'] = { 'ansible-lint' },
        python = { 'ruff' },
      }
      -- Automatically run linter on save.
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  -- Ensures linters and formatters are installed.
  {
    'williamboman/mason.nvim',
    opts = {
      ensure_installed = {
        'ansible-lint',
        'ruff',
        'yamlfix',
        'black',
      },
    },
  },
}
