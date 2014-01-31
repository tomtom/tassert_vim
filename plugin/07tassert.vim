" tAssert.vim
" @Author:      Tom Link (micathom AT gmail com?subject=vim-tAssert)
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2006-12-12.
" @Last Change: 2014-01-27.
" @Revision:    820
"
" GetLatestVimScripts: 1730 1 07tAssert.vim

if &cp || exists("loaded_tassert")
    if !(!exists("s:assert") || g:TASSERT != s:assert)
        finish
    endif
endif
let loaded_tassert = 101

let s:save_cpo = &cpo
set cpo&vim


if !exists('g:TASSERT')    | let g:TASSERT = 0    | endif
if !exists('g:TASSERTLOG') | let g:TASSERTLOG = 1 | endif

if exists('s:assert')
    echom 'TAssertions are '. (g:TASSERT ? 'on' : 'off')
endif
let s:assert = g:TASSERT


if g:TASSERT

    if exists(':TLogOn') && empty(g:TLOG)
        TLogOn
    endif

    " :display: TAssert[!] {expr}
    " Test that an expression doesn't evaluate to something |empty()|. 
    " With [!] failures are logged according to the setting of 
    " |g:tAssertLog|.
    command! -nargs=1 -bang TAssert 
                \ let s:assertReason = '' |
                \ try |
                \   let s:assertFailed = empty(eval(<q-args>)) |
                \ catch |
                \   let s:assertReason = v:exception |
                \   let s:assertFailed = 1 |
                \ endtry |
                \ if s:assertFailed |
                \   let s:assertReason .= ' '. <q-args> |
                \   if "<bang>" != '' |
                \     call tlog#Log(s:assertReason) |
                \   else |
                \     throw substitute(s:assertReason, '^Vim.\{-}:', '', '') |
                \   endif |
                \ endif

    " :display: TAssertType EXPRESSION, TYPE
    " Check if EXPRESSION is of a certain TYPE (see |IsA()|).
    "
    " This command requires macros/tassert.vim to be loaded.
    command! -nargs=+ -bang TAssertType TAssert<bang> IsItA(<args>)

else

    " :nodoc:
    command! -nargs=1 -bang TAssert :
    " :nodoc:
    command! -nargs=+ -bang TAssertType :

endif


if !exists('s:self_file')

    if exists('*fnameescape')
        let s:self_file = fnameescape(expand('<sfile>:p'))
    else
        let s:self_file = escape(expand('<sfile>:p'), " \t\n*?[{`$\\%#'\"|!<")
    endif

    " Switch assertions on and reload the plugin.
    " :read: command! -bar TAssertOn
    exec 'command! -bar TAssertOn let g:TASSERT = 1 | source '. s:self_file

    " Switch assertions off and reload the plugin.
    " :read: command! -bar TAssertOff
    exec 'command! -bar TAssertOff let g:TASSERT = 0 | source '. s:self_file

    " Comment TAssert* commands and all lines between a TAssertBegin 
    " and a TAssertEnd command.
    command! -range=% -bar -bang TAssertComment call tassert#Comment(<line1>, <line2>, "<bang>")

    " Uncomment TAssert* commands and all lines between a TAssertBegin 
    " and a TAssertEnd command.
    command! -range=% -bar -bang TAssertUncomment call tassert#Uncomment(<line1>, <line2>, "<bang>")

endif


let &cpo = s:save_cpo
unlet s:save_cpo
