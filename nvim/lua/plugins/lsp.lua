return {
  {
    'chrisgrieser/nvim-lsp-endhints',
    event = { 'LspAttach' },
    config = function()
      require('lsp-endhints').setup({})
    end,
  },
}
