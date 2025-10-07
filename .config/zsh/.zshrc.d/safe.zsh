ZSHRC_D=$XDG_CONFIG_HOME/zsh/.zshrc.d

for conf in xdg path aliases; do
    [ -s "$ZSHRC_D/${conf}.zsh" ] && \. $ZSHRC_D/${conf}.zsh
done
