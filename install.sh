#!/bin/bash

# 下载 Homebrew
# https://brew.sh/
# https://formulae.brew.sh/formula/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Set default
chsh -s /bin/bash
# Change Host
sudo scutil --set HostName GenchSusu

# 判断网络
curl --connect-timeout 1 http://youtube.com/favicon.ico
if [ $? = 0 ];then
	git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
	git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
	git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git

	# 删除 ~/.bash_profile 中的HOMEBREW_BOTTLE_DOMAIN
	sed -i '' '/HOMEBREW_BOTTLE_DOMAIN/d' ~/.bash_profile
else
	git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
	git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
	git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git

	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/' >> ~/.bash_profile
	source ~/.bash_profile
fi

brew update
brew install $(< ./files/brew_list.txt)

# Init Bash
sed -i '' 's#^/bin/bash#/usr/local/bin/bash#g' /etc/shells
chsh -s /usr/local/bin/bash
cp ./files/.bash_profile ~/.bash_profile
cp ./files/kube-ps1.sh /usr/local/opt/kube-ps1/share/kube-ps1.sh
# krew
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)
source ~/.bash_profile

# 下载第三方应用
brew install --cask $(< ./files/brew_cask_list.txt)
# iterm2
cp ./files/Profiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/

# appcleaner \
# microsoft-office \

# 下载 Mac App Store 应用
# https://github.com/mas-cli/mas
# mas help
mas install  425424353 # the unarchiver
mas purchase 431364704 # White Noise Lite
mas install  836500024 # wechat
mas install  451108668 # qq

# 自动安装pakcages的dmg和zip文件
# install_dmg(){
#     hdiutil attach $1 -nobrowse
#     cp -rf /Volumes/$2/$3 /Applications
#     hdiutil detach /Volumes/$2
# }

# install_zip(){
#     unzip -o $1/$2 -d $1 
#     mv -f $1/$3 /Applications
#     rm -r $1/__MACOSX
# }

# 1、相对路径下的dmg文件。2、挂载后的磁盘镜像名称。3、镜像内的APP名字
# install_dmg "QQ/QQ_V6.0.1.dmg" "QQ" "QQ.app"

# 1、相对路径的文件夹名。2、zip压缩包名。3、解压后的APP名
# install_zip "Dropbox" "Dropbox.zip" "Dropbox.app"