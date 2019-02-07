set -g SCM 'none'
set -g SCM_GIT_SHOW_DETAILS "true"
set -g SCM_GIT_IGNORE_UNTRACKED "false"

set -g SCM_THEME_PROMPT_DIRTY " $echo_bold_red✗$light_grey"
set -g SCM_THEME_PROMPT_CLEAN " $echo_green✓$light_grey" 
set -g SCM_THEME_PROMPT_PREFIX ''
set -g SCM_THEME_PROMPT_SUFFIX ''
set -g SCM_THEME_BRANCH_PREFIX ''
set -g SCM_THEME_TAG_PREFIX 'tag:'
set -g SCM_THEME_DETACHED_PREFIX 'detached:'
set -g SCM_THEME_BRANCH_TRACK_PREFIX ' → '
set -g SCM_THEME_BRANCH_GONE_PREFIX ' ⇢ '
set -g SCM_THEME_CURRENT_USER_PREFFIX ' ☺︎ '
set -g SCM_THEME_CURRENT_USER_SUFFIX ''
set -g SCM_THEME_CHAR_PREFIX ''
set -g SCM_THEME_CHAR_SUFFIX ''

set -g SCM_GIT 'git'
set -g SCM_GIT_CHAR "$echo_green±$light_grey" 
set -g SCM_GIT_DETACHED_CHAR '⌿'
set -g SCM_GIT_AHEAD_CHAR "↑"
set -g SCM_GIT_BEHIND_CHAR "↓"
set -g SCM_GIT_UNTRACKED_CHAR "?:"
set -g SCM_GIT_UNSTAGED_CHAR "U:"
set -g SCM_GIT_STAGED_CHAR "S:"
set -g SCM_GIT_STASH_CHAR_PREFIX "{"
set -g SCM_GIT_STASH_CHAR_SUFFIX "}"

function _git-symbolic-ref
    git symbolic-ref -q HEAD 2> /dev/null
end

function _git-branch
    git symbolic-ref -q --short HEAD 2> /dev/null || return 1
end

function _git-tag
    git describe --tags --exact-match 2> /dev/null
end

function _git-commit-description
    git describe --contains --all 2> /dev/null
end

function _git-short-sha
    git rev-parse --short HEAD
end

function _git-friendly-ref
    _git-branch || _git-tag || _git-commit-description || _git-short-sha
end

function _git-num-remotes
    git remote | wc -l
end

function _git-upstream
    set ref (_git-symbolic-ref) || return 1
    git for-each-ref --format="%(upstream:short)" "$ref"
end

function _git-upstream-remote 
    set upstream (_git-upstream) || return 1

    set branch (_git-upstream-branch) || return 1

    echo "$upstream/$branch"
end

function _git-upstream-branch
    set ref (_git-symbolic-ref)
    git for-each-ref --format="%(upstream:strip=3)" "$ref" 2> /dev/null
    or git for-each-ref --format="%(upstream)" "$ref" | sed -e "s/.*\/.*\/.*\///"
end

function _git-upstream-behind-ahead
    git rev-list --left-right --count (_git-upstream)"...HEAD" 2> /dev/null
end

function _git-upstream-branch-gone
    test (git status -s -b | sed -e 's/.* //') = "[gone]"
end

function _git-hide-status
    # test (git config --get bash-it.hide-status) = "1"
    return "0"
end

function _git-status 
    if test $SCM_GIT_IGNORE_UNTRACKED = "true"
        set -l git_status_flags "-uno"
    end
    git status --porcelain $git_status_flags 2> /dev/null
end

function _git-status-counts
    _git-status | awk '
    BEGIN {
      untracked=0;
      unstaged=0;
      staged=0;
    }
    {
      if ($0 ~ /^\?\? .+/) {
        untracked += 1
      } else {
        if ($0 ~ /^.[^ ] .+/) {
          unstaged += 1
        }
        if ($0 ~ /^[^ ]. .+/) {
          staged += 1
        }
      }
    }
    END {
      print untracked "\t" unstaged "\t" staged
    }'
end

function _git-remote-info
    set u (_git-upstream)
    if test "$u" = ""
        echo ""
        return
    end

    set b (_git-branch)
    set ub (_git-upstream-branch)
    if test "$b" = "$ub"
        set same_branch_name true
    end

    if test (_git-num-remotes) -ge 2
        if test "$same_branch_name" != "true"
            set remote_info (_git-upstream)
        else
            set remote_info (_git-upstream-remote)
        end
    else if test "$same_branch_name" != "true"
        set remote_info (_git-upstream-branch) 
    end

    if test -n "$remote_info"
        if _git-upstream-branch-gone
            set branch_prefix $SCM_THEME_BRANCH_GONE_PREFIX
        else
            set branch_prefix $SCM_THEME_BRANCH_TRACK_PREFIX
        end
        echo $branch_prefix$remote_info
    else
        echo ""
    end
