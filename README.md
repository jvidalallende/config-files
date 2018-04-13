# config-files

Text based configuration files for several tools I use

Vim plugins are stored as submodules, so use recursive cloning to initialize
them:

    git clone --recursive [-jX]

For already cloned repositories, use this command to initialize them:

    git submodule update --init --recursive

To update the submodules to latest versions on their MASTER branches, use:

    git submodule update --remote --merge
