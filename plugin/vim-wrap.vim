if exists("g:loaded_vim_wrap") || v:version < 700
  finish
endif
let g:loaded_vim_wrap = 1


let g:vim_wrap_fire_on_wrap_option_change = 1
function! s:FireOnWrapOptionChange()
  return get(g:, 'vim_wrap_fire_on_wrap_option_change', 0)
endfunction

let g:vim_wrap_use_default_wrap_toggle_key_mapping = 1
function! s:UseVimWrapWrapToggleMapping()
  return get(g:, 'vim_wrap_use_default_wrap_toggle_key_mapping', 0)
endfunction

let s:normal_maps = {
  \ 'j':      'j',
  \ 'k':      'k',
  \ '$':      '$',
  \ '^':      '^',
  \ '0':      '0',
  \ '<Down>': 'j',
  \ '<Up>':   'k',
  \ '<End>':  '$',
  \ '<Home>': '^'}

let s:visual_maps = s:normal_maps

let s:insert_maps = {
  \ '<Down>': 'ja',
  \ '<Up>':   'ka',
  \ '<End>':  '$a',
  \ '<Home>': '^a'}



function! s:Remap(mode, wrap)
  let l:map_command = 'noremap' . ' '
  let l:map_prefix = '' . ' '
  let l:map_sufix = ''

  if a:mode ==# 'normal'
    let l:map_command = 'n' . l:map_command
    let l:map_prefix = l:map_prefix . ''
    let l:map_sufix = l:map_sufix . ''
    let l:maps = s:normal_maps

  elseif a:mode ==# 'visual'
    let l:map_command = 'v' . l:map_command
    let l:map_prefix = l:map_prefix . ':<C-U>normal! gv'
    let l:map_sufix = l:map_sufix . '<CR>'
    let l:maps = s:visual_maps

  elseif a:mode ==# 'insert'
    let l:map_command = 'i' . l:map_command
    let l:map_prefix = l:map_prefix . '<Esc>'
    let l:map_sufix = l:map_sufix . ''
    let l:maps = s:insert_maps
  endif

  if a:wrap ==# 'wrap'
    let l:map_prefix = l:map_prefix . 'g'
  endif

  for key in keys(l:maps)
    echo l:map_command . key . l:map_prefix . l:maps[key] . l:map_sufix
  endfor
endfunction

function! s:RemapAllModes(wrap)
  for l:mode in ['normal', 'visual', 'insert']
    call s:Remap(l:mode, a:wrap)
  endfor
endfunction

function! s:Wrap()
  if !s:FireOnWrapOptionChange()
    set wrap
  endif

  call s:RemapAllModes('wrap')
endfunction

function! s:NoWrap()
  if !s:FireOnWrapOptionChange()
    set nowrap
  endif

  call s:RemapAllModes('nowrap')
endfunction



" EXTERNAL HOOKS

" option change (i.e. set wrap / set nowrap) {{{
if s:FireOnWrapOptionChange()
  function! <SID>OnWrapOptionChange()
    if expand("<amatch>") ==# 'wrap'
      let s:out = "WRAP"
      if v:option_new == 0
        call s:NoWrap()
        let s:out = s:out . " [OFF]"
      else
        call s:Wrap()
        let s:out = s:out . " [ON]"
      endif
      echo s:out
    endif
  endfunction

  augroup onWrapOptionChange
    autocmd!
    autocmd OptionSet *         call <SID>OnWrapOptionChange()
  augroup END
endif
" }}}

" keyboard shortcut hook (e.g. <leader>w toggles wrap) {{{
if s:UseVimWrapWrapToggleMapping()
  function! <SID>ToggleWrap()
    if &wrap
      call s:NoWrap()
    else
      call s:Wrap()
    endif
  endfunction

  nnoremap <silent> <leader>w   :call <SID>ToggleWrap()<CR>
endif
" }}}

" commands (i.e. :Wrap, :NoWrap, :ToggleWrap) {{{
command! Wrap                   call s:Wrap()
command! NoWrap                 call s:NoWrap()
command! ToggleWrap             call <SID>ToggleWrap()
" }}}


finish






function! FuncIns2()
  normal g$
  if (col(".") == col("$") - 1)
    "normal! gg
    "echo "a"
    "return "a"
    execute 'normal a'
  else
    "normal! G
    "echo "i"
    "return "i"
    execute 'normal i'
  endif
endfunction

"   Wrap plugin (showbreak off)
"     sets showbreak breakwidth to the number width when numbers show, 0 otherwise (see n in cpoptions), whichwrap
