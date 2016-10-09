#Vim-wrap

Vim-wrap is a plugin which automatically sets all the required settings when
entering or leaving wrap mode (i.e. ':set wrap' and ':set nowrap'). By default
it sets mappings for j, k, $, ^, 0, <Down>, <Up>, <End>, <Home> in Normal and
Visual mode to allow navigation through the wrapped lines. When nowrap is set
mappings are restored to default ones. It changes whichwrap (allows navigation
to the next line with cursor keys) and showbreak (removes anything in it).

##Installation

There are several installation options. I recommend with pathogen.vim (ref.
https://github.com/tpope/vim-pathogen) like this:

  cd ~/.vim/bundle
  git clone https://github.com/divancic/vim-wrap

Once help tags have been generated, you can view the manual with ':help
vim-wrap'.

##Usage

###On-Event

By default Vim wrap will not be fired automatically when you manually change
the state of wrap (with e.g. :set wrap, :set nowrap, :set wrap!). If you need
it to be fired automatically put 'g:vim\_wrap\_fire\_on\_wrap\_option\_change = 1'
in your vimrc.

###Commands

Commands will be made available if you have 'let g:vim\_wrap\_define\_commands = 1'
in your vimrc.

:Wrap                                             go to wrap mode
:NoWrap                                           go out of wrap mode
:ToggleWrap                                       toggle the state of wrap mode

###Mappings

If you put 'let g:vim\_wrap\_use\_default\_wrap\_toggle\_key\_mapping = 1' in your
vimrc it will map ToggleWrap to <leader>w. 

###Verbose

If you'd like to be notified when entering/leaving wrap mode put the following
in your vimrc 'let g:vim\_wrap\_verbose = 1'.

##Options

g:vim\_wrap\_fire\_on\_wrap\_option\_change
g:vim\_wrap\_use\_default\_wrap\_toggle\_key\_mapping
g:vim\_wrap\_define\_commands
g:vim\_wrap\_verbose

## Author

Dorian Ivancic

## License

MIT
