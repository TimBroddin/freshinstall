#!/usr/bin/env bash

###############################################################################
# PREVENT PEOPLE FROM SHOOTING THEMSELVES IN THE FOOT                         #
###############################################################################

starting_script=`basename "$0"`
if [ "$starting_script" != "freshinstall.sh" ]; then
	echo -e "\n\033[31m\aUhoh!\033[0m This script is part of freshinstall and should not be run by itself."
	echo -e "Please launch freshinstall itself using \033[1m./freshinstall.sh\033[0m"
	echo -e "\n\033[93mMy journey stops here (for now) … bye! 👋\033[0m\n"
	exit 1
fi;





###############################################################################
# vim                                                                         #
###############################################################################

cp ./resources/apps/vim/.vimrc ~/.vimrc





###############################################################################
# NVM + Node Versions                                                         #
###############################################################################

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | zsh
source ~/.zshrc

nvm install 7
nvm install 9
nvm install 12
nvm install node
nvm use default node

NPM_USER=""
echo -e "\nWhat's your npm username?"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && NPM_USER=$REPLY

if [ "$NPM_USER" != "" ]; then
	npm adduser $NPM_USER
fi;


###############################################################################
# Node based tools                                                            #
###############################################################################

npm i -g node-notifier-cli





###############################################################################
# Mac App Store                                                               #
###############################################################################

brew install mas

# Apple ID
if [ -n "$(defaults read NSGlobalDomain AppleID 2>&1 | grep -E "( does not exist)$")" ]; then
	AppleID=""
else
	AppleID="$(defaults read NSGlobalDomain AppleID)"
fi;
echo -e "\nWhat's your Apple ID? (default: $AppleID)"
echo -ne "> \033[34m\a"
read
echo -e "\033[0m\033[1A\n"
[ -n "$REPLY" ] && AppleID=$REPLY

if [ "$AppleID" != "" ]; then

	# Sign in
	mas signin $AppleID

	# iWork
	mas install 409203825 # Numbers
	mas install 409201541 # Pages
	mas install 409183694 # Keynote

	# Others
	mas install 587512244 # Kaleidoscope
	mas install 1482454543 # Twitter
	mas install 1529448980 # Reeder
	mas install 803453959 # Slack
	mas install 1176895641 # Spark

fi;


###############################################################################
# TMUX                                                                        #
###############################################################################

brew install tmux
brew install reattach-to-user-namespace
cp ./resources/apps/tmux/.tmux.conf ~/.tmux.conf


###############################################################################
# BROWSERS                                                                    #
###############################################################################

brew cask install firefox
brew cask install firefoxdeveloperedition
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install safari-technology-preview


###############################################################################
# CREATIVE CLOUD                                                              #
###############################################################################

brew cask install adobe-creative-cloud

###############################################################################
# IMAGE & VIDEO PROCESSING                                                    #
###############################################################################
brew install imagemagick

brew install libvpx
brew install ffmpeg
brew install youtube-dl

npm install -g youtube-dl-interactive

###############################################################################
# REACT NATIVE + TOOLS                                                        #
###############################################################################

npm install -g react-native-cli

brew install yarn
echo "# Yarn" >> ~/.bash_profile
echo 'export PATH="$HOME/.yarn/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

brew install watchman
# Watchman needs permissions on ~/Library/LaunchAgents
if [ ! -d "~/Library/LaunchAgents" ]; then
	sudo chown -R $(whoami):staff ~/Library/LaunchAgents
else
	mkdir ~/Library/LaunchAgents
fi;

brew cask install react-native-debugger

brew install --HEAD libimobiledevice
gem install xcpretty



###############################################################################
# OTHER BREW/CASK THINGS                                                      #
###############################################################################

brew install tig

brew install speedtest-cli
# brew install jq

brew cask install 1password

# brew cask install caffeine
# brew cask install nosleep

brew cask install day-o

brew cask install vlc
duti -s org.videolan.vlc public.avi all
# brew cask install plex-media-server

brew cask install ngrok

brew cask install visual-studio-code

brew cask install tower
brew cask install transmit4

brew cask install handbrake

brew cask install setapp
# brew cask install airmail
brew cask install fantastical

brew cask install imagealpha
brew cask install imageoptim
brew cask install colorpicker-skalacolor

brew cask install steam
brew cask install epic-games

brew cask install aws-vault
brew cask install hyper


brew cask install postman

brew cask install notion


###############################################################################
# Virtual Machines and stuff                                                  #
###############################################################################

# Locking down to this version (no serial for later version)
brew cask install docker


###############################################################################
# ALL DONE NOW!                                                               #
###############################################################################

echo -e "\n\033[93mSo, that should've installed all software for you …\033[0m"
echo -e "\n\033[93mYou'll have to install the following manually though:\033[0m"

echo "- Additional Tools for Xcode"
echo ""
echo "    Download from https://developer.apple.com/download/more/"
echo "    Mount the .dmg + install it from the Graphics subfolder"
echo ""

echo "- Little Snitch"
echo ""
echo "    Download from https://www.obdev.at/products/littlesnitch/index.html"
echo ""

echo "- NZBDrop"
echo ""
echo "    Download from http://www.asar.com/nzbdrop.html"
echo ""
