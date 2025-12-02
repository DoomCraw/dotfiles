local opt = vim.opt -- For conciseness

-- Line Numbers
opt.relativenumber = true -- Show relative line numbers.
opt.number = true         -- Shows absolute line number on cursor line.

-- Tabs & Indentation
opt.tabstop = 2       -- 2 spaces for tabs.
opt.shiftwidth = 2    -- 2 spaces for indent width.
opt.expandtab = true  -- Expand tab to spaces.
opt.autoindent = true -- Copy indent from current line when starting new one.

-- Search
opt.ignorecase = true -- Ignore case when searching.
opt.smartcase = true  -- If you include mixed case, your search is case-sensitive.

-- Appearance
opt.termguicolors = true -- Enable 24-bit RGB colors.
opt.background = 'dark'  -- Tell Neovim the background is dark.
opt.signcolumn = 'yes'   -- Always show the sign column.

-- Behavior
opt.clipboard = 'unnamedplus' -- Use system clipboard.
opt.swapfile = false          -- Don't use swapfile.
opt.backup = false            -- Don't create backup files.
opt.undodir = vim.fn.stdpath('data') .. '/undodir'
opt.undofile = true

-- Performance & UI
opt.updatetime = 250 -- Faster completion.
opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete.
opt.splitright = true -- Split vertical window to the right.
opt.splitbelow = true -- Split horizontal window to the bottom.
