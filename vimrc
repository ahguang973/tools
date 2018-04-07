set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'
Plugin 'fatih/vim-go'
Plugin 'python-mode/python-mode'
Plugin 'vim-scripts/L9'
Plugin 'vim-scripts/FuzzyFinder'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'vim-scripts/taglist.vim'
" Plugin 'ervandew/eclim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" --------------- pymode ---------------------
let g:pymode = 1
let g:pymode_rope = 1
let g:pymode_rope_goto_definition_cmd = 'e'
let g:pymode_options_max_line_length = 120
function! Pymode_goto_definition(...)
  redir => msg
    silent! exec 'call pymode#rope#goto_definition()'
  redir END
  if (match(msg, 'Definition not found') >= 0)
    return 1
  else
    return 0
  endif
endfunction
" --------------- pymode ---------------------
" --------------- vim-go ---------------------
function! Vimgo_goto_definition(...)
  redir => msg
    silent! exec "call go#def#Jump('')"
  redir END
  if (match(msg, 'vim-go: /') >= 0)
    return 1
  else
    return 0
  endif
endfunction
" --------------- vim-go ---------------------

set nocompatible
set nu
syntax on
filetype on
filetype plugin on
filetype indent on
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set nofoldenable
set foldmethod=syntax
set nomore
set noprompt
set autoread
set ruler
set helplang=en
set nowrap
" set cst
set hlsearch
set updatetime=200
set completeopt=menu,longest,preview
set wildmode=longest,full
set wildmenu
set bg=dark
" skip scanning included file in vim complete
set complete-=i
"set fileencoding=utf-8,gb2312,gbk,gb18030
"set termencoding=utf-8
"set encoding=utf-8
highlight Normal guifg=White guibg=Black ctermfg=White ctermbg=Black
set guioptions-=m
set guioptions-=T
set guioptions-=R
set guifont=Courier_New:h10
set maxmempattern=4000

let g:javaScript_fold=1         " JavaScript
let g:perl_fold=1               " Perl
let g:php_folding=1             " PHP
let g:r_syntax_folding=1        " R
let g:ruby_fold=1               " Ruby
let g:sh_fold_enabled=1         " sh
let g:vimsyn_folding='af'       " Vim script
let g:xml_syntax_folding=1      " XML
let g:jsp_syntax_folding=1      " JSP
if (expand('%:p:e') == 'txt')
    setlocal fdm=indent
endif

"let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabClosePreviewOnPopupClose = 1

autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java setlocal completefunc=javacomplete#Complete

"------------------- ECLIM ------------------------------------
let g:EclimJavaSearchSingleResult = 'edit'
let g:EclimCSearchSingleResult = 'edit'
let g:EclimPythonSearchSingleResult = 'edit'
"------------------- ECLIM ------------------------------------

if (expand('%:p:e') == 'txt' || expand('%:t') == '.vimrc')
    set fdm=indent
endif

