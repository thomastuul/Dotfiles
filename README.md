# README assets

This orphan branch stores only the images referenced by `README.md` on the
`master` branch. Keeping these files in a separate history prevents regular
clones of the dotfiles from downloading presentation-only assets.

Do not merge this branch into `master`.

To update an image, create a branch from `assets` and open a pull request whose
base branch is `assets`. Images can be referenced from the main README with:

```text
https://raw.githubusercontent.com/thomastuul/Dotfiles/assets/<filename>
```
