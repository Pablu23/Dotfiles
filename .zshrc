autoload -Uz compinit
compinit

HISTFILE=~/.zsh_history
SAVEHIST=1000
HISTSIZE=1000

bindkey '^R'    history-incremental-search-backward
bindkey '^r' history-incremental-pattern-search-backward

setopt hist_ignore_dups
setopt appendhistory
unsetopt beep

# zstyle :compinstall filename '/home/zam/.zshrc'
export EDITOR='nvim'
alias vim='nvim'
alias hx='helix'
alias cd='z'
alias ls='eza --icons=always'

path+=('/home/zam/Projects/Odin')
path+=('/home/zam/android-studio/bin')
path+=('/home/zam/webstorm/bin')
path+=('/home/zam/go/bin')
path+=('/home/zam/.cache/rebar3/bin')

path+=('/home/zam/zig/zig-x86_64-linux-0.15.1')
path+=('/home/zam/zig/zls-0.15.1')

export path

type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

eval "$(zoxide init zsh)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

fastfetch

. "$HOME/.local/bin/env"

# pnpm
export PNPM_HOME="/home/zam/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