end

function git_status_summary
  awk '
  BEGIN {
    untracked=0;
    unstaged=0;
    staged=0;
  }
  {
    if (!after_first && $0 ~ /^##.+/) {
      print $0
      seen_header = 1
    } else if ($0 ~ /^\?\? .+/) {
      untracked += 1
    } else {
      if ($0 ~ /^.[^ ] .+/) {
        unstaged += 1
      }
      if ($0 ~ /^[^ ]. .+/) {
        staged += 1
      }
    }
    after_first = 1
  }
  END {
    if (!seen_header) {
      print
    }
    print untracked "\t" unstaged "\t" staged
  }'
end

function git_prompt_vars
    if test (_git-branch)
        set -g SCM_GIT_DETACHED "false"
        set -g SCM_BRANCH "$SCM_THEME_BRANCH_PREFIX"(_git-friendly-ref)(_git-remote-info)
    else
        set -g SCM_GIT_DETACHED "true"
        if test (_git-tag)
            set -g detached_prefix "$SCM_THEME_TAG_PREFIX"
        else
            set -g detached_prefix "$SCM_THEME_DETACHED_PREFIX"
        end
        set -g SCM_BRANCH "$detached_prefix"(_git-friendly-ref)
    end
    set IFS \t
    echo (_git-upstream-behind-ahead)| read commits_behind commits_ahead

    if test (_git-upstream-behind-ahead)
        if test $commits_ahead -gt 0
            set -g SCM_BRANCH "$SCM_BRANCH $SCM_GIT_AHEAD_CHAR$commits_ahead"
        end
        if test $commits_behind -gt 0
            set -g SCM_BRANCH "$SCM_BRANCH $SCM_GIT_BEHIND_CHAR$commits_behind"
        end
    end
    set -g stash_count (git stash list 2> /dev/null | wc -l | tr -d ' ')
    if test $stash_count -gt 0 
        set -g SCM_BRANCH  "$SCM_BRANCH $SCM_GIT_STASH_CHAR_PREFIX$stash_count$SCM_GIT_STASH_CHAR_SUFFIX"
    end

    set -g SCM_STATE $SCM_THEME_PROMPT_CLEAN

    if test ! (_git-hide-status)
        set IFS \t
        echo (_git-status-counts)| read untracked_count unstaged_count staged_count
        if test $untracked_count -gt 0 -o $unstaged_count -gt 0 -o $staged_count -gt 0
            set -g SCM_DIRTY 1
            if test $SCM_GIT_SHOW_DETAILS = "true"
                if test $staged_count -gt 0 
                    set -g SCM_BRANCH "$SCM_BRANCH $SCM_GIT_STAGED_CHAR$staged_count"
                    set -g SCM_DIRTY 3
                end
                 if test $unstaged_count -gt 0
                    set -g SCM_BRANCH "$SCM_BRANCH $SCM_GIT_UNSTAGED_CHAR$unstaged_count"
                    set -g SCM_DIRTY 2
                end
                if test $untracked_count -gt 0 
                    set -g SCM_BRANCH "$SCM_BRANCH $SCM_GIT_UNTRACKED_CHAR$untracked_count"
                    set -g SCM_DIRTY 1
                end
            end
            set -g SCM_STATE $SCM_THEME_PROMPT_DIRTY
        end
    end
    set -g SCM_PREFIX $SCM_THEME_PROMPT_PREFIX
    set -g SCM_SUFFIX $SCM_THEME_PROMPT_SUFFIX

    set -g SCM_CHANGE (_git-short-sha 2>/dev/null || echo "")
end

function git_prompt_info
    git_prompt_vars
    echo "$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_SUFFIX"
end

function scm_check
    if test -f .git/HEAD
        set -g SCM "git"
    else if test (git rev-parse --is-inside-work-tree 2> /dev/null)
        set -g SCM "git"
    else
        set -g SCM "none"
    end
end

function scm_prompt_info
    scm_check
    if test $SCM = "git"
        echo -e "["$SCM_GIT_CHAR(git_prompt_info)"]"
    end
end
