" tLog.vim
" @Author:      Tom Link (micathom AT gmail com?subject=vim-tLog)
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2006-12-15.
" @Last Change: 2015-10-27.
" @Revision:    2.3.168

if &cp || exists('g:loaded_tlog')
    finish
endif
let g:loaded_tlog = 100


" One of: echo, echom, file, Decho
" Format: type:args
" E.g. file:/tmp/foo.log
if !exists('g:tlogDefault')   | let g:tlogDefault = 'echom'   | endif
if !exists('g:TLOG')          | let g:TLOG = g:tlogDefault    | endif
if !exists('g:tlogBacktrace') | let g:tlogBacktrace = 2       | endif


" :display: :TLog MESSAGE
command! -bar -nargs=+ TLog call tlog#Log(<args>)

" :display: :TLogTODO MESSAGE
" Mark as "Not yet implemented".
command! -bar -nargs=* -bar TLogTODO call tlog#Debug(expand('<sfile>').': Not yet implemented '. <q-args>)

" :display: :TLogDBG EXPRESSION
" Expression must evaluate to a string.
command! -nargs=1 TLogDBG call tlog#Debug(expand('<sfile>').': '. <args>)

" :display: :TLogExec EXPRESSION
" Execute an expression.
command! -bar -nargs=1 TLogExec exec <q-args>

" :display: :TLogStyle STYLE EXPRESSION
" Expression must evaluate to a string.
command! -bar -nargs=+ TLogStyle call tlog#Style(<args>)

" :display: :TLogVAR VAR1, VAR2 ...
" Display variable names and their values.
" This command doesn't work with script-local variables.
command! -nargs=+ TLogVAR call tlog#Var(expand('<sfile>'), <q-args>, <args>)
" command! -nargs=+ TLogVAR if !TLogVAR(expand('<sfile>').': ', <q-args>, <f-args>) | call tlog#Debug(expand('<sfile>').': Var doesn''t exist: '. <q-args>) | endif

" :display: :TLogTrace EXPR, VARs...
" If EXPR evaluates to TRUE, call |:TLogVAR| with VARs...
command! -nargs=+ TLogTrace call tlog#Trace(expand('<sfile>'), <q-args>, <args>)

" Enable logging.
command! -bar -nargs=? TLogOn let g:TLOG = empty(<q-args>) ? g:tlogDefault : <q-args>

" Disable logging.
command! -bar -nargs=? TLogOff let g:TLOG = ''

" Enable logging for the current buffer.
command! -bar -nargs=? TLogBufferOn let b:TLOG = empty(<q-args>) ? g:tlogDefault : <q-args>

" Disable logging for the current buffer.
command! -bar -nargs=? TLogBufferOff let b:TLOG = ''

" Comment out all tlog-related lines in the current buffer which should 
" contain a vim script.
command! -range=% -bar TLogComment call tlog#Comment(<line1>, <line2>)

" Re-enable all tlog-related statements.
command! -range=% -bar TLogUncomment call tlog#Uncomment(<line1>, <line2>)

" :display: :TLogG CMD
" Run CMD on all log-related lines.
command! -nargs=1 -range=% -bar TLogG call tlog#Exec(<line1>, <line2>, <q-args>)

finish

CHANGE LOG {{{1
see 07tAssert.vim

