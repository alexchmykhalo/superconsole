prompt off
AGKOZAK_CMD_EXEC_TIME=1
AGKOZAK_COLORS_CMD_EXEC_TIME="green"
AGKOZAK_CMD_EXEC_TIME_CHARS=( ' ' ' ☕' )
AGKOZAK_USER_HOST_DISPLAY=0
AGKOZAK_LEFT_PROMPT_ONLY=1
AGKOZAK_MULTILINE=0
AGKOZAK_PROMPT_DIRTRIM=1
source /3rdparty/agkozak-zsh-theme-master/agkozak-zsh-theme.plugin.zsh

# Make /c/... autocompletion work, see Alexpux/MSYS2-packages#38
zstyle ':completion:*' fake-files /: '/:c' '/:d'

export EDITOR='nano'
export COLORTERM=yes
export TERMINFO=/usr/lib/terminfo

source /3rdparty/command-not-found-msys2

set_conemu_cwd() { $ConEmuBaseDir/ConEmuC.exe -StoreCWD }
precmd_functions+=set_conemu_cwd

if [ -f "$HOME/.first-run" ]; then
	cd $HOME
	rm .first-run
fi

source /3rdparty/ohmyzsh-master/plugins/ssh-agent/ssh-agent.plugin.zsh

