if exists('g:loaded_slides')
  finish
endif
let g:loaded_slides = 1

command! -nargs=? -bar -bang Present call slides#present(<bang>0, <q-args>)
