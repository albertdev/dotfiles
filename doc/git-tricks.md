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
It is possible to set a local config value which points to Putty's plink or the openssh tools with an argument to specify the key.
TODO: Look up exact config value.

