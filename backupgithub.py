from __future__ import print_function
import datetime
import github3
import glob
import netrc
import os
import os.path
import re
import subprocess
import sys

_GITHUB_HOST = 'github.com'
_GITHUB_URI = 'https://' + _GITHUB_HOST
_GITHUB_API = 'https://api.' + _GITHUB_HOST
_PURGE_DELTA = datetime.timedelta(days=3)
_WIKI_ERROR_OK = r'fatal: remote error: access denied or repository not exported: .*wiki.git'

class _Internal(object):
    def __init__(self):
        self._chdir()
        self._login()

        for r in self._github.iter_repos(type="all"):
            self._repo(r)

        for o in self._github.iter_orgs():
            for r in o.iter_repos(type="all"):
                self._repo(r)

    def _chdir(self):
        self._root = os.path.expanduser("~/backup-github")
        d = os.path.join(
            self._root,
            datetime.datetime.now().strftime("%Y%m%d%H%M%S"))
        try:
            os.makedirs(d)
        except:
            pass
        os.chdir(d)
        self._dir = d
    
    def _login(self):
        n = netrc.netrc()
        self._user, a, self._pw = n.authenticators(_GITHUB_HOST)
        self._github = github3.login(self._user, password=self._pw)

    
    def _purge(self):
        g = "[0-9]" * len(os.path.basename(self._dir))
        expires = datetime.datetime.utcnow() - _PURGE_DELTA
        for d in glob.glob(os.path.join(self._root, g)):
            t = datetime.datetime.utcfromtimestamp(os.stat(d).st_mtime)
            if t < expires:
                self._shell(["rm", "-rf", d])

    def _repo(self, repo):
        fn = repo.full_name
        bd = re.sub("/", "-", fn)

        def _clone(suffix):
            base = bd + suffix
            for cmd in [
                ["git", "clone", "--quiet", "--mirror",
                        _GITHUB_URI + "/" + fn + suffix,
                        base],
                ["tar", "cJf", base + ".txz", base],
                ["rm", "-rf", base]]:
                self._shell(cmd)

        def _json(gen, suffix):
            base = bd + suffix
            with open(base, "wt") as f:
                sep = "["
                for i in gen:
                    f.write(sep)
                    f.write(i.to_json())
                    sep = ","
                f.write("]")
            self._shell(["xz", base])

        _clone(".git")
        if repo.has_wiki:
            _clone(".wiki.git")
        if repo.has_issues:
            _json(repo.iter_issues(state="all"), ".issues")
        _json(repo.iter_comments(), ".comments")

    def _shell(self, cmd):
        try:
            subprocess.check_output(cmd, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            if not re.search(_WIKI_ERROR_OK, str(e.output)):
                print(e.output, file=sys.stderr)
                raise

_Internal()
