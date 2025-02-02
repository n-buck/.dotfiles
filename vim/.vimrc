"#######################################################################
" ~/.vimrc
" vim Konfigurationsdatei
"#######################################################################
set grepprg=grep\ -nH\ $*
set nocompatible
set nrformats-=octal
" Color, powerline, syntax-higlight                                                     {{{
"colorscheme default  " Farbschema
colorscheme desert  " Farbschema
"colorscheme gotham " Farbschema
syntax on         " Code farbig darstellen
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
"Powerline
set laststatus=2
"ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_lint_on_insert_leave = 1
" youCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_server_python_interpreter = '/usr/bin/python'
map c-g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
"                                                                                       }}}
" Settings and maps                                                                     {{{
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
set relativenumber | set number " Curserline ist immer 0
set splitright      "new Splits are right
set foldmethod=syntax "automatic folding
"let mapleader="<"   "changes the leader
autocmd InsertEnter * :set norelativenumber | set number " change back to absolute numbers
autocmd InsertLeave * :set relativenumber " Automatisch relative numbers im Insert-mode
"#######################################################################
" Makros
"map <F12> :w!<CR>:!aspell --lang=de check %<CR>:e! %<CR>
"map <F5> :w! <CR>:! pdflatex % <CR>

map <leader>hex :%!xxd<CR>        " Hexeditor mit \hex starten
map <leader>nhex :%!xxd -r<CR>    " Hexeditor mit \nhex beenden

map <F2> i########################################################################<CR><ESC>
map <F3> :r!date +\%Y-\%m-\%d<CR>
map <F4> :r!date +\%Y-\%m-\%d_\%H-\%M-\%S<CR>

"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"                                                                                       }}}
" Spell-Checking                                                                        {{{
" Wann geladen wird              # Maske   # Aktivieren      # Zu verwendende Sprache
"au BufNewFile,BufRead,BufEnter   *.md      setlocal spell    spelllang=de_de
"au BufNewFile,BufRead,BufEnter   *.txt     setlocal spell    spelllang=en_us
"au BufNewFile,BufRead,BufEnter   *.tex     setlocal spell    spelllang=de_de
"au BufNewFile,BufRead,BufEnter   README    setlocal spell    spelllang=en_us
"                                                                                       }}}
" python defaults                                                                        {{{
let python_highlight_all=1
au BufNewFile,BufRead *.py
    \ set tabstop=4         |
    \ set softtabstop=4     |
    \ set shiftwidth=4      |
    \ set expandtab         |
    \ set autoindent        |
    \ set fileformat=unix   |

"                                                                                       }}}
" LaTeX                                                                                 {{{
let g:tex_flavor = "latex"
au BufNewFile,BufRead *.tex
    \ set expandtab!
" tex-cls
au BufNewFile,BufRead *.cls set filetype=tex
"                                                                                       }}}
" web default                                                                           {{{
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
" EOF
" vim: foldmethod=marker
