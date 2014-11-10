function post_install(){
    mkdir -p ~/.fonts
    local root_path="${PEARL_ROOT}/mods/misc/powerline-fonts/"
    local default_font="DejaVuSansMono/DejaVu Sans Mono for Powerline.ttf"

    OLD_PWD=$(pwd)
    builtin cd "$root_path"
    echo
    echo "List of the font files in $root_path:"
    find . -name "*.ttf" | sed -e 's/\.\///'
    find . -name "*.otf" | sed -e 's/\.\///'
    echo
    builtin cd "$OLD_PWD"

    local res
    read -p "Type the path of the font file you want (default: $default_font)> " res

    [ "$res" == "" ] && res="${default_font}"
    local font_name=$(echo "$res" | sed -e 's/.*\///' -e 's/\.ttf//' -e 's/\.otf//')
    local font_file="${root_path}${res}"

    if [ ! -e "${font_file}" ]
    then
        error "Error the font file ${font_file} does not exist"
        return 1
    fi
    ln -s "${font_file}" ~/.fonts
    fc-cache -vf ~/.fonts

    local default_size="22"
    local res
    read -p "Type the pixelsize (default: $default_size)> " res
    [ "$res" == "" ] && res="${default_size}"

    apply "urxvt.font: xft:$font_name:pixelsize=${res}:antialias=true:hinting=true" "${HOME}/.Xdefaults" false

    info "You may need to restart the X server"
    return 0
}

function pre_uninstall(){
    local root_path="${PEARL_ROOT}/mods/misc/powerline-fonts/"
    builtin cd "$root_path"
    local ttf_list="$(find . -name "*.ttf" | sed -e 's/.*\///' -e 's/\.ttf//')"
    local otf_list=$(find . -name "*.otf" | sed -e 's/.*\///' -e 's/\.otf//')
    local total_list="${ttf_list}\n${otf_list}"
    builtin cd "$OLDPWD"

    ORIG_IFS=$IFS        # Save the original IFS
    IFS=$'\n'$'\r'  # For splitting input into lines
    for font_name in $(echo -e "$total_list")
    do
        local real_name=$(echo "$font_name" | sed 's/ /\ /g')
        rm ~/.fonts/${real_name}.ttf &> /dev/null
        rm ~/.fonts/${real_name}.otf &> /dev/null
        unapply "urxvt.font: xft:$font_name:pixelsize=22:antialias=true:hinting=true" "${HOME}/.Xdefaults"
    done
    IFS=$ORIG_IFS

    fc-cache -vf ~/.fonts

    info "You may need to restart the X server"
    return 0
}
