#Vim-wrap

Vim-wrap is a plugin which automatically sets all the required settings when entering or leaving wrap mode (i.e. ':set wrap' and ':set nowrap'). By default it sets mappings for j, k, $, ^, 0, \<Down\>, \<Up\>, \<End\>, \<Home\> in Normal and
Visual mode to allow navigation through the wrapped lines. When nowrap is set mappings are restored to default ones. It changes whichwrap (allows navigation to the next line with cursor keys) and showbreak (removes anything in it).

##Installation

There are several installation options. I recommend with pathogen.vim (ref. https://github.com/tpope/vim-pathogen) like this:

```shell
cd ~/.vim/bundle
git clone https://github.com/divancic/vim-wrap
```

Once help tags have been generated, you can view the manual with `:help vim-wrap`.

##Usage

###On-Event

By default Vim wrap will not be fired automatically when you manually change the state of wrap (with e.g. `:set wrap`, `:set nowrap`, `:set wrap!`).

If you need it to be fired automatically put `g:vim_wrap_fire_on_wrap_option_change = 1` in your vimrc.

###Commands

Commands will be made available if you have `let g:vim_wrap_define_commands = 1` in your vimrc.

`:Wrap`                                             go to wrap mode
`:NoWrap`                                           go out of wrap mode
`:ToggleWrap`                                       toggle the state of wrap mode

###Mappings

If you put `let g:vim_wrap_use_default_wrap_toggle_key_mapping = 1` in your vimrc it will map `ToggleWrap` to \<leader\>w.

###Verbose

If you'd like to be notified when entering/leaving wrap mode put the following in your vimrc `let g:vim_wrap_verbose = 1`.

##Options
``` vim
g:vim_wrap_fire_on_wrap_option_change
g:vim_wrap_use_default_wrap_toggle_key_mapping
g:vim_wrap_define_commands
g:vim_wrap_verbose
```

## Author

Dorian Ivancic

## License

MIT
