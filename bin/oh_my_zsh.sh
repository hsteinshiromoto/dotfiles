# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install powerlevel9k
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Clone dotfiles
cd ~ && git clone https://github.com/hsteinshiromoto/dotfiles.git

# Copy rc file
cp ~/dotfiles/.zshrc ~/.zshrc