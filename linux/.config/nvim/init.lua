-- Set <space> as the leader key
-- This must be set before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load core configuration files
require('core.options')
require('core.keymaps')

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with our plugin specifications
-- All files in lua/plugins/ will be loaded automatically
require('lazy').setup('plugins')

-- Force filetype for all YAML files to be Ansible
-- This creates a dedicated group to ensure this rule is not overridden.
local ansible_ft_group = vim.api.nvim_create_augroup('AnsibleFiletype', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = ansible_ft_group,
  pattern = { '*.yaml', '*.yml' },
  command = 'set filetype=yaml.ansible',
})
