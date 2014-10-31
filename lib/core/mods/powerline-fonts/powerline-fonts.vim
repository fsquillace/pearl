
let &guifont=system('find ~/.fonts -maxdepth 1 -type l | head -n 1 | sed -e "s/.*\///" -e "s/\.ttf//" -e "s/\.otf//"')
