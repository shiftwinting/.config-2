local nvim_lsp = require"lspconfig"
local protocol = require"vim.lsp.protocol"
local opts = { noremap = true, silent = true }

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        fn.winrestview(view)
        vim.api.nvim_command("noautocmd :update")
    end
end

-- Diagnostics
-- require("nvim-ale-diagnostic") -- WAS.. USING ALE TO DISPLAY DIAGS
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
	virtual_text = {
	  prefix = "»",
	  spacing = 4,
	},
    signs = true,
    update_in_insert = false,
  }
)

-- lspsaga
local saga = require 'lspsaga'
saga.init_lsp_saga()
vim.cmd [[
	nnoremap <silent> gh :Lspsaga lsp_finder<CR>
]]

local signs = { Error = "✘", Warning = "", Hint = "", Information = "" }

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- DISPLAY DIAGNOSTICS IN THE COMMAND BAR
-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
local last_echo = { false, -1, -1 }

-- The timer used for displaying a diagnostic in the commandline.
local echo_timer = nil

-- The timer after which to display a diagnostic in the commandline.
local echo_timeout = 250

-- The highlight group to use for warning messages.
local warning_hlgroup = 'WarningMsg'

-- The highlight group to use for error messages.
local error_hlgroup = 'ErrorMsg'

-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

-- Shows the current line's diagnostics in a floating window.
function show_line_diagnostics()
  vim
    .lsp
    .diagnostic
    .show_line_diagnostics({ severity_limit = 'Warning' }, vim.fn.bufnr(''))
end

-- Prints the first diagnostic for the current line.
function echo_diagnostic()
  if echo_timer then
    echo_timer:stop()
  end

  echo_timer = vim.defer_fn(
    function()
      local line = vim.fn.line('.') - 1
      local bufnr = vim.api.nvim_win_get_buf(0)

      if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
        return
      end

      local diags = vim
        .lsp
        .diagnostic
        .get_line_diagnostics(bufnf, line, { severity_limit = 'Warning' })

      if #diags == 0 then
        -- If we previously echo'd a message, clear it out by echoing an empty
        -- message.
        if last_echo[1] then
          last_echo = { false, -1, -1 }

          vim.api.nvim_command('echo ""')
        end

        return
      end

      last_echo = { true, bufnr, line }

      local diag = diags[1]
      local width = vim.api.nvim_get_option('columns') - 15
      local lines = vim.split(diag.message, "\n")
      local message = lines[1]
      local trimmed = false

      if #lines > 1 and #message <= short_line_limit then
        message = message .. ' ' .. lines[2]
      end

      if width > 0 and #message >= width then
        message = message:sub(1, width) .. '...'
      end

      local kind = 'warning'
      local hlgroup = warning_hlgroup

      if diag.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
        kind = 'error'
        hlgroup = error_hlgroup
      end

      local chunks = {
        { kind .. ': ', hlgroup },
        { message }
      }

      vim.api.nvim_echo(chunks, false, {})
    end,
    echo_timeout
  )
end
vim.cmd("autocmd CursorMoved * :lua echo_diagnostic()")


local map_key = vim.api.nvim_set_keymap
local opts = {silent=true, noremap=true}
-- saga.buildin
--map_key('n', '<C-u>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]], opts)
--map_key('n', '<C-d>', [[<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]], opts)

--map_key('n', '<LEADER>rn', [[<cmd>lua require('lspsaga.rename').rename()<CR>]], opts)
--map_key('n', 'gd', [[<cmd>lua require("utils.functions").smart_split('lua vim.lsp.buf.definition()')<CR>]], opts)
--map_key('n', 'gD', [[<cmd>lua require'lspsaga.provider'.preview_definition()<CR>]], opts)
--map_key('n', 'gh', [[<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>]], opts)
--map_key('n', '<LEADER>h', [[<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]], opts)
--map_key('n', '<LEADER>a', [[<cmd>lua require('lspsaga.codeaction').code_action()<CR>]], opts)
--map_key('v', '<LEADER>a', [[<cmd>'<,'>lua require('lspsaga.codeaction').range_code_action()<CR>]], opts)
map_key('n', '[g', [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>]], opts)
map_key('n', ']g', [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>]], opts)
--vim.cmd [[command! Format lua vim.lsp.buf.formatting()]]

-- vsnip
vim.g.vsnip_snippet_dir = os.getenv('HOME') .. "/.config/nvim/snippets"

local map_key = vim.api.nvim_set_keymap
local opts = {expr=true}
map_key('i', '<Tab>', [[vsnip#available()  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>']], opts)
map_key('s', '<Tab>', [[vsnip#available()  ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>']], opts)

map_key('s', '<C-l>', [[vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)' : '<C-l>']], opts)
map_key('s', '<C-j>', [[vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)' : '<C-j>']], opts)

require "lsp_signature".setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	handler_opts = {
		border = "single"
	}
})

local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    --map("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
    --map("n", "gk", ":lua vim.lsp.buf.definition()<CR>", opts)
    --map("n", "gh", ":lua vim.lsp.buf.hover()<CR>", opts)
    --map("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opts)
    --map("n", "gn", ":lua vim.lsp.buf.rename()<CR>", opts)
    --map("n", "gr", ":lua vim.lsp.buf.references()<CR>", opts)
    --map("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", opts)
    --map("n", "<leader>D", ":lua vim.lsp.buf.type_definition()<CR>", opts)
    --map("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", opts)
    --map("n", "<leader>e", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    --map("n", "d[", ":lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    --map("n", "d]", ":lua vim.lsp.diagnostic.goto_next()<CR>", opts)

    map("i", "<C-Space>", "compe#complete()", {noremap=true,silent=true,expr=true})
    map("i", "<Tab>", "compe#confirm('<Tab>')", {noremap=true,silent=true,expr=true})
    map("i", "<C-e>", "compe#close('<C-e>')", {noremap=true,silent=true,expr=true})
    map("i", "<C-f>", "compe#scroll({'delta': +4 })", {noremap=true,silent=true,expr=true})
    map("i", "<C-d>", "compe#scroll({'delta': -4 })", {noremap=true,silent=true,expr=true})
end

-- NVIM COMPE
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
  };
}

-- LSPINSTALL
local function setup_servers()
    require"lspinstall".setup()
    local servers = require'lspinstall'.installed_servers()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }
    for _, server in pairs(servers) do
        require"lspconfig"[server].setup{
            on_attach = function(client, bufnr) print("'"..server.."' launched"); on_attach(client, bufnr) end,
            capabilities = capabilities,
        }
    end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
    setup_servers() -- reload installed servers
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
