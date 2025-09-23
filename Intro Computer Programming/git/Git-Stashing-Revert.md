# Git Stashing and Reverting — Student Guide

## Table of Contents

- [Introduction](#introduction)
- [Git Stash](#git-stash)
  - [What is Git Stash?](#what-is-git-stash)
  - [When to Use Stash](#when-to-use-stash)
  - [Common Stash Commands](#common-stash-commands)
  - [Advanced Stash Operations](#advanced-stash-operations)
  - [Stash Workflow Examples](#stash-workflow-examples)
- [Git Revert](#git-revert)
  - [What is Git Revert?](#what-is-git-revert)
  - [When to Use Revert](#when-to-use-revert)
  - [Common Revert Commands](#common-revert-commands)
  - [Advanced Revert Operations](#advanced-revert-operations)
  - [Revert Workflow Examples](#revert-workflow-examples)
- [Git Reset vs Revert vs Rebase](#git-reset-vs-revert-vs-rebase)
- [Handling Complex Scenarios](#handling-complex-scenarios)
- [Troubleshooting Common Issues](#troubleshooting-common-issues)
- [Best Practices](#best-practices)
- [Quick Reference Cheat Sheet](#quick-reference-cheat-sheet)
- [References & Resources](#references--resources)

## Introduction

In Git, sometimes you need to temporarily save changes without committing, or undo changes that were committed.

- **Stash**: Save uncommitted changes temporarily
- **Revert**: Undo a commit while keeping history intact

These commands are essential for safe and flexible version control.

## Git Stash

### What is Git Stash?

`git stash` is a temporary storage for changes in your working directory and staging area.

- Useful when you need to switch branches but your current work is incomplete
- You can apply the stashed changes later without committing them
- Think of it as a "clipboard" for your uncommitted work

### When to Use Stash

- Midway through a feature, but need to switch to main for a hotfix
- Testing a different branch but want to save unfinished work
- Cleaning up working directory without losing current changes
- Experimenting with code but want to save current progress
- Pulling changes from remote when you have uncommitted work

### Common Stash Commands

#### Basic Stash Operations

```bash
# Stash current changes
git stash

# Stash with a descriptive message
git stash save "WIP: login feature"

# Modern syntax (Git 2.13+)
git stash push -m "WIP: login feature"
```

#### Viewing Stashes

```bash
# List all stashes
git stash list

# Show contents of latest stash
git stash show

# Show detailed diff of latest stash
git stash show -p

# Show specific stash
git stash show stash@{2} -p
```

#### Applying Stashes

```bash
# Apply latest stash (keeps stash in list)
git stash apply

# Apply and remove latest stash
git stash pop

# Apply a specific stash
git stash apply stash@{2}

# Pop a specific stash
git stash pop stash@{1}
```

#### Managing Stashes

```bash
# Drop a specific stash
git stash drop stash@{0}

# Clear all stashes
git stash clear

# Create a branch from stash
git stash branch new-feature-branch stash@{1}
```

### Advanced Stash Operations

#### Partial Stashing

```bash
# Stash only tracked files (ignore untracked)
git stash push

# Include untracked files
git stash push -u

# Include ignored files
git stash push -a

# Interactive stashing (choose what to stash)
git stash push -p
```

#### Stashing Specific Files

```bash
# Stash specific files
git stash push -m "Stash config files" config.js package.json

# Stash everything except specific files
git stash push --keep-index
```

### Stash Workflow Examples

#### Emergency Hotfix Workflow

```bash
# Working on feature branch
git add .
git stash push -m "WIP: user authentication"

# Switch to main for hotfix
git checkout main
git pull origin main

# Create hotfix branch
git checkout -b hotfix-critical-bug
# ... make changes ...
git add .
git commit -m "Fix critical security vulnerability"
git push origin hotfix-critical-bug

# Back to feature work
git checkout feature-auth
git stash pop
```

#### Experimenting with Code

```bash
# Save current work before experimenting
git stash push -m "Stable version before refactoring"

# Try different approach
# ... make experimental changes ...

# If experiment fails, restore original work
git stash pop

# If experiment succeeds, commit changes
git add .
git commit -m "Implement new approach"
git stash drop
```

## Git Revert

### What is Git Revert?

`git revert` creates a new commit that undoes the changes of a previous commit.

- Does not delete history
- Safer than `git reset` on shared branches
- Creates a "reverse" commit that negates the original changes

### When to Use Revert

- Undo a commit that has already been pushed to remote
- Fix a bug introduced in a previous commit
- Maintain history while undoing a specific change
- Working on shared branches where rewriting history is dangerous
- Need to undo changes while preserving the commit timeline

### Common Revert Commands

#### Basic Revert Operations

```bash
# Revert a specific commit
git revert <commit-hash>

# Revert the last commit
git revert HEAD

# Revert without opening editor (use default message)
git revert --no-edit <commit-hash>
```

#### Multiple Commit Reverts

```bash
# Revert a range of commits
git revert <oldest-commit>^..<newest-commit>

# Revert multiple specific commits
git revert <commit1> <commit2> <commit3>

# Revert without committing immediately (stage changes only)
git revert --no-commit <commit-hash>
```

### Advanced Revert Operations

#### Interactive Revert

```bash
# Revert with custom commit message
git revert -m "Revert problematic changes" <commit-hash>

# Revert merge commit (specify parent)
git revert -m 1 <merge-commit-hash>
```

#### Handling Conflicts During Revert

```bash
# If conflicts occur during revert
git revert <commit-hash>
# ... resolve conflicts in files ...
git add <resolved-files>
git revert --continue

# Abort revert if needed
git revert --abort
```

### Revert Workflow Examples

#### Reverting a Bug Fix

```bash
# View recent commits
git log --oneline -5

# Suppose commit abc1234 introduced a bug
git revert abc1234

# Git opens editor with default message:
# "Revert 'Add user authentication'"
# Save and exit

# Push the revert commit
git push origin main
```

#### Reverting Multiple Related Commits

```bash
# Revert a series of commits without individual commit messages
git revert --no-commit HEAD~3..HEAD
git commit -m "Revert last 3 commits due to performance issues"
```

## Git Reset vs Revert vs Rebase

Understanding the differences is crucial for choosing the right tool:

| Command | What it does | When to use | History Impact |
|---------|--------------|-------------|----------------|
| `git revert` | Creates new commit that undoes changes | Public/shared branches | Preserves history |
| `git reset` | Moves HEAD to different commit | Local changes only | Rewrites history |
| `git rebase` | Replays commits on different base | Clean up local history | Rewrites history |

### Reset vs Revert Comparison

```bash
# DANGEROUS on shared branches - rewrites history
git reset --hard HEAD~1

# SAFE on shared branches - preserves history
git revert HEAD
```

## Handling Complex Scenarios

### Stashing During Merge Conflicts

```bash
# If you have conflicts during merge and need to stash
git stash  # Won't work during merge
git reset --hard HEAD  # Abort merge first
git stash push -m "Work before merge attempt"
git merge feature-branch
```

### Reverting Stashed Changes

```bash
# If you accidentally stashed something you didn't want to
git stash show -p  # Review what was stashed
git stash drop     # Remove the stash
```

### Combining Stash and Revert

```bash
# Save current work before reverting
git stash push -m "Current work before revert"
git revert <problematic-commit>
git push origin main
git stash pop  # Continue with your work
```

## Troubleshooting Common Issues

### Stash Issues

**Problem**: "Cannot stash - you have unmerged paths"
```bash
# Solution: Resolve merge conflicts first
git add <resolved-files>
git commit
# Then stash if needed
```

**Problem**: Applied wrong stash
```bash
# Solution: Reset to before applying stash
git reset --hard HEAD
git stash apply stash@{correct-number}
```

### Revert Issues

**Problem**: "Revert failed due to conflicts"
```bash
# Solution: Manually resolve conflicts
git status  # See conflicted files
# Edit files to resolve conflicts
git add <resolved-files>
git revert --continue
```

**Problem**: Accidentally reverted wrong commit
```bash
# Solution: Revert the revert commit
git revert <revert-commit-hash>
```

## Best Practices

### Stash Best Practices
- **Use descriptive messages** for stashes to remember what they contain
- **Don't use stash for long-term storage** - use branches instead
- **Clean up old stashes** regularly with `git stash clear`
- **Review stash contents** before applying with `git stash show -p`
- **Avoid stashing during merge conflicts** - resolve conflicts first

### Revert Best Practices
- **Use revert instead of reset** on shared branches to avoid rewriting history
- **Always check `git log`** before reverting to ensure you target the correct commit
- **Test after reverting** to ensure the revert didn't introduce new issues
- **Use clear commit messages** when reverting to explain why
- **Consider the impact** of reverting merge commits

### General Best Practices
- **Combine stash and revert** to manage experiments safely
- **Keep commits atomic** to make reverting easier
- **Use branches** for experimental work instead of relying heavily on stash
- **Document your workflow** so team members understand your process

## Quick Reference Cheat Sheet

### Essential Stash Commands
```bash
git stash                          # Stash current changes
git stash push -m "message"        # Stash with message
git stash list                     # List all stashes
git stash pop                      # Apply and remove latest stash
git stash apply stash@{n}          # Apply specific stash
git stash drop stash@{n}           # Delete specific stash
git stash clear                    # Delete all stashes
```

### Essential Revert Commands
```bash
git revert HEAD                    # Revert last commit
git revert <commit-hash>           # Revert specific commit
git revert --no-edit <hash>        # Revert without opening editor
git revert --no-commit <hash>      # Stage revert without committing
git revert <hash1> <hash2>         # Revert multiple commits
```

### Emergency Commands
```bash
git stash && git checkout main     # Quick switch with stash
git revert --abort                 # Cancel ongoing revert
git stash drop                     # Remove latest stash
git reset --hard HEAD              # Discard all local changes
```

## References & Resources

- [Pro Git Book — Stashing and Cleaning](https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning)
- [Pro Git Book — Undoing Things](https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things)
- [Git Documentation](https://git-scm.com/docs)
- [Atlassian Git Stash Tutorial](https://www.atlassian.com/git/tutorials/saving-changes/git-stash)
- [GitHub Git Handbook](https://guides.github.com/introduction/git-handbook/)
- [Interactive Git Tutorial](https://learngitbranching.js.org/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)