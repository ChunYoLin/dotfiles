. ~/.config/fish/color.fish
. ~/.config/fish/alias.fish
. ~/.config/fish/git.fish
. ~/.config/fish/key_binding.fish


set fish_color_cwd yellow

function fish_prompt
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
