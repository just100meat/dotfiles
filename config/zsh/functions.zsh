ZPLUGDIR="${ZPLUGDIR:-$XDG_DATA_HOME/zsh}"
ZCOMPDIR="${ZDOTDIR}/tabtab"

_zplug() {
  mkdir -p "${ZPLUGDIR}" || return 1

  case "$1" in
  "")
    _zplug_usage
    return 1
    ;;
  update)
    local found=0

    for plugin in "${ZPLUGDIR}"/*(N/); do
      [[ -d "${plugin}/.git" || -f "${plugin}/.git" ]] || continue
      found=1

      local name="${plugin:t}"
      echo "Updating plugin: ${name}..."

      if git -C "${plugin}" pull --quiet --ff-only --recurse-submodules; then
        echo "Plugin updated: ${name}"
      else
        local exit_code=$?
        echo "Failed to update plugin: ${name} (${exit_code})" >&2
        return "${exit_code}"
      fi
    done

    ((found)) || echo "No plugins found."
    ;;
  *)
    local input="$1"
    [[ -z "${input}" ]] && return 1

    local repo="${input}"
    local name="${input:t:r}"
    local dest="${ZPLUGDIR}/${name}"

    if [[ "${input}" =~ '^(https?|git|ssh)://' ]] || [[ "${input}" == *@*:* ]]; then
      :
    else
      repo="https://github.com/${repo}.git"
    fi

    if [[ ! -d "${dest}" ]]; then
      echo "Downloading plugin $name..."

      local -a clone_cmd=(git clone --quiet --depth 1)
      if "${clone_cmd[@]}" "${repo}" "${dest}"; then
        echo "Plugin installed: ${name}"
      else
        local exit_code=$?
        echo "Cloning failed with exit code ${exit_code}" >&2
        return "${exit_code}"
      fi
    fi

    for entry in "${dest}/${name}.plugin.zsh" "${dest}/${name}.zsh" "${dest}/init.zsh"; do
      if [[ -f "${entry}" ]]; then
        source "$entry"
        return $?
      fi
    done

    echo "Warning: Could not find plugin file in ${dest}"
    return 1
    ;;
  esac
}

_zplug_usage() {
  cat <<'EOF' >&2
Usage:
  _zplug <repository>
      Install and load a plugin from GitHub or a Git repository.

  _zplug update
      Update all installed plugins.

Examples:
  _zplug zsh-users/zsh-autosuggestions
      Install a GitHub plugin.

  _zplug https://github.com/zsh-users/zsh-autosuggestions.git
      Install using a repository URL.

  _zplug update
      Update all installed plugins.
EOF
}

_zcomp() {
  mkdir -p "${ZCOMPDIR}" || return 1

  case "$1" in
  "")
    _zcomp_usage
    return 1
    ;;
  update)
    if [[ -n "$2" ]]; then
      echo "Updating completion: $2..."
      _zcomp_generate "$2"
      return $?
    fi

    local status=0
    for file in "${ZCOMPDIR}"/_*(N); do
      [[ -f "${file}" ]] || continue

      local cmd="${file:t}"
      cmd="${cmd#_}"

      echo "Updating completion: ${cmd}..."
      _zcomp_generate "${cmd}" || status=1
    done

    return "${status}"
    ;;
  *)
    local cmd="$1"
    local file="${ZCOMPDIR}/_${cmd}"

    if [[ -f "${file}" ]]; then
      return 0
    fi

    echo "Generating completion: ${cmd}..."
    _zcomp_generate "${cmd}"
    ;;
  esac
}

_zcomp_usage() {
  cat <<"EOF" >&2
Usage:
_zcomp <command>
    Initialize completion for a command.

_zcomp update [command]
    Update all initialized completions, or only the specified command.

Examples:
_zcomp docker
    Generate Docker completion.

_zcomp update
    Regenerate all existing completions.

_zcomp update docker
    Regenerate Docker completion.
EOF
}

_zcomp_generate() {
  local cmd="$1"
  local output="${ZCOMPDIR}/_${cmd}"
  local tmp="${output}.tmp.$$"

  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Command not found: ${cmd}" >&2
    return 127
  fi

  if "$cmd" completion zsh >"$tmp" 2>/dev/null && [[ -s "$tmp" ]]; then
    if mv -f "$tmp" "$output"; then
      echo "Completion generated: ${cmd}"
      return 0
    fi
  fi

  rm -f "$tmp"
  echo "Failed to generate completion: ${cmd}" >&2
  return 1
}
