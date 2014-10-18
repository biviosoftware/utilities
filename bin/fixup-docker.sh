#!/bin/sh
set -ex
cp -a /etc/skel/.??* /root
cat > /.bashrc << 'EOF'
export HOME=/root
cd $HOME
. ~/.bash_profile
EOF
cat >> .bashrc
export HOSTNAME=docker
export PROMPT_COMMAND=
export PS1='[docker \W]\$ '
EOF
cd /
. .bashrc
