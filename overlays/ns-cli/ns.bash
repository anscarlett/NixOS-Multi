# ns completion                                            -*- shell-script -*-

# This bash completions script was generated by
# completely (https://github.com/dannyben/completely)
# Modifying it manually is not recommended

_ns_completions_filter() {
  local words="$1"
  local cur=${COMP_WORDS[COMP_CWORD]}
  local result=()

  if [[ "${cur:0:1}" == "-" ]]; then
    echo "$words"
  
  else
    for word in $words; do
      [[ "${word:0:1}" != "-" ]] && result+=("$word")
    done

    echo "${result[*]}"

  fi
}

_ns_completions() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")
  local compline="${compwords[*]}"

  case "$compline" in
    *)
      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_ns_completions_filter "which log boot switch upgrade hmswitch hmsource hmprofiles hmdiff diff source installed profiles generations references depends git-fetch-merge pr-pull pr-build pr-build-impure run-impure shell-impure hash2sri indexdb-update")" -- "$cur" )
      ;;

  esac
} &&
complete -F _ns_completions ns

# ex: filetype=sh
