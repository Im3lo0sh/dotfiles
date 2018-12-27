export MESA_GL_VERSION_OVERRIDE=4.5
export MESA_GLSL_VERSION_OVERRIDE=450
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    export LANG="en_US.UTF-8"
#    export allow_rgb10_configs=false
    exec startx
fi
