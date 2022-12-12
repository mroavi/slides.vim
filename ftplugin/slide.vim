" Execute statements in file if preceded by a given pattern
" Similar to https://youtu.be/GDa7hrbcCB8?t=402
function! FindAndExecute()
  " TODO: find out why BufEnter *.slide triggers for all slides after goyo is activated
  let startrow = search('^!!start', 'n')
  let endrow = search('^!!end', 'n')
  if (startrow != 0) && (endrow != 0)
    exe string(startrow + 1) . ',' . string(endrow - 1) . 'source'
    redraw
  endif
endfunction

augroup find_and_execute
  autocmd!
  autocmd BufEnter *.slide call FindAndExecute()
augroup END
