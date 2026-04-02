if [[ -r $HOME/.ssh/config ]]; then
  local -aU ssh_completion_hosts
  local host_line host_name

  while IFS= read -r host_line; do
    for host_name in ${(z)host_line}; do
      [[ $host_name == [!#]* ]] || continue
      [[ $host_name == [!\*?]* ]] || continue
      ssh_completion_hosts+=("$host_name")
    done
  done < <(sed -nE 's/^[[:space:]]*[Hh]ost[[:space:]]+(.+)$/\1/p' "$HOME/.ssh/config")

  if (( ${#ssh_completion_hosts[@]} )); then
    zstyle ':completion:*:hosts' hosts "${ssh_completion_hosts[@]}"
    zstyle ':completion:*:(ssh|scp|rsync):*' tag-order \
      'hosts:-host:host' \
      'hosts:-domain:domain' \
      'hosts:-ipaddr:ip address' \
      '*'
    zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
    zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
    zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns \
      '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' \
      '127.0.0.<->' \
      '255.255.255.255' \
      '::1' \
      'fe80::*'
  fi
fi
