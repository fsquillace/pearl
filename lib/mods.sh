

function ranger_config(){
    # Here you can put the settings for ranger module
    return 0
}

[ "$(ls -A "$PEARL_ROOT/mods/ranger")" ] && ranger_config


unset ranger_config
