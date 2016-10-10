" MODELINE {{{
" vim: set foldmethod=marker foldlevel=0 sw=2 ts=2 sts=2 et tw=0:
" }}}
" THE POWER OF A DOT {{{
"
"   _____ _                                                  __
"  |_   _| |__   ___   _ __   _____      _____ _ __    ___  / _|   __ _
"    | | | '_ \ / _ \ | '_ \ / _ \ \ /\ / / _ \ '__|  / _ \| |_   / _` |
"    | | | | | |  __/ | |_) | (_) \ V  V /  __/ |    | (_) |  _| | (_| |  _
"    |_| |_| |_|\___| | .__/ \___/ \_/\_/ \___|_|     \___/|_|    \__,_| (_)
"                     |_|
"
" This is a VIM-WRAP PLUGIN!
"
" Copyright (c) 2016 Dorian Ivancic
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.
"
" }}}
" HELPERS {{{
if exists("g:loaded_vim_wrap") || v:version < 700
  finish
endif
let g:loaded_vim_wrap = 1

"let g:vim_wrap_fire_on_wrap_option_change = 1
function! s:FireOnWrapOptionChange()
  return get(g:, 'vim_wrap_fire_on_wrap_option_change', 0)
endfunction

"let g:vim_wrap_use_default_wrap_toggle_key_mapping = 1
function! s:UseVimWrapWrapToggleMapping()
  return get(g:, 'vim_wrap_use_default_wrap_toggle_key_mapping', 0)
endfunction

"let g:vim_wrap_define_commands = 1
function! s:DefineVimWrapCommands()
  return get(g:, 'vim_wrap_define_commands', 0)
endfunction

"let g:vim_wrap_verbose = 1
function! s:Verbose()
  return get(g:, 'vim_wrap_verbose', 0)
endfunction
" }}}
" MAPING RELATED {{{
" maps definition {{{
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
  \ '<End>':  '$i',
  \ '<Home>': '^i'}
" }}}
" maps functions {{{
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
    execute l:map_command . key . l:map_prefix . l:maps[key] . l:map_sufix
  endfor
endfunction

function! s:RemapModes(wrap)
  for l:mode in ['normal', 'visual', 'insert']
    call s:Remap(l:mode, a:wrap)
  endfor
endfunction
" }}}
" }}}
" SCRIPT PRIVATE WRAP & NOWRAP FUNCTIONS {{{
let s:saved_showbreak=""
let s:saved_whichwrap=""

" Wrap() {{{
function! s:Wrap()
  " in case we have a hook to option change
  if s:FireOnWrapOptionChange()
    " if the option is set, we were called
    " through the change option hook
    if &wrap
      " so we setup mappings and continue
      call s:RemapModes('wrap')

    " the wrap option is not set, but the
    " hook to option change is in place
    else
      " so we set the wrap option
      " and return
      set wrap
      return
    endif

  " in case there is no option change
  " hook in place
  else
    " we do everything manually
    set wrap
    call s:RemapModes('wrap')
  endif

  " common setup goes beyond this line

  " save the value of whichwrap and add <Left>
  " and <Right> to it on order to allow moving
  " to the previous/next line when at start/end
  " of line
  let s:saved_whichwrap=&whichwrap
  set whichwrap+=<,>

  " save the value of showbreak and turn it off
  let s:saved_showbreak=&showbreak
  set showbreak=

  if s:Verbose()
    echo "WRAP [ON]"
  endif
endfunction
" }}}
" NoWrap {{{
function! s:NoWrap()
  " in case we have a hook to option change
  if s:FireOnWrapOptionChange()
    " if the option is set, we were called
    " through the change option hook
    if !&wrap
      " so we restore mappings and continue
      call s:RemapModes('nowrap')

    " the wrap option is not set, but the
    " hook to option change is in place
    else
      " so we restore the wrap option
      " and return
      set nowrap
      return
    endif

  " in case there is no option change
  " hook in place
  else
    " we do everything manually
    set nowrap
    call s:RemapModes('nowrap')
  endif

  " restore the saved values
  let &whichwrap=s:saved_whichwrap
  let &showbreak=s:saved_showbreak

  if s:Verbose()
    echo "WRAP [OFF]"
  endif
endfunction
" }}}
" }}}
" EXTERNAL HOOKS {{{
" option change (i.e. set wrap / set nowrap) {{{
if v:version >= 800
  if s:FireOnWrapOptionChange()
    function! <SID>OnWrapOptionChange()
      if expand("<amatch>") ==# 'wrap'
        if v:option_new == 0
          call s:NoWrap()
        else
          call s:Wrap()
        endif
      endif
    endfunction

    augroup onWrapOptionChange
      autocmd!
      autocmd OptionSet *         call <SID>OnWrapOptionChange()
    augroup END
  endif
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
if s:DefineVimWrapCommands()
  command! Wrap                 call s:Wrap()
  command! NoWrap               call s:NoWrap()
  command! ToggleWrap           call <SID>ToggleWrap()
endif
" }}}
" }}}
" KNOWN ISSUES / BUGS {{{
" Known issues / bugs:
"   - when in insert mode, <End> works fine for all lines of wrapped line except for the list line, it positions the cursor just before the last character
"   - when in insert mode and moving arround with <Up> and <Down> it sometimes drop out of insert mode
"   - when entering wrap mode (e.g. set wrap) values of whichwrap and showbreak are saved to internal values and then restored when getting out (e.g. set nowrap)
"     if set nowrap is called first the original values set by the user are going to be lost
"
" I do not consider these to be serious bugs as you shouldn't navigate when in insert mode. Come to think of it, you shuldn't navigate with cursor keys at all. :)
" See: hardmode (https://github.com/wikitopian/hardmode)
" }}}
