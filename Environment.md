Installing Python3
---

As root:

`yum install git gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel postgresql-devel`

As user:
```bash
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install 3.4.1
pyenv global 3.4.1
pip install virtualenvwrapper
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV=true
mkvirtualenv py3
workon py3
```

Add this to your ~/.bashrc:

```bash
cd
cat >> .bashrc <<'EOF'
function reset_ps1 {
    export PS1='\W$ '
}
expr "x$PS1" : 'x\[' > /dev/null && reset_ps1

test "$VIRTUAL_ENV" && {
    type workon >/dev/null 2>&1 || {
        unset VIRTUAL_ENV
	    export VIRTUAL_ENV
	    reset_ps1
    }
}
export WORKON_HOME="$HOME/Envs"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV=true
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv virtualenvwrapper
workon py3
EOF
```

These are useful github aliases:

```bash
function gcl {
    local r=$1
    expr "$r" : '.*/' >/dev/null || r=$(basename $(pwd))/$r
    git clone "https://github.com/$r"
}

alias gup='git fetch && git checkout'
alias gpu='git push origin master'
alias gco='git commit -am'
```

ssh key needed for CoreOS fleet:

```bash
if test -f ~/.ssh/ssh_agent; then
    . ~/.ssh/ssh_agent > /dev/null
    if [ "$PS1" ]; then
        if ps ${SSH_AGENT_PID-0} 2>&1 | grep ssh-agent > /dev/null 2>&1; then
            : We have a daemon
        else
            # Start a daemon and add
            ssh-agent > ~/.ssh/ssh_agent
            . ~/.ssh/ssh_agent
            ssh-add
            (x=~/.vagrant.d/insecure_private_key && test -f $x && ssh-add $x)
        fi
    fi
fi
```

###### Postgresql database

A postgresql server must be running with the utf8 character
encoding and UTC timezone.  Run this as root:

```
service postgresql stop
rm -rf /var/lib/pgsql/data
su - postgres -c 'initdb -E UTF8'
perl -pi.bak -e '/^host/ && s/trust$/password/' /var/lib/pgsql/data/pg_hba.conf
perl -pi.bak -e 's/^#timezone\b.*/timezone = UTC/' /var/lib/pgsql/data/postgresql.conf
service postgresql start
echo "ALTER USER postgres PASSWORD 'postpass';COMMIT" | su - postgres -c 'psql template1'
```

In your bashrc
```
echo 'export PGPASSWORD=postpass' >> ~/.bashrc
```


###### Docker

(Command line doc manuals)[https://docs.docker.com/reference/commandline/cli/]

```bash

sudo rpm -Uvh http://mirror.us.leaseweb.net/epel/6/i386/epel-release-6-8.noarch.rpm
# This may fail
yum remove docker
yum install -y docker-io
service docker start
chkconfig docker on
docker pull centos
# Test interactive (--interacive=true -tty=true)
docker run -i -t centos:centos6 /bin/bash
# Test daemon (-d)
cid=$(docker run -d centos:centos6 /bin/sleep 3600)
docker ps -a
# Displays stdout
docker logs $cid
docker stop $cid
# You have to remove the containers, or they'll hang around forever
docker rm $cid
# --quite=true only shows numeric ideas for images and ps
# Remove all running containers: --quiet=true  --all=true
docker rm $(docker ps -a -q)

# List all images --all=true (including intermediate/old commits)
docker images -a

# Clean old commits: --filter
docker rmi $(docker images -f "dangling=true" -q)
```
