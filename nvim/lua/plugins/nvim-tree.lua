vim.api.nvim_set_keymap('n', '<Tab>', ':NvimTreeToggle<CR>', {
	noremap = true,
	silent = true
})
vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeFindFile<CR>', {
	noremap = true,
	silent = true
})
vim.g.nvim_tree_side = 'left'
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_quit_on_open = 0
-- vim.g.nvim_tree_ignore = {".git", "node_modules", ".cache"}
vim.g.nvim_tree_show_icons = {
  git = 1,
  files = 1,
  folders = 1,
  folder_arrows = 0,
}

vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = '✗',
    staged = '✓',
    unmerged = '',
    renamed = '➜',
    untracked = '★',
    deleted = '',
    ignored = '',
  },
  folder = {
    arrow_open = "",
    arrow_closed = "",
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
    symlink_open = "",
  },
  lsp = {
    hint = "",
    info = "",
    warning = "",
    error = "",
  }
}


local tree = require("nvim-tree.config")
local tree_cb = tree.nvim_tree_callback

function _G.close_all()
  local lib = require('nvim-tree.lib')
  local view = require('nvim-tree.view')

  local function iter(entries)
    for _, node in ipairs(entries) do
      if node.entries and node.open then
        iter(node.entries)
        node.open = false
      end
    end
  end

  iter(lib.Tree.entries)
  lib.redraw()

  -- move cursor back to top of tree
  view.set_cursor({2, 0})
end

local g = vim.g

function _G.inc_width_ind()
    g.nvim_tree_width = g.nvim_tree_width + 5
    return g.nvim_tree_width
end

function _G.dec_width_ind()
    g.nvim_tree_width = g.nvim_tree_width - 5
    return g.nvim_tree_width
end

require("nvim-tree").setup {
	disable_netrw       = true,
	hijack_netrw        = true,
    open_on_tab         = false,
    auto_close          = true,
	update_focused_file = {
		update_cwd = true
	},
	update_to_buf_dir   = {
		enable = true,
		auto_open = true,
	},
	view = {
		mappings = {
			list = {
				{ key = "l",							cb = tree_cb("edit")},
				{ key = "h",							cb = tree_cb("close_node")},
				{ key = "X",							cb = "<Cmd>lua _G.close_all()<CR>" },
				{ key = "<ESC>",						cb = tree_cb("close")},
				{ key = '<TAB>',						cb = tree_cb('close') },
				{ key = {"<C-h>"},						cb = "<CMD>exec ':NvimTreeResize ' . v:lua.dec_width_ind()<CR>"},
				{ key = {"<C-l>"},						cb = "<CMD>exec ':NvimTreeResize ' . v:lua.inc_width_ind()<CR>"},
				{ key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
				{ key = {"<2-RightMouse>", "<C-]>"},    cb = tree_cb("cd") },
				{ key = "<C-v>",                        cb = tree_cb("vsplit") },
				{ key = "<C-x>",                        cb = tree_cb("split") },
				{ key = "<C-t>",                        cb = tree_cb("tabnew") },
				{ key = "<",                            cb = tree_cb("prev_sibling") },
				{ key = ">",                            cb = tree_cb("next_sibling") },
				{ key = "P",                            cb = tree_cb("parent_node") },
				{ key = "<BS>",                         cb = tree_cb("close_node") },
				{ key = "<S-CR>",                       cb = tree_cb("close_node") },
				-- { key = "<Tab>",                        cb = tree_cb("preview") },
				{ key = "K",                            cb = tree_cb("first_sibling") },
				{ key = "J",                            cb = tree_cb("last_sibling") },
				{ key = "I",                            cb = tree_cb("toggle_ignored") },
				{ key = "H",                            cb = tree_cb("toggle_dotfiles") },
				{ key = "R",                            cb = tree_cb("refresh") },
				{ key = "a",                            cb = tree_cb("create") },
				{ key = "d",                            cb = tree_cb("remove") },
				{ key = "r",                            cb = tree_cb("rename") },
				{ key = "<C-r>",                        cb = tree_cb("full_rename") },
				{ key = "x",                            cb = tree_cb("cut") },
				{ key = "c",                            cb = tree_cb("copy") },
				{ key = "p",                            cb = tree_cb("paste") },
				{ key = "y",                            cb = tree_cb("copy_name") },
				{ key = "Y",                            cb = tree_cb("copy_path") },
				{ key = "gy",                           cb = tree_cb("copy_absolute_path") },
				{ key = "[c",                           cb = tree_cb("prev_git_item") },
				{ key = "]c",                           cb = tree_cb("next_git_item") },
				{ key = "-",                            cb = tree_cb("dir_up") },
				{ key = "s",                            cb = tree_cb("system_open") },
				{ key = "q",                            cb = tree_cb("close") },
				{ key = "g?",                           cb = tree_cb("toggle_help") },
			}
		}
	}
}
vim.api.nvim_exec([[
    " hi NvimTreeNormal guibg=#222222
    " hi NvimTreeCursorLine guibg=#7c7cff guifg=#222222
    " hi NvimTreeNormal guibg=#2d313b
    " hi NvimTreeRootFolder guifg=#778399
    " hi NvimTreeIndentMarker guifg=#778399
    " hi NvimTreeFolderIcon guifg=#abb2bf guibg=#2d313b
    " hi NvimTreeFolderName guifg=#abb2bf guibg=#2d313b
    " hi NvimTreeOpenedFolderName guifg=#abb2bf guibg=#2d313b
  ]], false)
