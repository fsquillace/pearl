
"""""""""""""""""""
" Nerd Commenter
"""""""""""""""""""
map <C-,> <Leader>c<Space>

" Mappings used for completions when type . char
"imap <silent> <buffer> . .<C-X><C-O>
"imap <silent> <expr> <buffer> <CR> pumvisible() ? "<CR><C-R>=(col('.')-1&&match(getline(line('.')), '\\.',
      "\ col('.')-2) == col('.')-2)?\"\<lt>C-X>\<lt>C-O>\":\"\"<CR>"
      "\ : "<CR>"
