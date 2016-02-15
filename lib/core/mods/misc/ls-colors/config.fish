eval (dircolors -b $PEARL_ROOT/mods/misc/ls-colors/LS_COLORS | sed -e '2d' -e 's/^LS_/set LS_/' -e 's/=/ /' )

# vim: ft=fish
