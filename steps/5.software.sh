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
# CLOUD COMPUTE SHIZZLE                                                       #
###############################################################################

curl https://sdk.cloud.google.com | zsh
# Run this to configure: gcloud init
# pip3 install awscli --upgrade --user

# Google Cloud Platform: Cloud SQL Proxy
curl -o cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64
chmod +x cloud_sql_proxy
mv cloud_sql_proxy /usr/local/bin/cloud_sql_proxy


# Amazon CLI
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /



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
# RVM                                                                         #
###############################################################################

curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.profile




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
	mas install 1449412482 # Reeder
	mas install 803453959 # Slack

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
# iTerm                                                                    #
###############################################################################
brew cask install iterm


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
# QUICK LOOK PLUGINS                                                          #
###############################################################################

# https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlimagesize
brew cask install suspicious-package
brew cask install qlvideo

brew cask install provisionql
brew cask install quicklookapk

# restart quicklook
defaults write org.n8gray.QLColorCode extraHLFlags '-l'
qlmanage -r
qlmanage -m


###############################################################################
# Composer + MySQL + Valet                                                    #
###############################################################################

# Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

echo "# Composer" >> ~/.bash_profile
echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

# Composer Autocomplete
# brew install bash-completion
curl -#L https://github.com/bramus/composer-autocomplete/tarball/master | tar -xzv --strip-components 1 --exclude={LICENSE,README.md}
mv ./composer-autocomplete ~/composer-autocomplete
echo "" >> ~/.bash_profile
echo 'if [ -f "$HOME/composer-autocomplete" ] ; then' >> ~/.bash_profile
echo '    . $HOME/composer-autocomplete' >> ~/.bash_profile
echo "fi" >> ~/.bash_profile
source ~/.bash_profile

# PHP Versions
brew install php

brew services start php
brew link php

pecl install mcrypt-1.0.1 # mcrypt for PHP > 7.1
pecl install grpc # needed for google firestore et al

# @note: You might wanna "sudo brew services restart php" after this

# MySQL
brew install mysql
brew services start mysql

# Tweak MySQL
mysqlpassword="root"
echo -e "\n  What should the root password for MySQL be? (default: $mysqlpassword)"
echo -ne "  > \033[34m\a"
read
echo -e "\033[0m\033[1A"
[ -n "$REPLY" ] && mysqlpassword=$REPLY

mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '$mysqlpassword'; FLUSH PRIVILEGES;"
cat ./resources/apps/mysql/my.cnf > /usr/local/etc/my.cnf
brew services restart mysql

# Laravel Valet
composer global require laravel/valet
valet install

# If you want PMA available over https://pma.test/, run this:
# cd ~/repos/misc/
# composer create-project phpmyadmin/phpmyadmin
# cd ~/repos/misc/phpmyadmin
# valet link pma
# valet secure


###############################################################################
# OTHER BREW/CASK THINGS                                                      #
###############################################################################

brew install tig

brew install speedtest-cli
brew install jq

brew cask install 1password

brew cask install caffeine
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
brew cask install airmail
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
# Android Studio                                                              #
###############################################################################

# @ref https://gist.github.com/agrcrobles/165ac477a9ee51198f4a870c723cd441
# @ref https://gist.github.com/spilth/e7385e7f5153f76cca40a192be35f4ba

touch ~/.android/repositories.cfg

# Android Dev Tools
brew cask install caskroom/versions/java8
brew install ant
brew install maven
brew install gradle
# brew install qt
brew cask install android-sdk
brew cask install android-ndk

# SDK Components
sdkmanager "platform-tools" "platforms;android-25" "extras;intel;Hardware_Accelerated_Execution_Manager" "build-tools;25.0.3" "system-images;android-25;google_apis_playstore;x86" "emulator"
# echo y | …

# HAXM
if [ $(sw_vers -productVersion | cut -d. -f2) -lt 13 ]; then
	brew cask install intel-haxm
else
	echo -e "\n\033[93mCould not install intel-haxm on this OS. It's not supported (yet)\033[0m\n"
fi;

# ENV Variables
echo 'export ANT_HOME=/usr/local/opt/ant' >> ~/.bash_profile
echo 'export MAVEN_HOME=/usr/local/opt/maven' >> ~/.bash_profile
echo 'export GRADLE_HOME=/usr/local/opt/gradle' >> ~/.bash_profile
echo 'export ANDROID_HOME=/usr/local/share/android-sdk' >> ~/.bash_profile
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME"' >> ~/.bash_profile
echo 'export ANDROID_AVD_HOME="$HOME/.android/avd"' >> ~/.bash_profile
echo 'export ANDROID_NDK_HOME=/usr/local/share/android-ndk' >> ~/.bash_profile
echo 'export INTEL_HAXM_HOME=/usr/local/Caskroom/intel-haxm' >> ~/.bash_profile

echo 'export PATH="$ANT_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$MAVEN_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$GRADLE_HOME/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/tools:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/platform-tools:$PATH"' >> ~/.bash_profile
echo 'export PATH="$ANDROID_HOME/build-tools/25.0.3:$PATH"' >> ~/.bash_profile
# @ref https://www.bram.us/2017/05/12/launching-the-android-emulator-from-the-command-line/
echo 'export PATH="$ANDROID_HOME/emulator:$PATH"' >> ~/.bash_profile

source ~/.bash_profile

# Android Studio itself
brew cask install android-studio

# Configure Emulator
# @ref https://gist.github.com/Tanapruk/b05e97d68a5969b4402650094145e913
# @ref https://wiki.genexus.com/commwiki/servlet/wiki?14462,Creating+an+Android+Virtual+Device,
# @ref https://gist.github.com/handstandsam/f20c2fd454d3e3948f428f62d73085df
echo no | avdmanager create avd --name "Nexus_5X_API_25" --abi "google_apis_playstore/x86" --package "system-images;android-25;google_apis_playstore;x86" --device "Nexus 5X" --sdcard 128M

echo "vm.heapSize=256
hw.ramSize=1536
disk.dataPartition.size=2048MB
hw.gpu.enabled=yes
hw.gpu.mode=auto
hw.keyboard=yes
showDeviceFrame=yes
skin.dynamic=yes
skin.name=nexus_5x
skin.path=$HOME/Library/Android/sdk/skins/nexus_5x" >> ~/.android/avd/Nexus_5X_API_25.avd/config.ini

# Start it via `emulator -avd Nexus_5X_API_25`

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
