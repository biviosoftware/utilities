#!/bin/sh
set -ex
cp -a /etc/skel/.??* /root
cat > /.bashrc << 'EOF'
export HOME=/root
cd $HOME
. ~/.bash_profile
EOF
cat >> /root/.bashrc << 'EOF'
export HOSTNAME=docker
export PROMPT_COMMAND=
export PS1='[docker \W]\$ '
EOF
cd /
. .bashrc
