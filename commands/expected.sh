#!/usr/bin/env bash

## author: KleiberXD

set -e

expected_tpp_solution() {
    local name=${1}

    local dir=""
    local filename=""
    local configDir=${CONFIG_DIR}
    local configFile="${CONFIG_DIR}/${CONFIG_FILE}"
    local exp=${EXPECTED_FILE}

    # check if the solution name is an argument
    if [[ ! ${name} ]]; then
        if ! fileExists ${configFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi

        filename=$(get_name_from_config ${configFile})
    else
        dir="${TPP_WORKSPACE}/${name}"
        configDir="${dir}/${configDir}"
        configFile="${dir}/${configFile}"
        exp="${dir}/${exp}"

        if ! dirExists ${dir}; then
            echo "Error: '${name}' solution does not exist." >&2
            exit 1
        fi

        if ! fileExists ${configFile}; then
            echo "Error: there is not a solution, tpp config file does not exist." >&2
            exit 1
        fi

        filename=$(get_name_from_config ${configFile})
        filename="${dir}/${filename}"
    fi

    if ! fileExists ${exp}; then
        echo "Error: '$(basename ${filename%.*})' solution does not contain the exp file." >&2
        exit 1
    fi

    # last update
    set_last_update_into_config ${configFile} "$(date +"%d-%m-%Y") $(date +"%T")"

    # open source code using vim editor
    ${TPP_IDE} ${exp}
}

expected_help() {
    cat <<EOF

Open exp.tpp file into the solution name. If the command is run from within the
solution directory, the solution name is an optional argument.

Usage:  tpp exp [solution-name]

Options:
  -h, --help   Show more information about command

Run 'tpp COMMAND --help' for more information about a given command.
EOF
}

expected_cmd() {
   if [[ ${#} -gt 1 ]]; then
        echo "Error: Invalid number of arguments." >&2
        exit 1
    fi

    local argument=${1}
    case ${argument} in
        --help | -h)
            expected_help
            ;;
        *)
            expected_tpp_solution ${argument}
            ;;
    esac
}
