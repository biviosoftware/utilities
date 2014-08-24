```bash
function reset_ps1 {
    export PS1='\W$ '
}
expr "x$PS1" : 'x\[' > /dev/null && reset_ps1

CVSROOT=:pserver:nagler@localhost:/home/cvs

# User specific aliases and functions
alias "rm~=find . -name '*~' -exec rm {} ';'"
alias a3="ssh a3"

function gcl {
    local r=$1
    expr "$r" : '.*/' >/dev/null || r=$(basename $(pwd))/$r
    git clone "https://github.com/$r"
}

alias gup='git fetch && git checkout'
alias gpu='git push origin master'
alias gco='git commit -am'

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

cat > /dev/null <<'__END__'
# http://fgimian.github.io/blog/2014/04/20/better-python-version-and-environment-management-with-pyenv/
# yum install git gcc zlib-devel bzip2-devel readline-devel sqlite-devel openssl-devel
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
__END__
```
