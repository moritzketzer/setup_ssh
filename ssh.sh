#!/usr/bin/env sh

echo "Generating a new SSH key for GitHub, please use a passphrase ..."

# Generating a new SSH key
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
ssh-keygen -t ed25519 -C $1 -f ~/.ssh/id_ed25519_$2

# Adding your SSH key to the ssh-agent
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent
eval "$(ssh-agent -s)"

<< EOF > ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519_$2
EOF

# Add private key to ssh-agent 
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_$2

# Copy public key and add to github.com > Settings > SSH and GPG keys
pbcopy < ~/.ssh/id_ed25519_$2.pub

# Adding your SSH key to your GitHub account
# https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
echo "ran 'pbcopy < ~/.ssh/id_ed25519_$2.pub' -> paste that into GitHub under Settings -> Access -> SSH and GPG Keys"