nnoremap q <NOP>
nmap qq :q<CR>
nmap qh :noh<CR>
nmap tt :tab split<CR>
nmap =- =i{

nmap t1 :tabfirst<CR>
nmap t2 t1gt
nmap t3 t2gt
nmap t0 :tablast<CR>

function! Qa_func(...)
	let l0 = line('.') - 1
	let l1 = line('.')
	exec ':' . l0 . ',' . l1 . 'Align'
endfunction
nmap qal :call Qa_func()<CR><CR>
nmap q= :call Qa_func()<CR><CR>
nmap q> :call Qa_func()<CR><CR>>>

nmap <C-h> <C-W>h
nmap <C-k> <C-W>k
nmap <C-l> <C-W>l
nmap <C-j> <C-W>j
nmap <F9> :TlistToggle<CR>
nmap Tl :TlistToggle<CR>
nmap Tf :FufTag<CR>
nmap TN :NERDTree<CR>

"autocmd VimEnter,VimLeave * silent !tmux set -g status off
 
" ---------- START: ctag and cscope browsing support ------------------------
"  params:
"  nocsp: don't include the csp cscope and ctags db
let s:csp = fnamemodify('.', ':p:h')
function! Set_mydb(...)
  if ('' != s:csp)
    if (filereadable(s:csp . '/cscope.out'))
      exec 'cs add ' . s:csp . '/cscope.out ' . s:csp. ' -R'
    endif
    if (filereadable(s:csp. '/tags'))
      let t = &tags
      if ('' == t)
        exec 'set tags=' . s:csp. '/tags'
      else
        exec 'set tags=' . t . ',' . s:csp. '/tags'
      endif
    endif
  endif
endfunction

"set cscope to a specific folder
function! CSP_func(...)
  if (0 == a:0)
    let s:csp = ''
  else
    let s:csp = fnamemodify(a:1, ':p:h')
  endif

  cs kill -1 
  exec 'set tags='
  call Set_mydb()
endfunction

" add cscope db
function! CSA_func(...)
  if (0 == a:0)
    let s:csp = ''
  else
    let s:csp = fnamemodify(a:1, ':p:h')
  endif

  call Set_mydb()
endfunction

command! -narg=* CSP call CSP_func(<f-args>)
command! -narg=* CSA call CSA_func(<f-args>)

exec 'set tags='
cs kill -1
call Set_mydb()

" build c ctags and cscope db
function! Build_mydb(...)
  exec 'cs kill -1'
  let cmd =       '!echo Rebuild; rm -f cscope.* tags;'
  let cmd = cmd . 'ctags --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q -R;'
  let cmd = cmd . 'cscope -bkqR;'

  exec cmd
  call Set_mydb()
endfunction

" build java ctags and cscope db
function! Build_mydb_java(...)
  exec 'cs kill -1'
  let cmd =       '!echo Rebuild; rm -f cscope.*;'
  if (a:0 > 0)
      let cmd = cmd . 'rm tags;'
      let cmd = cmd . 'ctags --sort=yes --language-force=java --fields=+iaS --extra=+q -R;'
  endif
  let cmd = cmd . 'find . -name "*.java" > cscope.files; cscope -bkq;'

  exec cmd
  call Set_mydb()
endfunction

" build go ctags and cscope db
function! Build_mydb_go(...)
  exec 'cs kill -1'
  let cmd =       '!echo Rebuild; rm -f cscope.*;'
  if (a:0 > 0)
      let cmd = cmd . 'rm tags;'
      let cmd = cmd . 'ctags --sort=yes --language-force=go -R;'
  endif
  let cmd = cmd . 'find . -name "*.go" > cscope.files; cscope -bkq;'

  exec cmd
  call Set_mydb()
endfunction

function! Build_mydb_python(...)
  exec 'cs kill -1'
  let cmd =       '!echo Rebuild; rm -f cscope.*;'
  if (a:0 > 0)
      let cmd = cmd . 'rm tags;'
      let cmd = cmd . 'ctags --sort=yes --fields=+l --languages=python --python-kinds=-iv -R;'
  endif
  let cmd = cmd . 'find . -name "*.py" > cscope.files; cscope -bkq;'

  exec cmd
  call Set_mydb()
endfunction
" ---------- END: ctag and cscope browsing support ------------------------

" ---------- START: Quickfix support for cscope browsing ------------------------
let s:qfopen = 0
let s:qffirstin = 0
function! QFE(...)
  if (s:qfopen)
    let s:qfopen = 0
    cclose
  else
    let s:qfopen = 1
    copen
  endif
endfunction
nmap qx :call QFE()<CR>

function! Qf_get_file(...)
  let f = a:1
  let f_p = fnamemodify(f, ':p')
  let f_d = fnamemodify(f_p, ':.')
  if (f_p != f_d)
    let f = f_d
  endif

  let f = substitute(f, '^\.\/', '', '')
  return f
endfunction

" get max f . l len
" a:1 list
function! Max_fl(...)
  let len_fl = 0
  for line in a:1
    if (match(line, '^\s\+\d\+\s\+\d\+') == 0)
      let f = Qf_get_file(substitute(line, '\(^\s\+\d\+\s\+\)\(\d\+\)\s\+\(\S\+\)\(.*\)', '\3', ''))
      let l = substitute(line, '\(^\s\+\d\+\s\+\)\(\d\+\)\s\+\(\S\+\)\(.*\)', '\2', '')
      let fl2 = strlen(f . l)
      if (fl2 > len_fl)
        let len_fl = fl2
      endif
    endif
  endfor
  return len_fl + 1
endfunction

" get max f . l len from qflist
" a:1 list
" a:2 start
" a:3 end
" exclude line in [start, end]
function! Min_fl_qf(...)
  let len_fl = 0
  for dd in a:1
    if (dd.lnum >= a:2 && dd.lnum <= a:3)
      continue
    endif
    let fl2 = strlen(Qf_get_file(bufname(dd.bufnr)) . dd.lnum)
    if (fl2 > len_fl)
      let len_fl = fl2
    endif
  endfor
  return len_fl + 1
endfunction

" The last line is not appended with \n !!!!!!!
" a:1 the message block returned from cs find x
" a:2 the fold level, 0 up
" a:3 the x in cs find x, for c now
" a:4 pad len
" a:5 keyword
function! Dump_msgs(...)
  let msgs = split(a:1, "\n")
  let f = ''
  let l = ''
  let cnt = 0
  let lastmatch = 0
  let rc = '' 
  let rc1 = ''

  for line in msgs
    let cnt = cnt + 1
    if (match(line, '^\s\+\d\+\s\+\d\+') == 0)
      let f = Qf_get_file(substitute(line, '\(^\s\+\d\+\s\+\)\(\d\+\)\s\+\(\S\+\)\(.*\)', '\3', ''))
      let l = substitute(line, '\(^\s\+\d\+\s\+\)\(\d\+\)\s\+\(\S\+\)\(.*\)', '\2', '')
      let last_c = substitute(line, '\(^.*<<\)\(.*\)\(>>.*\)', '\2', '')
      let lastmatch = 1

      let pad = repeat('-', a:4 - strlen(f . l))
      if (a:3 == 'f')
        if (rc != '')
          let rc = rc . "\n"
        endif
        let rc = rc . f . ':' . l . ':' . pad . '>' . printf('%.2d',a:2) . a:3 . repeat(' ', 4*(a:2+1))
        let lastmatch = 0
      endif
    else
      let old_lastmatch = lastmatch
      let lastmatch = 0
      if (1 == old_lastmatch)
        let pad = repeat('-', a:4 - strlen(f . l))

        let line = substitute(line, '\(^\s\+\)\(.*\)', '\2', '')

        " for tag ' ' or cs find g, we don't want the import and extents
        if ((expand('%:p:e') == 'java' || expand('%:p:e') == 'py') && (a:3 == ' ' || a:3 == 'g') && (match(line, 'import ') >= 0 || match(line, 'extends ' . a:5) >= 0))
            continue
        endif

        if (rc != '')
          let rc = rc . "\n"
        endif

        if (a:3 == 'c')
          let rc = rc . f . ':' . l . ':' . pad . '>' . printf('%.2d',a:2) . a:3 . repeat(' ', 4*(a:2+1)) . last_c . ' => ' . line 
        else
          let rc = rc . f . ':' . l . ':' . pad . '>' . printf('%.2d',a:2) . a:3 . repeat(' ', 4*(a:2+1)) . line . ' <= ' . last_c
        endif
      endif
    endif
  endfor

  return rc
endfunction

function! QF_level(...)
  return substitute(a:1, '^.*>\(\d\+\).*', '\1', '')
endfunction

" a:1 the message block
" a:2 for tag, it is '', trival
"     for cs, it is the character after find
"     a special 'r' is t remove the fold in qf window
" a:3 the keyword
function! My_QF(...)
  if (a:1 == '' && a:2 != 'r')
      return 0
  endif

  let msg = ''
  let len_fl = Max_fl(split(a:1, "\n"))
  let qf_pos = getpos('.')
  let l0 = -1

  if (&filetype != 'qf')
    let msg = Dump_msgs(a:1, 0, a:2, len_fl, a:3)
    if (msg != '')
      let msg = msg . "\n"
    endif
  else
    let l0 = line('.') - 1
    let qflist = getqflist()
    let level = QF_level(qflist[l0].text)

    if (a:2 == 'r' && level == 0)
      echo 'Can not do this for level 0'
      return 0
    endif
    if (a:2 != 'r' && len(qflist) - 1 > l0 && level < QF_level(qflist[l0+1].text))
      echo 'Already folded, r first!'
      return 0
    endif

    let i0 = 0
    let msg = ''
    let start = -1
    let end = -2

    if (a:2 == 'r')
      let start = l0
      let end = l0
      while (start > 0 && level == QF_level(qflist[start-1].text))
        let start = start - 1
      endwhile
      while (end < (len(qflist)) && level <= QF_level(qflist[end].text))
        let end = end + 1
      endwhile
      let end = end - 1
    endif

    let len_fl2 = Min_fl_qf(qflist, start, end)
    if (len_fl2 > len_fl)
      let len_fl = len_fl2
    endif

    if (a:2 != 'r')
      let msg2 = Dump_msgs(a:1, level+1, a:2, len_fl, a:3)
      if (msg2 == '')
        return 0
      endif
    endif

    while i0 < (len(qflist))
      let f = Qf_get_file(bufname(qflist[i0].bufnr))
      let l = qflist[i0].lnum

      if (a:2 == 'r' && (start <= i0 && i0 <= end))
          let i0 = i0 + 1
        continue 
      endif

      let text = substitute(qflist[i0].text, '\(^\s*-*\)\(.*\)', '\2', '')
      let pad = repeat('-', len_fl - strlen(f . l))
      let msg = msg . f . ':' . l . ':' . pad . text
      if (a:2 == 'r')
        if (i0 == start -1)
          let msg = substitute(msg, '\(^.*\)\({{{.*\)', '\1', '')
        endif
        let msg = msg . "\n"
      else
        if (i0 == l0)
          let msg = msg . ' {{{' . (level+1) . "\n" .  msg2 . ' }}}' . (level+1)
        endif
        let msg = msg . "\n"
      endif
      let i0 = i0 + 1
    endwhile
  endif

  if (msg != '')
    let s:qfopen = 1
    let s:qffirstin = 1
    if (&filetype == 'qf')
      let s:qffirstin = 2
    endif

    let efm2 = &efm
    set efm=%f:%l:%m
    cgetexpr msg
    let &efm = efm2
    botright copen
    if (l0 >= 0)
        call setpos('.', qf_pos)
    endif
    return 1
  endif

  return 0
endfunction

" test if there is cscope database available
function! CS_has_conn()
  let msg = ''
  redir => msg
  silent! exec 'cs show'
  redir END

  if (match(msg, 'no cscope connections') >= 0)
    return 0 
  else 
    return 1
  endif
endfunction

" if we are in an eclim project (ProjectInfo)
function! Has_eclim()
  let msg = ''
  redir => msg
  silent! exec 'ProjectInfo'
  redir END
  if (match(msg, 'No eclimd instances') >= 0)
    return 0
  endif    
  let p = substitute(msg, '.*Path:\s\+\(\S\+\)\n.*', '\1', '')
  if (match(getcwd(), p) >= 0)
    return 1
  endif

  return 0
endfunction

" quickfix support for cs command
function! CS_QF(...)
  let msg = ''

  if (3 > a:0)
    let a3 = expand('<cword>')
  else
    let a3 = a:3
  endif

  if (a:2 == 'f')
    let a3 = substitute(a3, '\(.*/\)\(.*\)', '\2', '')
  endif

  if (a3 == '')
    let a3 = expand('<cword>')
  endif
  if (a3 == '')
    echo 'cs find ' . a:2 . ' what?'
    return
  endif

  if (CS_has_conn() > 0)
      if (a:2 != 'r')
        redir => msg
        silent! exec 'cs find ' . a:2 . ' ' . a3
        redir END
      endif
      call My_QF(msg, a:2, a3)
      return
  endif

  exec ':vimgrep /' . a3 . '/j **/*'
  copen
endfunction

"quickfix support for tag
function! TAG_QF(...)
  let msg = ''

  if (a:1 == '')
    echo 'tag what?'
    return
  endif

  if (Has_eclim())
      exec ':Qc ' . a:1
      return
  endif

  if (expand('%:p:e') == 'py' && 0 == Pymode_goto_definition())
    return
  elseif (expand('%:p:e') == 'go' && 0 == Vimgo_goto_definition())
    return
  endif

  redir => msg
  if (a:0 == 1)
      silent! exec 'tag ' . a:1
  else
      silent! exec 'cstag ' . a:1
  endif
  redir END

  let rc = My_QF(msg, ' ', a:1)

  " If cscope fail to find the symbol, the original tag will return with
  " different format, go with original tag command
  if (0 == rc)
    silent! exec 'tag ' . a:1
  endif

endfunction

nmap <C-\>s :call CS_QF('find', 's', expand('<cword>'))<CR>
nmap <C-\>g :call CS_QF('find', 'g', expand('<cword>'))<CR>
nmap <C-\>c :call CS_QF('find', 'c', expand('<cword>'))<CR>
nmap <C-\>t :call CS_QF('find', 't', expand('<cword>'))<CR>
nmap <C-\>e :call CS_QF('find', 'e', expand('<cword>'))<CR>
nmap <C-\>d :call CS_QF('find', 'd', expand('<cword>'))<CR>
nmap <C-\>f :call CS_QF('find', 'f', expand('<cfile>'))<CR>

nmap qs :call CS_QF('find', 's', expand('<cword>'))<CR>
nmap qg :call CS_QF('find', 'g', expand('<cword>'))<CR>
nmap qc :call CS_QF('find', 'c', expand('<cword>'))<CR>
"nmap qT :call CS_QF('find', 't', expand('<cword>'))<CR>
nmap qe :call CS_QF('find', 'e', expand('<cword>'))<CR>
nmap qr :call CS_QF('find', 'r', expand('<cword>'))<CR>
nmap qf :call CS_QF('find', 'f', expand('<cfile>'))<CR>
nmap qt :call TAG_QF(expand('<cword>'))<CR>
nmap qT :call TAG_QF(expand('<cword>'), 'T')<CR>

command! -narg=* CS  call CS_QF(<f-args>)
command! -narg=* CSs call CS_QF('find', 's', <f-args>)
command! -narg=* CSg call CS_QF('find', 'g', <f-args>)
command! -narg=* CSc call CS_QF('find', 'c', <f-args>)
command! -narg=* CSt call CS_QF('find', 't', <f-args>)
command! -narg=* CSe call CS_QF('find', 'e', <f-args>)
command! -narg=* CSf call CS_QF('find', 'f', <f-args>)
command! -narg=* CSd call CS_QF('find', 'd', <f-args>)

command! -narg=+ TAG call TAG_QF(<f-args>)

let s:nrqf=-2
let s:moved = 0
let s:moved_another_line = 0
let s:fmap = {'user': 'lichaog', 'pwd': 'love6pig', 'port': 21, 'url': '', 'dir': '~'}
let s:scpmap = {'user': '', 'url': '', 'dir': '~'}

"quickfix browsing support
function! QF_ch(...)
  if (winnr('#') == s:nrqf && s:moved == line('.') && !s:moved_another_line)
      call Ql_func('l')
      redraw!
      let i = 0
      while i < 100000
        let i = i + 1
      endwhile
      call Ql_func('l')
      exec s:nrqf . 'wincmd w'
  endif
endfunction
au CursorHold * call QF_ch()

"quickfix browsing support
function! QF_cm(...)
  if (&filetype == 'qf')
    let s:nrqf = winnr()
    let s:moved = 0
    let s:moved_another_line = 0
  else
    if (s:moved == 0)
      let s:moved = line('.')
    endif
    if (s:moved != line('.'))
        let s:moved_another_line = 1
    endif
  endif
endfunction
au CursorMoved * call QF_cm()

function! QF_init(...)
  setlocal foldmethod=marker 
  nnoremap <buffer> <silent> s :call CS_QF('find', 's', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> g :call CS_QF('find', 'g', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> c :call CS_QF('find', 'c', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> t :call CS_QF('find', 't', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> e :call CS_QF('find', 'e', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> r :call CS_QF('find', 'r', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> f :call CS_QF('find', 'f', expand('<cword>'))<CR>
  nnoremap <buffer> <silent> i :call CS_QF('find', 'i', expand('<cword>'))<CR>
endfunction

au BufWinEnter quickfix call QF_init()
au BufWinLeave quickfix let s:nrqf = -2
" ---------- END: Quickfix support for cscope browsing ------------------------

map <F9> :TlistToggle<CR>
command! -narg=* Tj call Build_mydb_java()
command! -narg=* Tj2 call Build_mydb_java(1)
command! -narg=* Tg call Build_mydb_go()
command! -narg=* Tg2 call Build_mydb_go(1)
command! -narg=* Tc call Build_mydb()
command! -narg=* Tp call Build_mydb_python()
command! -narg=* Tp2 call Build_mydb_python(1)

function! Omni_comp(argLead, cmdLine, cursorPos)
    return ['c', 'java', 'python', 'eclim_c', 'eclim_java', 'eclim_python']
endfunction

" javacomplete#Complete is not set by default to avoid conflict with eclim
function! Omni(t)
    if ('' == a:t)
        return
    endif

    if ('c' == a:t)
        exec 'set omnifunc=omni#cpp#complete#Main'
        exec 'set completefunc='
    elseif ('java' == a:t)
        exec 'set omnifunc='
        exec 'set completefunc=javacomplete#Complete'
    elseif ('python' == a:t)
        exec 'set omnifunc=pythoncomplete#Complete'
        exec 'set completefunc='
    elseif ('eclim_c' == a:t)
        exec 'set completefunc=eclim#c#complete#CodeComplete'
        exec 'set omnifunc='
    elseif ('eclim_java' == a:t)
        exec 'set completefunc=eclim#java#complete#CodeComplete'
        exec 'set omnifunc=eclim#java#complete#CodeComplete'
    elseif ('eclim_python' == a:t)
        exec 'set completefunc=eclim#python#complete#CodeComplete'
        exec 'set omnifunc='
    endif
endfunction

command! -narg=+ -complete=customlist,Omni_comp OMNI :call Omni(<f-args>)

" ----------------- highlight support start ---------------------------
"  ql: toggle highlight on or off for a ossline
"  qL: toggle highlight on or off for a line
"  qH: toggle highlight off for all lines
"       first triggered: clear qflist or loclist
"       second triggered: clear matched
function! Ql_func(...)
    let l = line('.')

    if (a:1 == 'H')
        call clearmatches()
        return
    endif

    for m in getmatches()
        if (!has_key(m, "pattern"))
            continue
        endif
        let pattern = m["pattern"]
        if (pattern == '\%' . l . 'l' || pattern == '^' . getline(l) . '$')
            call matchdelete(m["id"])
            return
        endif
    endfor

    let cmd = '^' . substitute(getline(l), "*", "\\\\*", "g") . '$'
    if (a:1 == 'l')
        let cmd = '\%' . l . 'l'
        let pt = "TODO"
    elseif (a:1 == 'L')
		let pt = "Error"
	elseif (a:1[0] == 'r')
		let pt = "myred"
	elseif (a:1[0] == 'g')
		let pt = "mygreen"
	elseif (a:1[0] == 'b')
		let pt = "myblue"
	elseif (a:1[0] == 'y')
		let pt = "myyellow"
	elseif (a:1[0] == 'c')
		let pt = "mycyan"
	elseif (a:1[0] == 'w')
		let pt = "mywhite"
	elseif (a:1[0] == 'm')
		let pt = "mymagenta"
    endif
    call matchadd(pt, cmd)
endfunction

nmap ql :call Ql_func('l')<CR>
nmap qL :call Ql_func('L')<CR>
nmap qH :call Ql_func('H')<CR>
nmap qrl :call Ql_func('rl')<CR>
nmap qgl :call Ql_func('gl')<CR>
nmap qbl :call Ql_func('bl')<CR>
nmap qyl :call Ql_func('yl')<CR>
nmap qcl :call Ql_func('cl')<CR>
nmap qwl :call Ql_func('wl')<CR>
nmap qml :call Ql_func('ml')<CR>

function! Qj_match(lists, l, gr)
    for m in a:lists
        if (a:gr != '' && m["group"] != a:gr)
            continue
        endif
        if (!has_key(m, "pattern"))
            continue
        endif
        if (strpart(m["pattern"], 0, 1) == '^')
            if (m["pattern"] == ('^' . getline(a:l) . '$'))
                return 1
            endif
        else
            let l2 = strpart(m["pattern"], 2, strlen(m["pattern"]) - 3)     " exclude \% and l
            if (l2 == a:l)
                return 1
            endif
        endif
    endfor

    return 0
endfunction

" save ql result to a file with .ql
function! Sql_func(...)
    let f = expand('%') . '.ql'
    let s = [] 

    for m in getmatches()
        if (!has_key(m, "pattern"))
            continue
        endif
        call add(s, m["group"])
        call add(s, m["pattern"])
    endfor

    if (s != [])
        call writefile(s, f)
    endif
endfunction

" load ql result from a file with .ql
function! Lql_func(...)
    let f = expand('%') . '.ql'
    let already_clear = 0
	let group = ''

    if (glob(f) == '')
        return
    endif

    for l in readfile(f)
        if (!already_clear)
            call clearmatches()
            let already_clear = 1
        endif

		if (group == '')
			let group = l
			continue
		endif
        call matchadd(group, l)
		let group = ''
    endfor
    
endfunction

command! -narg=* Sql call Sql_func(<f-args>)
command! -narg=* Lql call Lql_func(<f-args>)

highlight myred ctermbg=Red ctermfg=White guifg=White guibg=Red
highlight mygreen ctermbg=Green ctermfg=White guifg=White guibg=Green
highlight myblue ctermbg=Blue ctermfg=White guifg=White guibg=Blue
highlight myyellow ctermbg=Yellow ctermfg=White guifg=White guibg=Yellow
highlight mycyan ctermbg=Cyan ctermfg=White guifg=White guibg=Cyan
highlight mywhite ctermbg=White ctermfg=White guifg=White guibg=White
highlight mymagenta ctermbg=Magenta ctermfg=White guifg=White guibg=Magenta

function! Qhl_func(...)
    call matchadd(a:1, a:2)
endfunction

function! Qhl_del_func(...)
    for m in getmatches()
        if (!has_key(m, "pattern"))
            continue
        endif
        if ((1 == a:0 && m["group"] == a:1) || (m["group"] == a:1 && m["pattern"] == a:2))
            call matchdelete(m["id"])
        endif
    endfor
endfunction

function! Qhl_nN_func(...)
    if (a:2 == 'n')
        let r = range(line('.') + 1, line('$'))
    else
        let r = range(line('.') - 1, 1, -1)
    endif
    for l in r
        let line = getline(l)
        for m in getmatches()
            if (m["group"] != a:1)
                continue
            endif
            if (!has_key(m, "pattern"))
                continue
            endif
            if (match(line, m["pattern"]) >= 0)
                exec ":" . l
                return
            endif
        endfor
    endfor
endfunction

nmap qra :call Qhl_func("myred", expand('<cword>'))<CR>
nmap qrn :call Qhl_nN_func("myred", 'n')<CR>
nmap qrN :call Qhl_nN_func("myred", 'N')<CR>
command! -narg=* Qra : call Qhl_func("myred", <f-args>)
nmap qga :call Qhl_func("mygreen", expand('<cword>'))<CR>
nmap qgn :call Qhl_nN_func("mygreen", 'n')<CR>
nmap qgN :call Qhl_nN_func("mygreen", 'N')<CR>
command! -narg=* Qga : call Qhl_func("mygreen", <f-args>)
nmap qba :call Qhl_func("myblue", expand('<cword>'))<CR>
nmap qbn :call Qhl_nN_func("myblue", 'n')<CR>
nmap qbN :call Qhl_nN_func("myblue", 'N')<CR>
command! -narg=* Qba : call Qhl_func("myblue", <f-args>)
nmap qya :call Qhl_func("myyellow", expand('<cword>'))<CR>
nmap qyn :call Qhl_nN_func("myyellow", 'n')<CR>
nmap qyN :call Qhl_nN_func("myyellow", 'N')<CR>
command! -narg=* Qya : call Qhl_func("myyellow", <f-args>)
nmap qca :call Qhl_func("mycyan", expand('<cword>'))<CR>
nmap qcn :call Qhl_nN_func("mycyan", 'n')<CR>
nmap qcN :call Qhl_nN_func("mycyan", 'N')<CR>
command! -narg=* Qca : call Qhl_func("mycyan", <f-args>)
nmap qwa :call Qhl_func("mywhite", expand('<cword>'))<CR>
nmap qwn :call Qhl_nN_func("mywhite", 'n')<CR>
nmap qwN :call Qhl_nN_func("mywhite", 'N')<CR>
command! -narg=* Qwa : call Qhl_func("mywhite", <f-args>)
nmap qma :call Qhl_func("mymagenta", expand('<cword>'))<CR>
nmap qmn :call Qhl_nN_func("mymagenta", 'n')<CR>
nmap qmN :call Qhl_nN_func("mymagenta", 'N')<CR>
command! -narg=* Qma : call Qhl_func("mymagenta", <f-args>)

nmap qrd :call Qhl_del_func("myred", expand('<cword>'))<CR>
command! -narg=* Qrd : call Qhl_del_func("myred", <f-args>)
nmap qgd :call Qhl_del_func("mygreen", expand('<cword>'))<CR>
command! -narg=* Qgd : call Qhl_del_func("mygreen", <f-args>)
nmap qbd :call Qhl_del_func("myblue", expand('<cword>'))<CR>
command! -narg=* Qbd : call Qhl_del_func("myblue", <f-args>)
nmap qyd :call Qhl_del_func("myyellow", expand('<cword>'))<CR>
command! -narg=* Qyd : call Qhl_del_func("myyellow", <f-args>)
nmap qcd :call Qhl_del_func("mycyan", expand('<cword>'))<CR>
command! -narg=* Qcd : call Qhl_del_func("mycyan", <f-args>)
nmap qwd :call Qhl_del_func("mywhite", expand('<cword>'))<CR>
command! -narg=* Qwd : call Qhl_del_func("mywhite", <f-args>)
nmap qmd :call Qhl_del_func("mymagenta", expand('<cword>'))<CR>
command! -narg=* Qmd : call Qhl_del_func("mymagenta", <f-args>)

" ----------------- highlight support end ---------------------------

"quick navigation:
"   if having gr window, up/down the gr window
"   if having loclist or qflist, up/down in current buffer
"   if having match list, up/down in current buffer
function! Qjk_func(jk, gr)
    if (a:jk == 'J' || a:jk == 'K')   "  qf and loc list
        if (!empty(getqflist()))
            if (a:jk == 'J')
                silent! exec ":cnext"
            else
                silent! exec ":cprevious"
            endif
            return
        endif
        if (!empty(getloclist(0)))
            if (a:jk == 'J')
                silent! exec ":lnext"
            else
                silent! exec ":lprevious"
            endif
            return
        endif
        return
    endif

	let l2 = 0
	if (a:jk == 'j')
		let r = range(line('.') + 1, line('$'))
	else    
		let r = range(line('.') - 1, 1, -1)
	endif

	for l in r
		if Qj_match(getmatches(), l, a:gr)
			let l2 = l
			break
		endif
	endfor

    if (l2 != 0)
        exec ":" . l2  
    endif
endfunction

nmap qJ :call Qjk_func('J', '')<CR>
nmap qK :call Qjk_func('K', '')<CR>
nmap qj :call Qjk_func('j', '')<CR>
nmap qk :call Qjk_func('k', '')<CR>
nmap qrj :call Qjk_func('j', "myred")<CR>
nmap qrk :call Qjk_func('k', "myred")<CR>
nmap qgj :call Qjk_func('j', "mygreen")<CR>
nmap qgk :call Qjk_func('k', "mygreen")<CR>
nmap qbj :call Qjk_func('j', "myblue")<CR>
nmap qbk :call Qjk_func('k', "myblue")<CR>
nmap qwj :call Qjk_func('j', "mywhite")<CR>
nmap qwk :call Qjk_func('k', "mywhite")<CR>
nmap qcj :call Qjk_func('j', "mycyan")<CR>
nmap qck :call Qjk_func('k', "mycyan")<CR>
nmap qmj :call Qjk_func('j', "mymagenta")<CR>
nmap qmk :call Qjk_func('k', "mymagenta")<CR>
nmap qyj :call Qjk_func('j', "myyellow")<CR>
nmap qyk :call Qjk_func('k', "myyellow")<CR>

let s:eclim_search = ''

"quick navigation and command complete support for eclim search
function! Eclim_search()
    if (s:eclim_search != '')
        return s:eclim_search
    endif

    redir => msg
    silent! exec ':ProjectInfo'
    redir END

    let c = substitute(msg, '.*Natures:\s\+\([a-z]\+\).*', '\1', '')
    if (c == 'java')
        let s:eclim_search = 'java_search'
    elseif (c == 'c' || c == 'cpp' || c == 'c++')
        let s:eclim_search = 'c_search'
    elseif (c == 'python')
        let s:eclim_search = 'python_search'
    endif

    return s:eclim_search
endfunction

" generate list for auto complete or for use in qf window
function! Q_func_helper(t, x, p, c)
    let jc = Eclim_search()
    if (jc == '')
        return []
    endif
    
    " not sure why c does not accept -s project
    if (jc == 'python_search') 
        let cmd = ' -command ' . jc . ' -x ' . a:x . ' ' . a:p
    else
        let cmd = ' -command ' . jc . ' -s project' . ' -t ' . a:t . ' -x ' . a:x . ' -p ' . a:p
    endif
    let mylist = eclim#Execute(cmd)
    let rl = []
    for e in mylist
        let e.filename = substitute(e.filename, getcwd() . '/', '', '')
        let m = e.message
        if (e.length == 0 || a:c != 1)
            let m = e.message . ' ' . system('sed -n ' . e.line . 'p' . ' ' . e.filename)
            let m = substitute(m, '^\s\+', '', '')
        endif

        if (a:x == 'references')
            call Tlist_Update_File(e.filename, getbufvar(bufnr('%'), '&filetype'))
            let rf = Tlist_Get_Tagname_By_Line(e.filename, e.line)
            if (rf != '')
                let rf = rf . '()'
            endif
            let message = e.filename  . ':' . e.line . ':' . e.column . ':' . rf . ' '. m
        else 
            let message = e.filename  . ':' . e.line . ':' . e.column . ':' . m
        endif

        call add(rl, message)
    endfor
    return rl
endfunction

"the navigation result shown in qf window for eclim support
function! Q_func(...)
    if 3 <= a:0
        let a3 = a:3
        if (len(split(a3, ':')) > 1)
            return QG_func(a3)
        endif
    else
        let a3 = expand('<cword>')
    endif

    let rl = Q_func_helper(a:1, a:2, a3, 0)
    cgetexpr rl
    botright copen
endfunction

" go to a file:line directly
function! QG_func(...)
    let a = split(a:1, ':')
    exec ':tabnew ' . a[0]
    call cursor(a[1], a[2])
endfunction

" if start or end with *, then don't do camel search
function! Q_comp_pattern(argLead, cmdLine, cursorPos)
    if (a:argLead == '')
        return []
    endif

    if (a:argLead[0] == '*' || a:argLead[strlen(a:argLead)-1] == '*')
        let pattern = '*' . a:argLead . '*'
    else
        let pattern = "*"
        let i = 0
        while i < strlen(a:argLead)
            let pattern = pattern . strpart(a:argLead, i, 1) . "*"
            let i = i + 1
        endwhile
    endif

    return pattern
endfunction

"complete for all Q command, in command line, when in 
": or CTRL_F mode, the argLead and cmdLine are not the same!
function! Q_comp(argLead, cmdLine, cursorPos)
    let pattern = Q_comp_pattern(a:argLead, a:cmdLine, a:cursorPos)

    if (a:argLead == a:cmdLine)     " from within CTRL_F
        let line = getline('.')
    else                            " normal : command line
        let line = a:cmdLine
    endif

    let as = split(line, 'Q')
    return Q_func_helper(as[0], as[1], pattern, 1)
endfunction

function! Qc_func(...)
    let jc = Eclim_search()
    if (jc == 'java_search')
        exec ':JavaSearchContext'
    elseif (jc == 'c_search')
        exec ':CSearchContext'
    elseif (jc == 'python_search')
        exec ':PythonSearchContext'
    endif
endfunction

function! Qs_func(...)
    if 1 == a:0
        let a1 = a:1
    else
        let a1 = expand('<cword>')
    endif
    exec ':vimgrep /' . a1 . '/j **/*.java'
    exec ':copen'
endfunction

command! -narg=* -complete=customlist,Q_comp QannotationQall :call Q_func('annotation', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QannotationQdeclarations :call Q_func('annotation', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QannotationQimplementors :call Q_func('annotation', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QannotationQreferences :call Q_func('annotation', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassQall :call Q_func('class', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassQdeclarations :call Q_func('class', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassQimplementors :call Q_func('class', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassQreferences :call Q_func('class', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrEnumQall :call Q_func('classOrEnum', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrEnumQdeclarations :call Q_func('classOrEnum', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrEnumQimplementors :call Q_func('classOrEnum', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrEnumQreferences :call Q_func('classOrEnum', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrInterfaceQall :call Q_func('classOrInterface', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrInterfaceQdeclarations :call Q_func('classOrInterface', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrInterfaceQimplementors :call Q_func('classOrInterface', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassOrInterfaceQreferences :call Q_func('classOrInterface', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QconstructorQall :call Q_func('constructor', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QconstructorQdeclarations :call Q_func('constructor', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QconstructorQimplementors :call Q_func('constructor', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QconstructorQreferences :call Q_func('constructor', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQall :call Q_func('enum', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQdeclarations :call Q_func('enum', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQimplementors :call Q_func('enum', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQreferences :call Q_func('enum', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQall :call Q_func('field', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQdeclarations :call Q_func('field', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQimplementors :call Q_func('field', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQreferences :call Q_func('field', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QinterfaceQall :call Q_func('interface', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QinterfaceQdeclarations :call Q_func('interface', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QinterfaceQimplementors :call Q_func('interface', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QinterfaceQreferences :call Q_func('interface', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQall :call Q_func('method', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQdeclarations :call Q_func('method', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQimplementors :call Q_func('method', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQreferences :call Q_func('method', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QpackageQall :call Q_func('package', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QpackageQdeclarations :call Q_func('package', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QpackageQimplementors :call Q_func('package', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QpackageQreferences :call Q_func('package', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypeQall :call Q_func('type', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypeQdeclarations :call Q_func('type', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypeQimplementors :call Q_func('type', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypeQreferences :call Q_func('type', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassstructQall :call Q_func('class_struct', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassstructQdeclarations :call Q_func('class_struct', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassstructQimplementors :call Q_func('class_struct', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QclassstructQreferences :call Q_func('class_struct', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfunctionQall :call Q_func('function', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfunctionQdeclarations :call Q_func('function', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfunctionQimplementors :call Q_func('function', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfunctionQreferences :call Q_func('function', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QvariableQall :call Q_func('variable', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QvariableQdeclarations :call Q_func('variable', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QvariableQimplementors :call Q_func('variable', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QvariableQreferences :call Q_func('variable', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QunionQall :call Q_func('union', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QunionQdeclarations :call Q_func('union', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QunionQimplementors :call Q_func('union', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QunionQreferences :call Q_func('union', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQall :call Q_func('method', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQdeclarations :call Q_func('method', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQimplementors :call Q_func('method', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmethodQreferences :call Q_func('method', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQall :call Q_func('field', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQdeclarations :call Q_func('field', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQimplementors :call Q_func('field', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QfieldQreferences :call Q_func('field', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQall :call Q_func('enum', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQdeclarations :call Q_func('enum', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQimplementors :call Q_func('enum', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumQreferences :call Q_func('enum', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumeratorQall :call Q_func('enumerator', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumeratorQdeclarations :call Q_func('enumerator', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumeratorQimplementors :call Q_func('enumerator', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QenumeratorQreferences :call Q_func('enumerator', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QnamespaceQall :call Q_func('namespace', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QnamespaceQdeclarations :call Q_func('namespace', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QnamespaceQimplementors :call Q_func('namespace', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QnamespaceQreferences :call Q_func('namespace', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypedefQall :call Q_func('typedef', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypedefQdeclarations :call Q_func('typedef', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypedefQimplementors :call Q_func('typedef', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QtypedefQreferences :call Q_func('typedef', 'references', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmacroQall :call Q_func('macro', 'all', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmacroQdeclarations :call Q_func('macro', 'declarations', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmacroQimplementors :call Q_func('macro', 'implementors', <f-args>)
command! -narg=* -complete=customlist,Q_comp QmacroQreferences :call Q_func('macro', 'references', <f-args>)


nmap qaa :call Q_func('annotation', 'all', expand('<cword>'))<CR>
nmap qad :call Q_func('annotation', 'declarations', expand('<cword>'))<CR>
nmap qai :call Q_func('annotation', 'implementors', expand('<cword>'))<CR>
nmap qar :call Q_func('annotation', 'references', expand('<cword>'))<CR>
nmap qca :call Q_func('class', 'all', expand('<cword>'))<CR>
nmap qcd :call Q_func('class', 'declarations', expand('<cword>'))<CR>
nmap qci :call Q_func('class', 'implementors', expand('<cword>'))<CR>
nmap qcr :call Q_func('class', 'references', expand('<cword>'))<CR>
nmap qea :call Q_func('enum', 'all', expand('<cword>'))<CR>
nmap qed :call Q_func('enum', 'declarations', expand('<cword>'))<CR>
nmap qei :call Q_func('enum', 'implementors', expand('<cword>'))<CR>
nmap qer :call Q_func('enum', 'references', expand('<cword>'))<CR>
nmap qfia :call Q_func('field', 'all', expand('<cword>'))<CR>
nmap qfid :call Q_func('field', 'declarations', expand('<cword>'))<CR>
nmap qfii :call Q_func('field', 'implementors', expand('<cword>'))<CR>
nmap qfir :call Q_func('field', 'references', expand('<cword>'))<CR>
nmap qia :call Q_func('interface', 'all', expand('<cword>'))<CR>
nmap qid :call Q_func('interface', 'declarations', expand('<cword>'))<CR>
nmap qii :call Q_func('interface', 'implementors', expand('<cword>'))<CR>
nmap qir :call Q_func('interface', 'references', expand('<cword>'))<CR>
nmap qma :call Q_func('method', 'all', expand('<cword>'))<CR>
nmap qmd :call Q_func('method', 'declarations', expand('<cword>'))<CR>
nmap qmi :call Q_func('method', 'implementors', expand('<cword>'))<CR>
nmap qmr :call Q_func('method', 'references', expand('<cword>'))<CR>
nmap qpa :call Q_func('package', 'all', expand('<cword>'))<CR>
nmap qpd :call Q_func('package', 'declarations', expand('<cword>'))<CR>
nmap qpi :call Q_func('package', 'implementors', expand('<cword>'))<CR>
nmap qpr :call Q_func('package', 'references', expand('<cword>'))<CR>
nmap qta :call Q_func('type', 'all', expand('<cword>'))<CR>
nmap qtd :call Q_func('type', 'declarations', expand('<cword>'))<CR>
nmap qti :call Q_func('type', 'implementors', expand('<cword>'))<CR>
nmap qtr :call Q_func('type', 'references', expand('<cword>'))<CR>
nmap qsa :call Q_func('class_struct', 'all', expand('<cword>'))<CR>
nmap qsd :call Q_func('class_struct', 'declarations', expand('<cword>'))<CR>
nmap qsi :call Q_func('class_struct', 'implementors', expand('<cword>'))<CR>
nmap qsr :call Q_func('class_struct', 'references', expand('<cword>'))<CR>
nmap qfa :call Q_func('function', 'all', expand('<cword>'))<CR>
nmap qfd :call Q_func('function', 'declarations', expand('<cword>'))<CR>
nmap qfi :call Q_func('function', 'implementors', expand('<cword>'))<CR>
nmap qfr :call Q_func('function', 'references', expand('<cword>'))<CR>
nmap qva :call Q_func('variable', 'all', expand('<cword>'))<CR>
nmap qvd :call Q_func('variable', 'declarations', expand('<cword>'))<CR>
nmap qvi :call Q_func('variable', 'implementors', expand('<cword>'))<CR>
nmap qvr :call Q_func('variable', 'references', expand('<cword>'))<CR>
nmap qua :call Q_func('union', 'all', expand('<cword>'))<CR>
nmap qud :call Q_func('union', 'declarations', expand('<cword>'))<CR>
nmap qui :call Q_func('union', 'implementors', expand('<cword>'))<CR>
nmap qur :call Q_func('union', 'references', expand('<cword>'))<CR>
nmap qena :call Q_func('enumerator', 'all', expand('<cword>'))<CR>
nmap qend :call Q_func('enumerator', 'declarations', expand('<cword>'))<CR>
nmap qeni :call Q_func('enumerator', 'implementors', expand('<cword>'))<CR>
nmap qenr :call Q_func('enumerator', 'references', expand('<cword>'))<CR>
nmap qna :call Q_func('namespace', 'all', expand('<cword>'))<CR>
nmap qnd :call Q_func('namespace', 'declarations', expand('<cword>'))<CR>
nmap qni :call Q_func('namespace', 'implementors', expand('<cword>'))<CR>
nmap qnr :call Q_func('namespace', 'references', expand('<cword>'))<CR>
nmap qta :call Q_func('typedef', 'all', expand('<cword>'))<CR>
nmap qtd :call Q_func('typedef', 'declarations', expand('<cword>'))<CR>
nmap qti :call Q_func('typedef', 'implementors', expand('<cword>'))<CR>
nmap qtr :call Q_func('typedef', 'references', expand('<cword>'))<CR>
nmap qmaa :call Q_func('macro', 'all', expand('<cword>'))<CR>
nmap qmad :call Q_func('macro', 'declarations', expand('<cword>'))<CR>
nmap qmai :call Q_func('macro', 'implementors', expand('<cword>'))<CR>
nmap qmar :call Q_func('macro', 'references', expand('<cword>'))<CR>
nmap qx :call Qc_func(<f-args>)

command! -narg=* Qs call Qs_func(<f-args>)
command! -narg=* Qc call Qc_func(<f-args>)

command! -narg=0 CPP : call CSA_func('/Users/brian/Documents/python')

function! CPP2_func(...)
    call Build_mydb_python()
    call CSP_func('.')
    call CSA_func('/Users/brian/Documents/python')
endfunction
command! -narg=0 CPP2 : call CPP2_func()

