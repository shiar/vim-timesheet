" Create a new entry.
" followed_by:        string to append after the timestamp
" optional parameter: set to false (e.g. 0) to _not_ go into insert mode
"                     afterwards
function! s:NewTimesheetEntry(followed_by, ...)
	let l:insertmode = get(a:, 1, 1)
	" Go to the end of the file, because that's the only place where
	" inserting a new timestamped item makes sense.
	normal G
	" Look backwards for a date.
	let l:dateline = search('\v^\d{4}-\d{2}-\d{2}:$', 'bcnw')
	" If there's none or it's not the current day, create one.
	if !l:dateline || getline(l:dateline) != strftime("%Y-%m-%d:")
		execute "normal o\n" . strftime("%Y-%m-%d:")
	endif
	" Insert the timestamp and start insert mode.
	execute "normal o" . strftime("%H%M") . a:followed_by
	if l:insertmode
		startinsert!
	endif
endfunction

nnoremap <Plug>TimesheetStart    :call <SID>NewTimesheetEntry('  ')<CR>
nnoremap <Plug>TimesheetStop     :call <SID>NewTimesheetEntry('.', 0)<CR>
nnoremap <Plug>TimesheetContinue :call <SID>NewTimesheetEntry('^', 0)<CR>

" Some mappings to insert a timestamped new line.
if !hasmapto('<Plug>TimesheetStart')
	nmap <buffer> <LocalLeader>n <Plug>TimesheetStart
	nmap <buffer> <LocalLeader>s <Plug>TimesheetStop
	nmap <buffer> <LocalLeader>c <Plug>TimesheetContinue
endif
