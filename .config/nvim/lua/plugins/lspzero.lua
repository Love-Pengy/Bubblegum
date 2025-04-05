return {
  'williamboman/mason.nvim',
  config = function(opts)
    --   ---
    --   -- LSP setup
    --   ---
    --   local lsp_zero = require('lsp-zero')
    --
    --   -- lsp_attach is where you enable features that only work
    --   -- if there is a language server active in the file
    --   local lsp_attach = function(client, bufnr)
    --     local opts = { buffer = bufnr }
    --
    --     vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    --     vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    --     vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    --     vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    --     vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    --     vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    --     vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    --     vim.keymap.set('n', '<leader>gr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    --     vim.keymap.set({ 'n', 'x' }, '<leader>gf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    --     vim.keymap.set('n', 'ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    --   end
    --
    local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = hl,
      })
    end

    vim.diagnostic.config({
      virtual_text = {
        prefix = "󰻀",
      },
      underline = false,
      update_in_insert = true,
      severity_sort = true,
    })

    require('mason').setup({})
  end
}
