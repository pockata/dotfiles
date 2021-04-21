imap('<C-j>', '<expr>', [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '']])
smap('<C-j>', '<expr>', [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '']])
imap('<C-k>', '<expr>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '']])
smap('<C-k>', '<expr>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '']])

