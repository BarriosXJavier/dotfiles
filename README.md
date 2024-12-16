# My dotfiles repo

This repo contains my dotfiles configs for various tools.

## Organizing the configuration files

Ensure that the dotfiles are in the dotfiles repo and they maintain their functionality in their original locations

    1. Move the files to the dotfiles directory:
        ```
            mv ~/.tmux.conf ~/dotfiles/
            mv ~/.config/nvim ~/dotfiles/nvim
        ```

    2. Link the files to their original locations to ensure the applications will still find the files in their original paths:
        ```
            ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
            ln -s ~/dotfiles/nvim ~/.config/nvim

        ```

## Set up github to track changes
