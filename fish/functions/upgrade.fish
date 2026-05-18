function upgrade --description 'Upgrade the system (Arch or MacOS)'
    switch (uname)
        case Linux
            if test -e /etc/arch-release
                yay -Syu --noconfirm $argv
            else
                echo "Unsupported Linux distribution for upgrade command." >&2
                return 1
            end
        case Darwin
            if not command -v brew >/dev/null 2>&1
                echo "Homebrew is not installed." >&2
                return 1
            end
            brew update && brew upgrade && brew cleanup && brew doctor
        case '*'
            echo "upgrade is not configured for OS: (uname)" >&2
            return 1
    end
end
