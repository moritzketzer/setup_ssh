#!/usr/bin/env sh

echo "Generating a new SSH key for GitHub"

# Generating a new SSH key
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
ssh-keygen -t ed25519 -C $1 -f ~/.ssh/id_ed25519_$2 -N $3

# Adding your SSH key to the ssh-agent
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
eval "$(ssh-agent -s)"

if [ -f ~/.ssh/config ]; then
    # Append line to existing config file
    echo "  IdentityFile ~/.ssh/id_ed25519_$2" >> ~/.ssh/config
    
    echo "These keys are currently present:"
    ls -lA ~/.ssh
    
    echo "The updated config file is as follows:"
    cat ~/.ssh/config
    
else
    # Create config file with line
    echo "Host *\n  AddKeysToAgent yes\n  UseKeychain yes\n  IdentityFile ~/.ssh/id_ed25519_$2" > ~/.ssh/config
fi

# Add private key to ssh-agent 
spawn ssh-add --apple-use-keychain ~/.ssh/id_ed25519_$2
expect "Enter passphrase for /Users/moritz/.ssh/id_ed25519_$2:"
send "$3\n";


# Copy public key and add to github.com > Settings > SSH and GPG keys
pbcopy < ~/.ssh/id_ed25519_$2.pub

# Adding your SSH key to your GitHub account
# https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
echo "ran 'pbcopy < ~/.ssh/id_ed25519_$2.pub' -> paste that into GitHub under Settings -> Access -> SSH and GPG Keys"
