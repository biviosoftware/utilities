Installing Python3
---

As root:

`yum install git gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel`

As user:
```bash
curl -L https://raw.github.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
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
export WORKON_HOME=~/Envs
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV=true
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv virtualenvwrapper
workon py3
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
