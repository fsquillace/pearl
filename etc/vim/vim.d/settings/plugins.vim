
""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pathogen (https://github.com/tpope/vim-pathogen)
""""""""""""""""""""""""""""""""""""""""""""""""""""
source $PEARL_ROOT/etc/vim/vim.d/plugins/pathogen/autoload/pathogen.vim
filetype off
call pathogen#infect($PEARL_ROOT.'/etc/vim/vim.d/plugins/{}', $PEARL_ROOT.'/mods/{}', $PEARL_ROOT.'/mods/powerline/bindings/vim/{}')
call pathogen#helptags()
filetype plugin indent on
syntax on

"""""""""""""""""""
" Nerd Commenter
"""""""""""""""""""
map <C-,> <Leader>c<Space>

""""""""""""""""""
" BufExplorer
""""""""""""""""""
map <Leader>b :BufExplorer<CR>
map <Leader>v :BufExplorerVerticalSplit<CR>
map <Leader>h :BufExplorerHorizontalSplit<CR>


" Mappings used for completions when type . char
"imap <silent> <buffer> . .<C-X><C-O>
"imap <silent> <expr> <buffer> <CR> pumvisible() ? "<CR><C-R>=(col('.')-1&&match(getline(line('.')), '\\.',
      "\ col('.')-2) == col('.')-2)?\"\<lt>C-X>\<lt>C-O>\":\"\"<CR>"
      "\ : "<CR>"

""""""""""""""""""""""""""""
" SuperTab
""""""""""""""""""""""""""""
" Makes all types of completions!!
let g:SuperTabDefaultCompletionType = "context"
" for spell correction <c-x>s or for thesaurus <c-x><c-t>
let g:SuperTabContextDefaultCompletionType = "<c-n>"

for config_path in split(globpath($PEARL_ROOT."/lib/core/mods/*", '*.vim'), "\n")
    let config = substitute(substitute(config_path, "^.*\/", "", ""), "\.vim", "", "")
    if filereadable($PEARL_ROOT."/mods/".config."/.git")
        if filereadable(config_path)
            :exec ":source ".config_path
        endif
    endif
endfor


