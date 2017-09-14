"#######################################################################
"
" ~/.vimrc
" vim Konfigurationsdatei
"
" Copyright 2011 Emanuel Duss
" Licensed under GNU General Public License
"
" 2010-06-19; Emanuel Duss; Erste Version
" 2011-02-08; Emanuel Duss; Neu: set list; set listchars
" 2011-02-14; Emanuel Duss; Neu: endocing=utf8
"
"#######################################################################
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
"#######################################################################
" Einstellungen
set nocompatible   " VIM-Zusätze aktivieren
set encoding=utf8  " UTF8 als Zeichensatz
set mouse=a        " Mausunterstüzung aktivieren
" set number         " Zeilennummern angeben ersetzt durch set relativenumber
set incsearch      " Zeigt Suchergebnisse während dem Suchen an
set hlsearch       " Suchresultate farbig hervorheben
set ignorecase     " Ignoriert Gross/Kleinschreibung beim Suchen
set smartcase      " Nur Gross/Kleinschreibung beachten, wenn Grossbuchstabe vorhanden
set autoread       " Liest die Datei neu, wenn ausserhalb von VIM geändert.
set backup         " Erstellt eine Backup-Datei
set tabstop=2      " Tabulator entspricht 2 Leerzeichen
set softtabstop=2  " Weicher Tabulator
set shiftwidth=2   " Einrücktiefe
set autoindent     " Automatisch einrücken
set expandtab      " Tabulatoren in Spaces umwandeln
set wrap           " Zeilenumbruch aktivieren
set list           " listchars anzeigen
set listchars=tab:»·,trail:· " Tabs und Leerzeichen am Zeilenende anzeigen
set relativenumber " Curserline ist immer 0
autocmd InsertEnter * :set norelativenumber | set number " change back to absolute numbers
autocmd InsertLeave * :set relativenumber " Automatisch relative numbers im Insert-mode

"colorscheme default  " Farbschema
colorscheme desert  " Farbschema
"colorscheme gotham " Farbschema

syntax on         " Code farbig darstellen

set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
filetype plugin indent on
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"


"#######################################################################
" Makros
"map <F12> :w!<CR>:!aspell --lang=de check %<CR>:e! %<CR>
"map <F5> :w! <CR>:! pdflatex % <CR>

map <leader>hex :%!xxd<CR>        " Hexeditor mit \hex starten
map <leader>nhex :%!xxd -r<CR>    " Hexeditor mit \nhex beenden

map <F2> i########################################################################<CR><ESC>
map <F3> :r!date +\%Y-\%m-\%d<CR>
map <F4> :r!date +\%Y-\%m-\%d_\%H-\%M-\%S<CR>

" EOF
