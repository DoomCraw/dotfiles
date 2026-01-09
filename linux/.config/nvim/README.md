# Neovim for Ansible & Python

This is a modern, feature-rich Neovim configuration tailored for Ansible and Python development. It is built using `lazy.nvim` for plugin management and provides a complete IDE-like experience in your terminal.

## Features

-   **Plugin Manager**: Fast and easy plugin management with [lazy.nvim](https://github.com/folke/lazy.nvim).
-   **Theme**: A beautiful, clean theme with [tokyonight.nvim](https://github.com/folke/tokyonight.nvim).
-   **LSP**: Full language server protocol support via [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) and [mason.nvim](https://github.com/williamboman/mason.nvim) for automatic LSP server installation.
    -   Pre-configured for `ansible-ls`, `pyright`, and `yamlls`.
-   **Auto-Completion**: Intelligent code completion with [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).
-   **Linting**: On-the-fly linting with [nvim-lint](https://github.com/mfussenegger/nvim-lint), using `ansible-lint` and `ruff`.
-   **Syntax Highlighting**: Advanced syntax highlighting with [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).
-   **Fuzzy Finding**: Powerful fuzzy finding for files, buffers, and text with [Telescope](https://github.com/nvim-telescope/telescope.nvim).
-   **Git Integration**: Seamless Git integration with [gitsigns](https://github.com/lewis6991/gitsigns.nvim) and a beautiful UI with [LazyGit](https://github.com/jesseduffield/lazygit).
-   **UI Enhancements**: A modern command line with [noice.nvim](https://github.com/folke/noice.nvim), a helpful keybinding menu with [which-key.nvim](https://github.com/folke/which-key.nvim), and a sleek statusline with [lualine](https://github.com/nvim-lualine/lualine.nvim).

## Screenshot
![Example Screenshot](./example.png)

## Installation

### 1. Prerequisites

Before you begin, make sure you have the following installed:

-   **Neovim v0.8.0+**
-   **Git**
-   A **[Nerd Font](https://www.nerdfonts.com/font-downloads)** (e.g., FiraCode Nerd Font, JetBrainsMono Nerd Font). Configure your terminal to use it.
-   **ripgrep** (for Telescope's live grep)
-   **lazygit** (for the Git UI)

### 2. Clone the Configuration

First, back up your existing Neovim configuration (if you have one):

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

Then, clone this repository into your `~/.config/` directory:

```bash
git clone <your-repo-url> ~/.config/nvim
```

### 3. First Launch

The first time you launch Neovim, `lazy.nvim` will automatically install all the plugins.

```bash
nvim
```

You will see the `lazy.nvim` UI installing the plugins. Once it's finished, restart Neovim, and you're all set!

## Keybindings Cheatsheet

Your **Leader key** is `Space`. Press it before any `<leader>` shortcut.

#### 📂 File & Window Management

| Shortcut        | Action                                   |
| :-------------- | :--------------------------------------- |
| `<leader>e`     | Toggle the **File Explorer** (NvimTree). |
| `<C-w>h/j/k/l`  | Navigate between splits.                 |
| `<leader>sv`    | Split window **vertically**.             |
| `<leader>sh`    | Split window **horizontally**.           |
| `<leader>sx`    | **Close** the current split.             |
| `<leader>se`    | Make all splits **equal size**.          |
| `<leader>to/tx` | Open/Close a **new tab**.                |
| `<leader>tn/tp` | Go to the **next** / **previous tab**.   |

#### 🧠 LSP & Completion

| Shortcut          | Mode     | Action                                         |
| :---------------- | :------- | :--------------------------------------------- |
| **Automatic** | Insert   | Code completion appears as you type.           |
| `<Tab>` / `<S-Tab>` | Insert   | Navigate **next/previous** in completion menu. |
| `<CR>`            | Insert   | **Confirm** the selected completion.           |
| `K`               | Normal   | **Hover** to show documentation.               |
| `gd`              | Normal   | **Go to Definition**.                          |
| `gr`              | Normal   | **Go to References**.                          |
| `<leader>ca`      | Normal   | Show available **Code Actions**.               |

#### 🔍 Searching with Telescope

| Shortcut     | Action                                 |
| :----------- | :------------------------------------- |
| `<leader>ff` | **Find Files** in your project.        |
| `<leader>fg` | **Live Grep** (search text in files).  |
| `<leader>fb` | **Find Buffers** (search open files).  |
| `<leader>fh` | **Find Help** tags.                    |

#### Git Integration

| Shortcut     | Action                         |
| :----------- | :----------------------------- |
| `<leader>gg` | Open the **LazyGit** interface. |

#### ✏️ General Editing

| Shortcut      | Mode   | Action                               |
| :------------ | :----- | :----------------------------------- |
| `jk`          | Insert | A quick way to **exit insert mode**. |
| `gcc`         | Normal | **Comment/uncomment** a line.        |
| `gc` + motion | Normal | Comment a block of text.             |
| `<leader>nh`  | Normal | **Clear search highlights**.         |
