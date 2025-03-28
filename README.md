# My Dotfiles Repo

This repo contains my dotfiles configs for various tools.

---

## Organizing the Configuration Files

Ensure that the dotfiles are in the dotfiles repo and maintain their functionality in their original locations.

### 1. Move the Files to the Dotfiles Directory

```
    mv ~/.tmux.conf ~/dotfiles/.config/
    mv ~/.config/nvim ~/dotfiles/.config/nvim
    mv ~/.config/starship.toml ~/dotfiles/.config/
```

2. Link the Files to Their Original Locations

This ensures the applications will still find the files in their original paths:

```
    ln -s ~/dotfiles/.config/.tmux.conf ~/.tmux.conf
    ln -s ~/dotfiles/.config/nvim ~/.config/nvim
    ln -s ~/dotfiles/.config/starship.toml ~/.config/starship.toml
```

3. Set Up Git to Track Changes
