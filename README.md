# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## What's managed

### Dotfiles (source-controlled)

| Target path | Notes |
|---|---|
| `~/.zshrc` | Zsh config (oh-my-zsh, aliases, PATH, …) |
| `~/.zprofile` | Zsh login profile |
| `~/.p10k.zsh` | Powerlevel10k prompt config |
| `~/.gitconfig` + `~/.gitconfig.d/` | Git config with work/personal profile switching |
| `~/.ssh/config` | SSH host config |
| `~/.ssh/id_ed25519.pub` | SSH public key |
| `~/.yarnrc` | Yarn config |
| `~/.npmrc` | npm config |
| `~/.bundle/config` | Bundler mirror config |
| `~/.pip/pip.conf` | pip mirror config (legacy path) |
| `~/.config/bat/` | bat syntax highlighter + Catppuccin themes |
| `~/.config/htop/` | htop config |
| `~/.config/karabiner/` | Karabiner-Elements key remapping (macOS only) |
| `~/.config/lazygit/` | Lazygit config |
| `~/.config/mise/` | mise (tool version manager) config |
| `~/.config/pip/` | pip mirror config |
| `~/.config/pnpm/` | pnpm config |
| `~/.config/ranger/` | Ranger file manager (config, commands, colorscheme) |
| `~/.config/tmux/` | Tmux config + custom status modules |
| `~/.config/uv/` | uv Python package manager config |
| `~/.config/wezterm/` | WezTerm terminal config |
| `~/.config/zsh/` | Custom oh-my-zsh plugins (`myfzf`, `mytsh`) |

### Encrypted secrets

Stored as `*.age` blobs, decrypted transparently by chezmoi on `apply`.

| Encrypted source | Installed target | Contents |
|---|---|---|
| `encrypted_private_dot_zshenv.sec.age` | `~/.zshenv.sec` | Secret environment variables |
| `encrypted_private_dot_git-credentials.age` | `~/.git-credentials` | Git credential store |
| `private_dot_ssh/encrypted_private_id_ed25519.age` | `~/.ssh/id_ed25519` | SSH private key |
| `dot_config/private_sops/private_age/encrypted_private_keys.txt.age` | `~/.config/sops/age/keys.txt` | SOPS age decryption keys |

### External repos (via `.chezmoiexternal.toml`)

Cloned and kept up-to-date by chezmoi, not stored in this repo.

| Target path | Source |
|---|---|
| `~/.oh-my-zsh` | [ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) |
| `~/.oh-my-zsh/custom/themes/powerlevel10k` | [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) |
| `~/.oh-my-zsh/custom/plugins/zsh-autosuggestions` | [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) |
| `~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting` | [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) |
| `~/.oh-my-zsh/custom/plugins/zsh-fzf-history-search` | [joshskidmore/zsh-fzf-history-search](https://github.com/joshskidmore/zsh-fzf-history-search) |
| `~/.config/ranger/colorschemes/dracula` | [dracula/ranger](https://github.com/dracula/ranger) |
| `~/.config/ranger/plugins/zoxide` | [jchook/ranger-zoxide](https://github.com/jchook/ranger-zoxide) |
| `~/.config/nvim` | your nvim config repo |

Files prefixed `private_` are installed with `600` permissions.

---

## New machine setup

### 1. Install chezmoi

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
```

### 2. Initialize and apply

```bash
~/.local/bin/chezmoi init --apply kangeek
```

The init process will prompt you interactively. Each tool question looks like:

```
Install lazygit?
Install zsh + oh-my-zsh + p10k?
> bool, default true
```

Type `true` / `false` (or just press Enter to accept the default) for each prompt. Full prompt sequence:

```
Age private key (AGE-SECRET-KEY-1..., leave empty to skip — encrypted files will not sync):

Install zsh + oh-my-zsh + p10k?            (default: true)
Install shell tools (zoxide, bat, eza...)? (default: true)
Install htop?                              (default: true)
Install mise (tool version manager)?       (default: true)
Install tmux?                              (default: true)
Install lazygit?                           (default: false)
Install neovim + ripgrep + fd-find?        (default: false)
Install uv (Python package manager)?       (default: false)
Install sops?                              (default: false)
Install wezterm (macOS only)?              (default: false)
Install karabiner-elements (macOS only)?   (default: false)
```

- **Age key**: paste your `AGE-SECRET-KEY-1...` private key for full encryption support, or leave empty to skip
- **Tools**: press Enter to accept the default; type `true` or `false` to override
- Prerequisites (`curl`, `wget`, `gpg`, `age`, `git`, `git-delta`) are installed automatically before anything else
- All tools are installed idempotently — already-installed tools are skipped

---

## Daily operations

> The alias `df="chezmoi"` is defined in `.zshrc`, so `df` and `chezmoi` are interchangeable below.

### Edit a managed file

```bash
chezmoi edit ~/.zshrc
chezmoi edit ~/.gitconfig
chezmoi edit ~/.zshenv.sec   # encrypted: opens decrypted, saves re-encrypted
```

### Apply pending changes (source → home)

```bash
chezmoi diff    # preview what would change
chezmoi apply
```

### Pull upstream changes and apply

```bash
chezmoi update  # git pull + pull all external repos + apply
```

### Add a new file

```bash
chezmoi add ~/.config/some-tool/config          # plain file
chezmoi add --encrypt ~/.some-secret-file       # encrypted
```

### Install a previously skipped tool

```bash
# Edit your local chezmoi config and flip the flag to true
vim ~/.config/chezmoi/chezmoi.toml

# Apply — chezmoi detects the install script content changed and re-runs it
# Already-installed tools are skipped automatically
df apply
```

### Check status

```bash
chezmoi status    # files that differ between source and home
chezmoi managed   # list all managed files
chezmoi doctor    # verify chezmoi environment and config
```

### Commit and push

```bash
chezmoi git add -- .
chezmoi git commit -- -m "your message"
chezmoi git push
```

---

## Security

- `gitleaks` runs as a `pre-commit` hook to catch accidental secret commits.
- `.gitignore` excludes `*.sec`, `*.key`, `.env`, `*.pem`, and similar patterns.
- `.chezmoiignore` prevents `chezmoi add` from pulling in external repo directories.
- See `.gitleaks.toml` for project-specific allowlist rules.
- The age private key (`~/.config/chezmoi/key.txt`) **must be backed up** in a
  password manager — losing it means losing access to all encrypted files permanently.
- `~/.zshenv.sec` (sourced by `.zshrc`) and `~/.zshrc.local` are for machine-local
  secrets and overrides that should never be committed.

### Manual secret scan

Run gitleaks at any time to check all files in the source directory:

```bash
# Scan all files (no git history required)
cd ~/.local/share/chezmoi
gitleaks detect --config .gitleaks.toml --no-git --redact

# Scan only what is currently staged (same as the pre-commit hook)
gitleaks protect --staged --config .gitleaks.toml --redact

# Verbose output — show which rule triggered (omit --redact to see the value)
gitleaks detect --config .gitleaks.toml --no-git --verbose --redact
```

If gitleaks reports a false positive, add an allowlist entry to `.gitleaks.toml`
under the `[allowlist]` section and re-run to confirm.
