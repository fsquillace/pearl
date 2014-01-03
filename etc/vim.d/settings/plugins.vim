
""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pathogen (https://github.com/tpope/vim-pathogen)
""""""""""""""""""""""""""""""""""""""""""""""""""""
source $PEARL_ROOT/etc/vim.d/plugins/pathogen/autoload/pathogen.vim
filetype off
call pathogen#infect($PEARL_ROOT.'/etc/vim.d/plugins/{}', $PEARL_ROOT.'/mods/{}')
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

"""""""""""""""
" Solarized
"""""""""""""""
let g:solarized_contrast = "low"
let g:solarized_visibility= "normal"

""""""""""""""""
" Fugitive
""""""""""""""""
if filereadable($PEARL_ROOT."/mods/vim-fugitive/.git")
    source $PEARL_ROOT/etc/vim.d/settings/fugitive.vim
endif

"""""""""""""""
" Airline
"""""""""""""""
if filereadable($PEARL_ROOT."/mods/vim-airline/.git")
    source $PEARL_ROOT/etc/vim.d/settings/airline.vim
endif

"""""""""""""""
" Python-mode
"""""""""""""""
if filereadable($PEARL_ROOT."/mods/vim-python-mode/.git")
    source $PEARL_ROOT/etc/vim.d/settings/python-mode.vim
endif

""""""""""""""""""
" Jedi-vim
""""""""""""""""""
if filereadable($PEARL_ROOT."/mods/vim-jedi/.git")
    source $PEARL_ROOT/etc/vim.d/settings/jedi.vim
endif

