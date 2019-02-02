set SCM_THEME_PROMPT_DIRTY ' ✗'
set SCM_THEME_PROMPT_CLEAN ' ✓'
set SCM_THEME_PROMPT_PREFIX ' |'
set SCM_THEME_PROMPT_SUFFIX '|'
set SCM_THEME_BRANCH_PREFIX ''
set SCM_THEME_TAG_PREFIX 'tag:'
set SCM_THEME_DETACHED_PREFIX 'detached:'
set SCM_THEME_BRANCH_TRACK_PREFIX ' → '
set SCM_THEME_BRANCH_GONE_PREFIX ' ⇢ '
set SCM_THEME_CURRENT_USER_PREFFIX ' ☺︎ '
set SCM_THEME_CURRENT_USER_SUFFIX ''
set SCM_THEME_CHAR_PREFIX ''
set SCM_THEME_CHAR_SUFFIX ''

set SCM_GIT 'git'
set SCM_GIT_CHAR '±'
set SCM_GIT_DETACHED_CHAR '⌿'
set SCM_GIT_AHEAD_CHAR "↑"
set SCM_GIT_BEHIND_CHAR "↓"
set SCM_GIT_UNTRACKED_CHAR "?:"
set SCM_GIT_UNSTAGED_CHAR "U:"
set SCM_GIT_STAGED_CHAR "S:"
set SCM_GIT_STASH_CHAR_PREFIX "{"
set SCM_GIT_STASH_CHAR_SUFFIX "}"

function _git-symbolic-ref
    git symbolic-ref -q HEAD 2> /dev/null
end

function _git-branch
    git symbolic-ref -q --short HEAD 2> /dev/null
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
    _git-branch
    or _git-tag
    or _git-commit-description
    or _git-short-sha
end

function _git-num-remotes
    git remote | wc -l
end

function _git-upstream
    set ref (_git-symbolic-ref)
    git for-each-ref --format="%(upstream:short)" "$ref"
end

function _git-upstream-remote 
    set upstream (_git-upstream)
    or return 1

    set branch (_git-upstream-branch)
    or return 1

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

function _git-status 
    git status --porcelain -uno 2> /dev/null
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
    if test (_git-upstream) = ""
        return
    end

    if test (_git-branch) = (_git-upstream-branch)
        set same_branch_name true
    end

    if test $same_branch_name != "true"
        set remote_info (_git-upstream)
    else
        set remote_info (_git-upstream-remote)
    end
    if test $remote_info
        if _git-upstream-branch-gone
            set branch_prefix $SCM_THEME_BRANCH_GONE_PREFIX
        else
            set branch_prefix $SCM_THEME_BRANCH_TRACK_PREFIX
        end
        echo $branch_prefix$remote_info
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
            set -g detached_prefix $SCM_THEME_TAG_PREFIX
        else
            set -g detached_prefix $SCM_THEME_DETACHED_PREFIX
        end
        set -g SCM_BRANCH $detached_prefix(_git-friendly-ref)
    end
    set IFS \t
    echo (_git-upstream-behind-ahead)| read commits_behind commits_ahead

    if test $commits_ahead -gt 0
        set -g SCM_BRANCH $SCM_BRANCH $SCM_GIT_AHEAD_CHAR$commits_ahead
    end
    set -g stash_count (git stash list 2> /dev/null | wc -l | tr -d ' ')
end

function Test
    git_prompt_vars
    echo $SCM_BRANCH
end
