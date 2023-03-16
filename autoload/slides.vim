let g:slides_font_size = get(g:, "slides_font_size", 18)
let g:slides_cursor_color = get(g:, "slides_cursor_color", "#282828")
let g:slides_cursor_text_color = get(g:, "slides_cursor_text_color", "#ffc24b")

let s:alacritty_win_id = expand("$ALACRITTY_WINDOW_ID")
let s:kitty_socket = expand("$KITTY_LISTEN_ON")

" ---------------------------------------------------------------------------
" statusline
" ---------------------------------------------------------------------------

" Returns the current date
function StatuslineDate()
  return strftime("%b %d, %Y")
endfunction

" Returns the current argument file in the arglist (which I use as the slide number)
function StatuslineSlideNumber()
  return 'slide ' . string(argidx() + 1) . ' / ' . argc()
endfunction

" Sets the date and slide number in the status line
function s:statusline_refresh()
  setlocal statusline=
  setlocal statusline+=%#Conceal# " set `Conceal` highlight color
  setlocal statusline+=%{StatuslineDate()} " insert date
  setlocal statusline+=%= " switch to the right side
  setlocal statusline+=%{StatuslineSlideNumber()} " insert slide number
endfunction

" ---------------------------------------------------------------------------
" font size
" ---------------------------------------------------------------------------

function s:set_font_size()
  if $TERM ==# 'xterm-256color' && !empty(s:alacritty_win_id)
    call system(printf("alacritty msg config -w %s font.size=%s", s:alacritty_win_id, g:slides_font_size))
  elseif $TERM ==# 'xterm-kitty' && !empty(s:kitty_socket)
    call system(printf("kitty @ --to %s set-font-size %s", s:kitty_socket, g:slides_font_size))
    redraw
  endif
endfunction

function s:reset_font_size()
  if $TERM ==# 'xterm-256color' && !empty(s:alacritty_win_id)
    call system(printf("alacritty msg config -w %s --reset", s:alacritty_win_id))
  elseif $TERM ==# 'xterm-kitty' && !empty(s:kitty_socket)
    "call system(printf("kitty @ --to %s set-font-size %s", s:kitty_socket, 0))
    call system(printf("kitty @ --to %s set-font-size %s", s:kitty_socket, 11)) " TEMP - see: https://github.com/kovidgoyal/kitty/issues/5992
    redraw
  endif
endfunction

" ---------------------------------------------------------------------------
" Cursor color
" ---------------------------------------------------------------------------

function s:set_cursor_color()
  if $TERM ==# 'xterm-256color' && !empty(s:alacritty_win_id)
    let s:alacritty_win_id = expand("$ALACRITTY_WINDOW_ID")
    call system(printf("alacritty msg config -w %s colors.cursor.background='\"%s\"'", s:alacritty_win_id, g:slides_cursor_color))
  elseif $TERM ==# 'xterm-kitty' && !empty(s:kitty_socket)
    " TODO: not working (apparently it is getting reset by posterior goyo configs)
    call system(printf("kitty @ --to %s set-colors cursor=%s", s:kitty_socket, g:slides_cursor_color))
    "echom printf("kitty @ --to %s set-colors cursor=%s", s:kitty_socket, g:slides_cursor_color)
    redraw
  endif
endfunction

function s:reset_cursor_color()
  if $TERM ==# 'xterm-256color' && !empty(s:alacritty_win_id)
    call system(printf("alacritty msg config -w %s --reset", s:alacritty_win_id))
  elseif $TERM ==# 'xterm-kitty' && !empty(s:kitty_socket)
    call system(printf("kitty @ --to %s set-colors --reset", s:kitty_socket))
    redraw
  endif
endfunction

" ---------------------------------------------------------------------------
" Silent argument list navigation (suppresses "E165: Cannot go beyond/before last/first file")
" ---------------------------------------------------------------------------

function! s:next_silent()
  execute 'try | n | catch | try | silent exe "norm \<C-l>" | catch | | endtry | endtry'
endfunction

function! s:prev_silent()
  execute 'try | N | catch | try | silent exe "norm \<C-l>" | catch | | endtry | endtry'
endfunction

" ---------------------------------------------------------------------------
" Goyo activated
" ---------------------------------------------------------------------------

function! s:goyo_enter()
  echo ''
  lua require"gitsigns".toggle_signs(false)
  call s:set_font_size() " set presentation mode font size
  call s:set_cursor_color() " change cursor's background color

  " Set slide navigation mappings 
  nnoremap <silent> j :call <SID>next_silent()<CR>
  nnoremap <silent> k :call <SID>prev_silent()<CR>

  " Create autocommands
  augroup presentation_mode
    autocmd!
    "autocmd BufEnter *.slide call search("^$", 'cw') " place cursor on the next empty line
    autocmd BufEnter *.slide call s:position_cursor()
    autocmd BufEnter *.slide call s:statusline_refresh() " refresh statusline
  augroup END

  "setlocal laststatus=2 " show statusline " mrv: not needed
  argu " open the current entry in the arglist

  let g:argidx = argidx() " initialize global var used to set last visited slide at leave from goyo plugin

endfunction

function! s:position_cursor()
  0 " place cursor on the first line
  call search("^$", 'cw') " place cursor on the next empty line
endfunction

" ---------------------------------------------------------------------------
" Goyo deactivated
" ---------------------------------------------------------------------------

function! s:goyo_leave()
  lua require"gitsigns".toggle_signs(true)
  call s:reset_font_size() " reset font size
  call s:reset_cursor_color() " reset cursor's color

  " Unset slide navigation mappings
  nunmap j
  nunmap k

  " Remove autocommands 
  augroup presentation_mode
    autocmd!
  augroup END
  augroup! presentation_mode

  " Open the last visited slide
  exe 'argu ' . (g:argidx + 1) 

  setfiletype slide " reapply "slide" syntax (which gets reset after reapplying the color scheme)

endfunction

function! slides#present(bang, dim)
  call goyo#execute(a:bang, a:dim)
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
