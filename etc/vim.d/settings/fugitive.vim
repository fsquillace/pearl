  " Allow to delete blob files in buffer when browsing into past commits
  if has("autocmd")
      autocmd BufReadPost fugitive://* set bufhidden=delete
      autocmd User fugitive
        \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
        \   nnoremap <buffer> .. :edit %:h<CR> |
        \ endif
  endif
  " Update the statusline for placing the current branch name
  set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
