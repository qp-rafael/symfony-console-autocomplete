_symfony() {
    local state com cur

    cur=${words[${#words[@]}]}

    # lookup for command
    for word in ${words[@]:1}; do
        if [[ $word != -* ]]; then
            com=$word
            break
        fi
    done

    [[ ${cur} == --* ]] && state="option"

    [[ $cur == $com ]] && state="command"

    case $state in
        command)
            local commands;
            commands=("${(@f)$(${words[1]} list --no-ansi --raw 2>/dev/null | awk '{ gsub(/:/, "\\:", $1); print }' | awk '{print $1 ":" substr($0, index($0,$2))}')}")
            _describe 'command' commands
        ;;
        option)
            local options;
            options=("${(@f)$(${words[1]} -h ${words[2]} --no-ansi 2>/dev/null | sed -n '/Options/,/^$/p' | sed -e '1d;$d' | sed 's/[^--]*\(--.*\)/\1/' | sed -En 's/[^ ]*(-(-[[:alnum:]]+){1,})[[:space:]]+(.*)/\1:\3/p' | awk '{$1=$1};1')}")
            _describe 'option' options
        ;;
        *)
            # fallback to file completion
            _arguments '*:file:_files'
    esac
}

%%TOOLS%%
