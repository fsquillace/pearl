
let g:airline_enable_fugitive=1
let g:airline_enable_syntastic=3
let g:airline_theme='dark'
let g:airline_powerline_fonts=1
set laststatus=2

" link the inconsolata font
silent execute '!mkdir -p ~/.fonts'
silent execute '![ -f ~/.fonts/inconsolata_powerline.otf ] || ln -s $PEARL_ROOT/etc/fonts/inconsolata_powerline.otf ~/.fonts/'
set guifont=Inconsolata\ for\ Powerline
