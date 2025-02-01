## Allowing git push with different local branch name than upstream
Git has been shipping with the `push.default` config value set to `simple` for quite a while now. It trades safety over convenience, which is a good
default.

However, it has one big drawback when a local branch has a different name then the upstream one: `git push` without arguments will complain that the
branch names are different and so a refspec argument is needed. There are times where branches like `release/v1.0.x-maintenance` take too long to type
and having to initiate tab-completion is somewhat annoying, and so it might make sense to have a local branch `v1.0.x-maintenance` to type `v1.0` and
_then_ press <kbd>Tab</kbd>.

To be able to use the convenience of running `git push` and yet use simple branch names it is possible to change git's config:
```
git config --local push.default upstream
```
This will simply use the upstream branch without complaining, yet it should still warn when trying to run `git push` when the referenced upstream
branch was deleted or when there is currently no upstream defined.

## Setting a per-repository user name
Simply run the following in whatever repo needs a different email address compared to the system-wide "machine-local" git config.
```
git config --local user.name "custom user"
git config --local user.email "custom address"
```

## Setting a per-repository SSH key
~~It is possible to set a local config value which points to Putty's plink or the openssh tools with an argument to specify the key.~~

This used to be necessary to push to a private repo, which didn't work over HTTP/S and thus needed SSH, but you didn't want to use a single user key
from the machine which might be for a work account (plus github has / used to have (?) the annoying issue that each user account can only have one SSH key).

Nowadays you can push to a private repo using HTTP/S, so it's no longer necessary.

## Setting a default or per-repository Github user
The first time you push to a Github repo, the credential helper built into Git will show a window to help you sign in. However, if you sign into a
second account on a machine then the credential helper will always ask "Which Github account do you want to use?".

This Github page explains how to set a default account: https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/multiple-users.md#tldr-tell-gcm-to-remember-which-account-to-use
Basically add this section to your user git config:

```
[credential "https://github.com"]
    username = XXXXX
```

Since you most likely will need to use at least one repository for which you actually are signed in with another account then you can simply run

```
git config set credential.https://github.com.username "custom user"
```

to set the username to use for that particular repo.
