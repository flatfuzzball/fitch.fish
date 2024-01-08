# fitch.fish
The worst fish plugin manager.

Fitch is a really shitty and unnecessarily complicated fish shell plugin manager in 91 cringe-inducing lines of code. I wrote this to learn fish scripting.

It clones repos from github, moves the files to the correct places (in way too many steps) and deletes the cloned repo. Very efficient indeed.
It has no error handling, so if you screw up you're kinda fucked.
It uses an index file (fitch.txt) to know what to delete. It sometimes fails to remove some of the lines when removing a plugin from the index, however it does not seem to ever really break anything.

## Installation:

### Requirements:
- git
- sed
- awk
- fish of course

Can be installed through any other plugin manager, or manually installed like this:

```
curl https://raw.githubusercontent.com/flatfuzzball/fitch.fish/main/completions/fitch.fish > $__fish_config_dir/completions/fitch.fish
curl https://raw.githubusercontent.com/flatfuzzball/fitch.fish/main/functions/fitch.fish > $__fish_config_dir/functions/fitch.fish
```

## Usage:

### Downloading plugins:
```
fitch --get(/-g) username/repo
```
### Uninstalling plugins:
```
fitch --del(/-d) username/repo
```
