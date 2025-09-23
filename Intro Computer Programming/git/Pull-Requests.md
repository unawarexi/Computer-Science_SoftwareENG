# Git Pull Requests — A Student-Friendly Guide

## Table of Contents

- [Introduction](#introduction)
- [What is a Pull Request?](#what-is-a-pull-request)
- [Why Use Pull Requests?](#why-use-pull-requests)
- [Creating a Pull Request](#creating-a-pull-request)
- [Pull Request Workflow](#pull-request-workflow)
- [Reviewing and Merging Pull Requests](#reviewing-and-merging-pull-requests)
- [Handling Conflicts in Pull Requests](#handling-conflicts-in-pull-requests)
- [Best Practices for Pull Requests](#best-practices-for-pull-requests)
- [References & Resources](#references--resources)

## Introduction

A Pull Request (PR) is a way to propose changes from one branch to another, usually from a feature branch to the main branch.

PRs are widely used in collaborative development platforms like GitHub, GitLab, and Bitbucket. They allow team members to review, discuss, and approve changes before merging.

## What is a Pull Request?

A Pull Request is not a Git command; it's a feature of hosting platforms.

It signals that you want your changes to be reviewed and merged into another branch.

Think of it as: "Hey team, I finished this feature. Please review my changes and merge them if everything is good."

## Why Use Pull Requests?

- **Code Review** — Team members can check your code for errors or improvements
- **Collaboration** — Everyone knows what changes are being proposed
- **Quality Control** — Helps maintain a stable main branch
- **Discussion** — PRs allow commenting and suggestions inline on code
- **Audit Trail** — Every change is documented and linked to issues or tasks

## Creating a Pull Request

### Step 1: Push your feature branch

```bash
git checkout feature-login
git push origin feature-login
```

### Step 2: Go to the repository on GitHub (or GitLab/Bitbucket)

Click "Compare & Pull Request".

Choose the base branch (usually main) and compare branch (your feature branch).

### Step 3: Fill in PR details

- **Title**: Short and descriptive (e.g., Add login functionality)
- **Description**: Explain what your PR does, any related issues, and notes for reviewers

### Step 4: Submit Pull Request

Click Create Pull Request.

Your team can now review, comment, and approve changes.

## Pull Request Workflow

1. Create a branch from main
2. Implement feature or fix bug locally
3. Push branch to remote repository
4. Open Pull Request
5. Team reviews the code
6. Make updates if reviewers suggest changes
7. Merge Pull Request into main
8. Delete branch after merge to keep repo clean

## Reviewing and Merging Pull Requests

### Reviewers can:

- Comment inline on code
- Approve or request changes
- Suggest edits that the author can apply directly

### Merging Options on GitHub:

- **Merge Commit**: Combines all commits and creates a merge commit
- **Squash and Merge**: Combines all commits into a single commit before merging
- **Rebase and Merge**: Rewrites commits on top of the target branch for a linear history

## Handling Conflicts in Pull Requests

Sometimes your PR cannot be merged automatically due to conflicts.

### Steps to resolve:

```bash
# Switch to your feature branch
git checkout feature-login

# Pull latest main changes
git pull origin main

# Resolve conflicts in the files

# Stage resolved files
git add <file>

# Continue the rebase (if using rebase)
git rebase --continue

# Push updates
git push origin feature-login
```

Once conflicts are resolved, the PR can be merged.

## Best Practices for Pull Requests

- **Keep PRs small and focused** — Easier to review
- Write clear titles and descriptions
- Link PRs to issues or tasks for context
- Run tests before opening PRs
- Respond to review feedback promptly
- Delete merged branches to avoid clutter
- Use meaningful commit messages — helps in PR review

## References & Resources

- [GitHub Pull Requests](https://docs.github.com/en/pull-requests)
- [Atlassian Git Pull Requests](https://www.atlassian.com/git/tutorials/making-a-pull-request)
- [Pro Git Book — Collaboration](https://git-scm.com/book/en/v2)