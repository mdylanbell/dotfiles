ZSHRC_D=$XDG_CONFIG_HOME/zsh/.zshrc.d

for conf in path aliases colors xdg; do
    [ -s "$ZSHRC_D/${conf}.zsh" ] && \. $ZSHRC_D/${conf}.zsh
done
