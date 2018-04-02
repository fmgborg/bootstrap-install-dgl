" We use a vim
set nocompatible
"
" Colo(u)red or not colo(u)red
" If you want color you should set this to true
"
" fmg
" let color = "false"
let color = "true"
" /fmg
"
if has("syntax")
    if color == "true"
	" This will switch colors ON
	so ${VIMRUNTIME}/syntax/syntax.vim
    else
	" this switches colors OFF
	syntax off
	set t_Co=0
    endif
endif
" ~/.vimrc ended here until 20040821
" fmg 20040821
"au FileType mail exe 'norm 1G}2jVGgq'

" fmg 20050922
"autocmd! FileType html imap
"autocmd FileType html imap "a ä
"autocmd FileType html imap ä &auml;
"autocmd FileType html imap Ä &Auml;
"autocmd FileType html imap ö &ouml;
"autocmd FileType html imap Ö &Ouml;
"autocmd FileType html imap ü &uuml;
"autocmd FileType html imap Ü &Uuml;
"autocmd FileType html imap ß &szlig;
"autocmd FileType html so ~/.vim/imap-html.vim
" unmap ä
" autocmd!
"imap ä ae
"iunmap ä
if has("autocmd")
    autocmd BufNewFile,Bufread *.html,*.htm,*.shtml,*.php source ~/.vim/imap-html.vim
    autocmd BufEnter *.html,*.htm,*.shtml,*.php source ~/.vim/imap-html.vim
    autocmd BufLeave *.html,*.htm,*.shtml,*.php source ~/.vim/iunmap-html.vim
    autocmd BufEnter *.inc source ~/.vim/imap-html.vim
    autocmd BufLeave *.inc source ~/.vim/iunmap-html.vim
    autocmd BufEnter *.xml source ~/.vim/imap-xml.vim
    autocmd BufLeave *.xml source ~/.vim/iunmap-xml.vim
"
    autocmd BufNewFile,Bufread *.tex source ~/.vim/imap-tex.vim
    autocmd BufEnter *.tex source ~/.vim/imap-tex.vim
    autocmd BufLeave *.tex source ~/.vim/iunmap-tex.vim
endif

" http://www.nitidelo.de/vimrc.htm
" http://www-user.tu-chemnitz.de/~mrob/vimrc
" http://www.jauu.net/data/dotfiles/vimrc.html
" http://theorem.ca/~mvcorks/vim/vimrc
" http://goanna.cs.rmit.edu.au/~bodob/.vimrc " mit iunmap
" http://phuzz.org/vimrc.html
" http://www.xs4all.nl/~hanb/configs/dot-vimrc
" http://www.darksmile.net/software/.vimrc.html
" http://www.lodestar2.com/software/docbook/vimrc

" Klammerzuordnung zeigen
set showmatch
" I like highlighted search pattern
set hlsearch

" colors murr mail quoting
source ~/.vim/colors/mutt-quotes.vim

vmap <F9> <ESC>:'<,'>!tr 'a-zA-Z' 'n-za-mN-ZA-M'<return>
"vmap <F8> <ESC>:'<,'>!tr '"' '&quot;'<return>
vmap <F8> <ESC>:'<,'>!sed s,'"','\&quot;',g<return>

"if (FileType() == "html")
"    imap ü &uuml
"endif
" ~/.vimrc ends here
