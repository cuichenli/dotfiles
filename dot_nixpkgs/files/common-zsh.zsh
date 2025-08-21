export EDITOR=nvim
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ${HOME}/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Disable async prompt as it is not working with zinit at the moment
zstyle ':omz:alpha:lib:git' async-prompt no

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
## Oh My Zsh Setting
ZSH_THEME="robbyrussell"

## Zinit Setting
# Must Load OMZ Git library
zi snippet OMZL::git.zsh


# Load Git plugin from OMZ
zi snippet OMZP::git
zi snippet OMZP::fzf
zi snippet OMZP::kubectl
zi cdclear -q # <- forget completions provided up to this moment

setopt promptsubst

# Load Prompt
zi snippet OMZT::robbyrussell

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# The following configurations regarding history are from https://martinheinz.dev/blog/110
# https://zsh.sourceforge.io/Doc/Release/Options.html (16.2.4 History)

setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

HISTORY_IGNORE="(ls|cd|pwd|exit|cd)*"

# Strange issue similar to https://github.com/JanDeDobbeleer/oh-my-posh/issues/2999
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search    # Arrow up
bindkey "^[[B" down-line-or-beginning-search  # Arrow down
eval "$(zoxide init zsh)"


export PATH="/home/cuichli/.asdf/shims:$PATH"
source ~/.asdf/plugins/java/set-java-home.zsh
