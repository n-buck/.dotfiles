 COMPLETION_WAITING_DOTS="true"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias ydl="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0"
alias vi="vim"
alias rmvi="rm *~" #remove all vim-backup files
alias mbericht="pdflatex bericht.tex && biber bericht && makeglossaries bericht && pdflatex bericht.tex"
alias makecv="pdflatex lebenslauf.tex && pdflatex lebenslauf.tex && pdftk lebenslauf.pdf cat 2-end output CV.pdf && pdftk lebenslauf.pdf cat 1 output Letter.pdf && rm lebenslauf.out lebenslauf.aux lebenslauf.pdf lebenslauf.log"
alias lyrics="find . -exec lyric.sh {} \;"

export PATH=$HOME/.scripts:$PATH
export PATH=$HOME/.bin:$PATH
