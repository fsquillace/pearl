
" Fake airline as loaded if not running gui
if has('gui_running')
    let g:airline_enable_fugitive=1
    let g:airline_enable_syntastic=1
    let g:airline_theme='dark'
    let g:airline_powerline_fonts=1
    " link the inconsolata font
    silent execute '!mkdir -p ~/.fonts'
    silent execute '![ -f ~/.fonts/inconsolata_powerline.otf ] || ln -s $PEARL_ROOT/etc/fonts/inconsolata_powerline.otf ~/.fonts/'
    set guifont=Inconsolata\ for\ Powerline
else
    let g:loaded_airline=1
endif
