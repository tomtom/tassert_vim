" @Author:      Thomas Link (mailto:micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2009-02-21.
" @Last Change: 2010-01-03.
" @Revision:    109

let s:save_cpo = &cpo
set cpo&vim
" call tlog#Log('Load: '. expand('<sfile>')) " vimtlib-sfile


function! tassert#G(line1, line2, cmd, rx) "{{{3
    let pos = getpos('.')
    try
        let cmd = a:line1 .','. a:line2 .'g/'. escape(a:rx, '/') .'/ '. a:cmd
        exec cmd
    finally
        call setpos('.', pos)
    endtry
endf


function! tassert#Exec(line1, line2, bang, cmd) "{{{3
    let rx = '\C^\s*\("\s*\)\?TAssert'
    call tassert#G(a:line1, a:line2, a:cmd, rx)
    if a:bang
        call tlog#Exec(line1, line2, cmd)
    endif
endf


" :nodoc:
function! tassert#Comment(line1, line2, bang) "{{{3
    " TLogVAR a:line1, a:line2
    let assertCP = getpos('.')
    let tassertSR = @/
    call s:CommentRegion(1, a:line1, a:line2)
    exec 'silent '. a:line1.','. a:line2 .'s/\C^\(\s*\)\(TAssert\)/\1" \2/ge'
    if !empty(a:bang)
        call tlog#Comment(a:line1, a:line2)
    endif
    let @/ = tassertSR
    call setpos('.', assertCP)
endf


" :nodoc:
function! tassert#Uncomment(line1, line2, bang) "{{{3
    let assertCP = getpos('.')
    let tassertSR = @/
    call s:CommentRegion(0, a:line1, a:line2)
    exec 'silent '. a:line1.','. a:line2 .'s/\C^\(\s*\)"\s*\(TAssert\)/\1\2/ge'
    if !empty(a:bang)
        call tlog#Uncomment(a:line1, a:line2)
    endif
    let @/ = tassertSR
    call setpos('.', assertCP)
endf


fun! s:CommentRegion(mode, line1, line2)
    exec a:line1
    let prefix = a:mode ? '^\s*' : '^\s*"\s*'
    let tb = search(prefix.'TAssertBegin\>', 'bc', a:line1)
    while tb
        let te = search(prefix.'TAssertEnd\>', 'W', a:line2)
        if te
            if a:mode
                silent exec tb.','.te.'s/^\s*/\0" /'
            else
                silent exec tb.','.te.'s/^\(\s*\)"\s*/\1/'
            endif
            let tb = search(prefix.'TAssertBegin\>', 'W', a:line2)
        else
            throw 'tAssert: Missing TAssertEnd below line '. tb
        endif
    endwh
endf


let &cpo = s:save_cpo
unlet s:save_cpo
