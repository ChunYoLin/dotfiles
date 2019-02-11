. ~/.config/fish/color.fish
. ~/.config/fish/alias.fish
. ~/.config/fish/git.fish
. ~/.config/fish/key_binding.fish


set fish_color_cwd yellow

function fish_prompt
    set_color blue
    printf "%s " (date +%D\ %H:%M)
    set last_status $status
    set_color cyan
    printf '%s' (whoami)
    tput setaf 8
    printf '@'
    tput setaf 172
    printf '%s ' (hostname)
    set_color $fish_color_cwd

    set -g fish_prompt_pwd_dir_length 0
    printf '%s' (prompt_pwd)
    set_color normal
    printf ' %s ' (scm_prompt_info)
    set_color normal
end

set -x NVM_DIR "~/.nvm"
test -s "$NVM_DIR/nvm.sh"  && . "$NVM_DIR/nvm.sh"  # This loads nvm

# cd with ls
function chpwd --on-variable PWD
  status --is-command-substitution; and return
  ll
end

# opencv library path
set -x LD_LIBRARY_PATH  $LD_LIBRARY_PATH:/usr/local/lib
# cuda path
set -x PATH  "$PATH:/usr/local/cuda-8.0/"
set -x PATH  "$PATH:/usr/local/cuda-8.0/bin"
set -x LD_LIBRARY_PATH  "$LD_LIBRARY_PATH:/usr/local/cuda-8.0/lib64:/usr/local/cuda-8.0/lib64/stubs"
set -x TERM  screen-256color

#PYTHONPATH
set -x PYTHONPATH  "$PYTHONPATH:/usr/local/lib/python2.7/site-packages:/home/chunyo/pyvision/src"
set -x PYTHONPATH  "$PYTHONPATH:/usr/local/lib/python2.7/dist-packages"

# added by Anaconda2 4.2.0 installer
# set -x PATH  "/home/chunyo/anaconda2/bin:$PATH"
set -e GNOME_KEYRING_CONTROL
set -x CLICOLOR  'true'
# added by Anaconda3 installer
set -x PATH  "/Users/chunyo/anaconda3/bin:$PATH"
# golang
set -x PATH  "$PATH:/Users/chunyo/package/go/bin"
set -x GOROOT_BOOTSTRAP  "/Users/chunyo/package/go"
