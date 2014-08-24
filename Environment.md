
```bash
test "x$BIVIO_ORIGINAL_PATH" = x && export BIVIO_ORIGINAL_PATH="$PATH"
test "x$INSIDE_EMACS" != x -a "x$BIVIO_VITUAL_ENV_CLEAN" = x && {
    PS1='[\u@\h \W]\$ '
    unset VIRTUAL_ENV
    export BIVIO_VIRTUAL_ENV_CLEAN=true
    export VIRTUAL_ENV PS1 PATH="$BIVIO_ORIGINAL_PATH"
}
export WORKON_HOME=~/Envs
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV=true
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv virtualenvwrapper
workon env1

# # User specific aliases and functions
# pyenv workon env1

cat > /dev/null <<'__END__'
# http://fgimian.github.io/blog/2014/04/20/better-python-version-and-environment-management-with-pyenv/
# yum install git gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel
curl -L https://raw.github.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
cat >> ~/.bashrc <<'EOF
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
. ~/.bashrc
pyenv install 3.4.1
pyenv global 3.4.1
pip install virtualenvwrapper
git clone https://github.com/yyuu/pyenv-virtualenvwrapper.git ~/.pyenv/plugins/pyenv-virtualenvwrapper
cat >> ~/.bashrc <<'EOF'
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV=true
EOF
__END__
```
