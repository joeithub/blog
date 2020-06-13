if [[ `ps -ef |grep "hexo" |grep -v grep ` == "" ]]; then
    cd ~/storage/downloads/www/hexoblog/
    hexo server
fi
