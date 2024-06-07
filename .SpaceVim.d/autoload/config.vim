func! config#before() abort
  set mouse=a
  let g:mapleader = ','
  let g:smartim_default = 'com.apple.keylayout.ABC'
  " after this line, when you using <leader> to defind key bindings
  " the leader is ,
  " for example:
  " nnoremap <leader>w :w<cr>
  imap jk <esc>
  " this mapping means using `,w` to save current file.
endf

func! config#after() abort
  " do nothing
endf
