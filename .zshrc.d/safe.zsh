ZSHRC_D=$HOME/.zshrc.d/

for conf in secrets path aliases colors; do
    [ -s "$ZSHRC_D/${conf}.zsh" ] && \. $ZSHRC_D/${conf}.zsh
done
