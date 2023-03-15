let g:slides_font_size = get(g:, "slides_font_size", 18)
let g:slides_cursor_color = get(g:, "slides_cursor_color", "#282828")
let g:slides_cursor_text_color = get(g:, "slides_cursor_text_color", "#ffc24b")

let s:win_id = expand("$ALACRITTY_WINDOW_ID")
let s:socket = expand("$KITTY_LISTEN_ON")

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEMPORAL START (remove this once the better alternative approach is fixed)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:alacritty_config_filepath = expand('~/.config/alacritty/alacritty.yml')
let g:kitty_config_filepath = expand('~/.config/kitty/kitty.conf')

" ---------------------------------------------------------------------------
" font size (TEMP)
" ---------------------------------------------------------------------------

function s:set_font_size()
  if $TERM ==# 'alacritty'
    let s:font_size_current = matchstr(readfile(expand(g:alacritty_config_filepath)), '^  size:')
    let s:font_size_new = '  size: ' . g:slides_font_size
    let sed_cmd = "sed -i 's/" . s:font_size_current . "/" . s:font_size_new . "/g'"
    silent execute "!" . sed_cmd . " " . g:alacritty_config_filepath
  elseif $TERM ==# 'xterm-kitty'
    let s:font_size_current = matchstr(readfile(expand(g:kitty_config_filepath)), '^font_size ')
    let s:font_size_new = 'font_size ' . g:slides_font_size
    let sed_cmd = "sed -i 's/" . s:font_size_current . "/" . s:font_size_new . "/g'"
    silent execute "!" . sed_cmd . " " . g:kitty_config_filepath
    silent exec "!kill -s USR1 `pgrep -f kitty`"
  endif
endfunction

function s:reset_font_size()
  if $TERM ==# 'alacritty'
    let sed_cmd = "sed -i 's/" . s:font_size_new . "/" . s:font_size_current . "/g'"
    silent execute "!" . sed_cmd . " " . g:alacritty_config_filepath
  elseif $TERM ==# 'xterm-kitty'
    let sed_cmd = "sed -i 's/" . s:font_size_new . "/" . s:font_size_current . "/g'"
    silent execute "!" . sed_cmd . " " . g:kitty_config_filepath
    silent exec "!kill -s USR1 `pgrep -f kitty`"
  endif
endfunction

" ---------------------------------------------------------------------------
" Cursor color (TEMP)
" ---------------------------------------------------------------------------

function s:set_cursor_color()
  if $TERM ==# 'alacritty'
    let s:cursor_color_current = matchstr(readfile(expand(g:alacritty_config_filepath)), '^      cursor:')
    let s:cursor_color_new = '      cursor:   "' . g:slides_cursor_color . '"'
    let sed_cmd = "sed -i 's/" . escape(s:cursor_color_current, '#') . "/" . escape(s:cursor_color_new, '#') . "/g'"
    silent execute "!" . sed_cmd . " " . g:alacritty_config_filepath
  elseif $TERM ==# 'xterm-kitty'
    " Cursor color
    let s:cursor_color_current = matchstr(readfile(expand(g:kitty_config_filepath)), '^cursor ')
    let s:cursor_color_new = 'cursor ' . g:slides_cursor_color
    let sed_cmd = "sed -i 's/" . escape(s:cursor_color_current, '#') . "/" . escape(s:cursor_color_new, '#') . "/g'"
    silent execute "!" . sed_cmd . " " . g:kitty_config_filepath
    " Cursor text color
    let s:cursor_text_color_current = matchstr(readfile(expand(g:kitty_config_filepath)), '^cursor_text_color ')
    let s:cursor_text_color_new = 'cursor_text_color ' . g:slides_cursor_text_color
    let sed_cmd = "sed -i 's/" . escape(s:cursor_text_color_current, '#') . "/" . escape(s:cursor_text_color_new, '#') . "/g'"
    silent execute "!" . sed_cmd . " " . g:kitty_config_filepath
    silent exec "!kill -s USR1 `pgrep -f kitty`"
  endif
endfunction

function s:reset_cursor_color()
  if $TERM ==# 'alacritty'
    let sed_cmd = "sed -i 's/" . escape(s:cursor_color_new, '#') . "/" . escape(s:cursor_color_current, '#') . "/g'"
    silent execute "!" . sed_cmd . " " . g:alacritty_config_filepath
  elseif $TERM ==# 'xterm-kitty'
    " Cursor color
    let sed_cmd = "sed -i 's/" . escape(s:cursor_color_new, '#') . "/" . escape(s:cursor_color_current, '#') . "/g'"
    silent execute "!" . sed_cmd . " " . g:kitty_config_filepath
    " Cursor text color
    let sed_cmd = "sed -i 's/" . escape(s:cursor_text_color_new, '#') . "/" . escape(s:cursor_text_color_current, '#') . "/g'"
    silent execute "!" . sed_cmd . " " . g:kitty_config_filepath
    silent exec "!kill -s USR1 `pgrep -f kitty`"
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TEMPORAL END
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ---------------------------------------------------------------------------
" font size
" ---------------------------------------------------------------------------

"function s:set_font_size()
"  if $TERM ==# 'alacritty' && !empty(s:win_id)
"    call system(printf("alacritty msg config -w %s font.size=%s", s:win_id, g:slides_font_size))
"  elseif $TERM ==# 'xterm-kitty' && !empty(s:socket)
"    call system(printf("kitty @ --to %s set-font-size %s", s:socket, g:slides_font_size))
"    redraw
"  endif
"endfunction

"function s:reset_font_size()
"  if $TERM ==# 'alacritty' && !empty(s:win_id)
"    call system(printf("alacritty msg config -w %s --reset", s:win_id))
"  elseif $TERM ==# 'xterm-kitty' && !empty(s:socket)
"    call system(printf("kitty @ --to %s set-font-size %s", s:socket, 0))
"    redraw
"  endif
"endfunction

" ---------------------------------------------------------------------------
" Cursor color
" ---------------------------------------------------------------------------

"function s:set_cursor_color()
"  if $TERM ==# 'alacritty' && !empty(s:win_id)
"    let s:win_id = expand("$ALACRITTY_WINDOW_ID")
"    call system(printf("alacritty msg config -w %s colors.cursor.background='\"%s\"'", s:win_id, g:slides_cursor_color))
"  elseif $TERM ==# 'xterm-kitty' && !empty(s:socket)
"    " TODO: not working (apparently it is getting reset by posterior goyo configs)
"    call system(printf("kitty @ --to %s set-colors cursor=%s", s:socket, g:slides_cursor_color))
"    echom printf("kitty @ --to %s set-colors cursor=%s", s:socket, g:slides_cursor_color)
"    redraw
"  endif
"endfunction

"function s:reset_cursor_color()
"  if $TERM ==# 'alacritty' && !empty(s:win_id)
"    call system(printf("alacritty msg config -w %s --reset", s:win_id))
"  elseif $TERM ==# 'xterm-kitty' && !empty(s:socket)
"    call system(printf("kitty @ --to %s set-colors --reset", s:socket))
"    redraw
"  endif
"endfunction

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
