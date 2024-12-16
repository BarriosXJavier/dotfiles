# My Dotfiles Repo

This repo contains my dotfiles configs for various tools.

---

## Organizing the Configuration Files

Ensure that the dotfiles are in the dotfiles repo and maintain their functionality in their original locations.

### 1. Move the Files to the Dotfiles Directory

```bash
mv ~/.tmux.conf ~/dotfiles/
mv ~/.config/nvim ~/dotfiles/nvim

2. Link the Files to Their Original Locations

This ensures the applications will still find the files in their original paths:

ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/nvim ~/.config/nvim

Set Up GitHub to Track Changes
```
