# Git Rebasing - Complete Guide

A comprehensive guide to understanding and using Git rebase for maintaining clean, linear commit histories and effective collaboration.

## Table of Contents

- [Introduction](#introduction)
- [What is Git Rebase?](#what-is-git-rebase)
- [Why Use Rebase?](#why-use-rebase)
- [Git Rebase vs Git Merge](#git-rebase-vs-git-merge)
- [Basic Git Rebase Usage](#basic-git-rebase-usage)
- [Interactive Rebase](#interactive-rebase)
- [Rebasing a Feature Branch onto Main](#rebasing-a-feature-branch-onto-main)
- [Handling Conflicts During Rebase](#handling-conflicts-during-rebase)
- [Rebase Strategies](#rebase-strategies)
- [Undoing a Rebase](#undoing-a-rebase)
- [Best Practices](#best-practices)
- [Resources](#resources)

## Introduction

Git rebase is a powerful tool that allows you to reapply commits on top of another base tip. It's particularly valuable for maintaining a clean, linear commit history in your projects.

While merging preserves the original branch history with all its complexity, rebasing rewrites the history as if your work was developed from the latest version of the target branch from the beginning.

## What is Git Rebase?

Git rebase takes commits from one branch and moves them onto another branch, reapplying changes one by one on the new base.

### Visual Example

**Before Rebase:**
```
main:    A---B---C
feature:      \
               D---E
```

**After Rebase:**
```bash
git checkout feature
git rebase main
```

**Result:**
```
main:    A---B---C
feature:           D'---E'
```

Note that D' and E' are new commits with the same changes as D and E, but based on commit C.

## Why Use Rebase?

### Clean, Linear History
- Eliminates unnecessary merge commits that can clutter your project history
- Creates a straight line of commits that's easier to follow

### Easier Collaboration
- Your branch always applies cleanly on top of the latest main branch
- Reduces integration complexity

### Simplifies Code Review
- Reviewers can focus on your actual changes without unrelated merge commits
- Cleaner diff output

## Git Rebase vs Git Merge

| Feature | Merge | Rebase |
|---------|-------|--------|
| **History** | Non-linear, preserves all commits | Linear, rewrites history |
| **Merge Commits** | Creates merge commits | No merge commits (unless --merge) |
| **Collaboration** | Safe on shared branches | Only safe on private branches |
| **Simplicity** | Simple, lower risk | Requires careful conflict handling |
| **Traceability** | Shows when branches diverged/merged | Shows clean linear progression |

**Rule of Thumb:** Merge preserves history; rebase rewrites it.

## Basic Git Rebase Usage

### 1. Rebase Feature Branch onto Main

```bash
git checkout feature
git rebase main
```

This applies your feature commits on top of the latest main branch.

### 2. Continue After Resolving Conflicts

```bash
git add <conflicted_file>
git rebase --continue
```

### 3. Abort a Rebase

```bash
git rebase --abort
```

### 4. Skip a Commit

```bash
git rebase --skip
```

## Interactive Rebase

Interactive rebase (`git rebase -i`) allows you to edit, combine, reorder, or remove commits from your branch history.

### Basic Interactive Rebase

```bash
git rebase -i HEAD~3
```

This opens an editor showing the last 3 commits:

```
pick f1a2b3 Add login form
pick e3c4d5 Fix login bug
pick a7b8c9 Update README
```

### Available Commands

- **pick** - Keep the commit as-is
- **reword** - Keep commit but edit the message
- **edit** - Stop to amend the commit
- **squash** - Combine with previous commit
- **drop** - Remove the commit entirely

### Squashing Example

```
pick f1a2b3 Add login form
squash e3c4d5 Fix login bug
pick a7b8c9 Update README
```

This combines the first two commits into one, keeping the third separate.

## Rebasing a Feature Branch onto Main

### Step-by-Step Process

1. **Update your local main branch:**
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Switch to your feature branch:**
   ```bash
   git checkout feature-branch
   ```

3. **Rebase onto main:**
   ```bash
   git rebase main
   ```

4. **Resolve conflicts if they occur:**
   ```bash
   git add <resolved-file>
   git rebase --continue
   ```

5. **Push the rebased branch:**
   ```bash
   git push origin feature-branch --force
   ```

**Warning:** Only force-push rebased branches if no one else is working on them.

## Handling Conflicts During Rebase

When Git encounters conflicts during rebase, it pauses the process and asks you to resolve them.

### Conflict Resolution Steps

1. **Open conflicted files** and resolve the conflicts manually
2. **Stage the resolved files:**
   ```bash
   git add <resolved-file>
   ```
3. **Continue the rebase:**
   ```bash
   git rebase --continue
   ```
4. **If needed, abort the rebase:**
   ```bash
   git rebase --abort
   ```

### Conflict Example

```
<<<<<<< HEAD
console.log("Version from main");
=======
console.log("Version from feature");
>>>>>>> feature-branch
```

## Rebase Strategies

### Regular Rebase
```bash
git rebase main
```
Standard rebase operation moving commits to new base.

### Interactive Rebase
```bash
git rebase -i main
```
Allows editing of commit history during rebase.

### Rebase and Fast-Forward Merge
```bash
git checkout main
git merge --ff-only feature-branch
```
Ensures only fast-forward merges after a clean rebase.

## Undoing a Rebase

### During an Active Rebase
```bash
git rebase --abort
```

### After Completing a Rebase
If you need to return to the state before rebasing:

1. **Find the original commit:**
   ```bash
   git reflog
   ```

2. **Reset to the original state:**
   ```bash
   git reset --hard <commit-before-rebase>
   ```

## Best Practices

### Do's
- **Private Branches Only** - Only rebase local or private branches
- **Stay Updated** - Frequently pull main branch updates to minimize conflicts
- **Clean History** - Use interactive rebase to clean up commits before merging
- **Test After Rebasing** - Always test your code after completing a rebase
- **Safe Force Push** - Use `--force-with-lease` instead of `--force`

### Don'ts
- **Never Rebase Shared Branches** - Don't rebase branches that others are working on
- **Don't Rebase Public History** - Avoid rebasing commits that have been pushed to shared repositories
- **Don't Rush Conflict Resolution** - Take time to carefully resolve conflicts

### Recommended Workflow

1. Create feature branch from latest main
2. Develop and commit your changes
3. Before merging, rebase onto latest main
4. Use interactive rebase to clean up commit history
5. Force push (with lease) your rebased branch
6. Create pull request for review

## Advanced Tips

### Force Push with Lease
```bash
git push --force-with-lease origin feature-branch
```
This is safer than `--force` as it checks that you're not overwriting someone else's work.

### Preserve Merge Commits
```bash
git rebase --preserve-merges main
```
Keeps merge commits during rebase (useful for complex branching).

## Resources

- [Pro Git Book - Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) - Official Git documentation
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase) - Interactive tutorials
- [Interactive Rebase Guide](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History) - Advanced rebase techniques

## Contributing

If you find any issues with this guide or have suggestions for improvement, please feel free to open an issue or submit a pull request.

## License

This guide is available under the MIT License.