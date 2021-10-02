source /3rdparty/antigen.zsh

antigen use oh-my-zsh
antigen bundle ssh-agent
#antigen bundle pip
#antigen bundle pyenv
#antigen bundle python
#antigen bundle encode64
#antigen bundle jsontools
#antigen bundle urltools

#antigen-bundle Tarrasch/zsh-autoenv
#ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd)
#ZSH_AUTOSUGGEST_USE_ASYNC=1
antigen bundle zsh-users/zsh-autosuggestions
#antigen bundle MichaelAquilina/zsh-autoswitch-virtualenv
#antigen bundle unixorn/bitbucket-git-helpers.plugin.zsh
#antigen bundle 0b10/cheatsheet
#antigen bundle psprint/zsh-navigation-tools
#antigen bundle psprint/zsh-cmd-architect
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zdharma/fast-syntax-highlighting
#antigen bundle chipsenkbeil/zsh-notes
antigen bundle sinetoami/web-search
#antigen bundle srijanshetty/zsh-pandoc-completion
#antigen bundle srijanshetty/zsh-pip-completion

prompt off
AGKOZAK_CMD_EXEC_TIME=3
AGKOZAK_COLORS_CMD_EXEC_TIME="green"
AGKOZAK_CMD_EXEC_TIME_CHARS=( ' ' ' ☕' )
AGKOZAK_USER_HOST_DISPLAY=0
AGKOZAK_LEFT_PROMPT_ONLY=1
AGKOZAK_MULTILINE=0
AGKOZAK_PROMPT_DIRTRIM=1
antigen bundle agkozak/agkozak-zsh-prompt

antigen apply

# Git is very on Windows, so we disable highlighting
FAST_HIGHLIGHT[chroma-git]=

# Make /c/... autocompletion work, see Alexpux/MSYS2-packages#38
zstyle ':completion:*' fake-files /: '/:c' '/:d'

export EDITOR='nano'
export COLORTERM=yes
export TERMINFO=/usr/lib/terminfo
export PYTHONIOENCODING=UTF-8

source /3rdparty/command-not-found-msys2

set_conemu_cwd() { $(cygpath -u  $ConEmuBaseDir/ConEmuC.exe) -StoreCWD }
precmd_functions+=set_conemu_cwd

alias "superconsole=source /3rdparty/superconsole"
