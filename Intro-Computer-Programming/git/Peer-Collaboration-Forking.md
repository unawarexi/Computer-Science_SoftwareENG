# Git Peer Collaboration and Forking — Student Guide

## Table of Contents

- [Introduction](#introduction)
- [What is Peer Collaboration in Git?](#what-is-peer-collaboration-in-git)
- [Inviting Peers to a Repository](#inviting-peers-to-a-repository)
- [Forking a Repository](#forking-a-repository)
- [Cloning a Fork](#cloning-a-fork)
- [Collaborating on a Fork](#collaborating-on-a-fork)
- [Submitting Changes from a Fork](#submitting-changes-from-a-fork)
- [Best Practices for Peer Collaboration](#best-practices-for-peer-collaboration)
- [References & Resources](#references--resources)

## Introduction

Git is designed for collaboration, allowing multiple developers to work on the same project simultaneously.

Key collaboration mechanisms include:

- Adding collaborators to a repository
- Forking public repositories to create your own copy
- Pull requests to submit changes back to the original repository

## What is Peer Collaboration in Git?

Peer collaboration allows multiple developers to:

- Work on different features simultaneously
- Share progress using remote repositories
- Review and merge code via pull requests
- Avoid conflicts by keeping branches organized

Collaboration is essential in both open-source projects and team projects.

## Inviting Peers to a Repository

To invite someone as a collaborator:

### GitHub Example:

1. Go to your repository on GitHub
2. Click Settings → Collaborators & Teams
3. Click Add People
4. Enter the GitHub username or email of your peer
5. Choose their permission level:
   - **Read**: Can view code
   - **Write**: Can push changes
   - **Admin**: Full control over repository
6. Click Add

The invited peer will receive an email and can clone, push, and pull depending on their permissions.

## Forking a Repository

Forking creates a personal copy of someone else's repository under your GitHub account.

### Steps to Fork:

1. Go to the repository you want to fork
2. Click the Fork button (top-right corner)
3. GitHub creates a copy under your account

### Why Fork?

- Safely make changes without affecting the original repository
- Common workflow in open-source projects

## Cloning a Fork

After forking, clone your copy to your local machine:

```bash
git clone https://github.com/your-username/project.git
cd project
```

This is now your local copy of the fork.

All changes you make locally can be pushed to your fork.

## Collaborating on a Fork

### Create a feature branch

```bash
git checkout -b feature-login
```

### Make changes and commit

```bash
git add .
git commit -m "Add login functionality"
```

### Push branch to your fork

```bash
git push origin feature-login
```

Your changes are now on your forked repository.

## Submitting Changes from a Fork

To contribute back to the original repository:

1. Go to your fork on GitHub
2. Click Compare & Pull Request
3. Select base repository (original repo) and branch to merge into
4. Add a title and description for your PR
5. Click Create Pull Request

The original repository owner can now review and merge your changes.

## Best Practices for Peer Collaboration

- **Work on branches** — Never commit directly to main
- **Pull regularly** — Keep your fork up-to-date with the original repository:

```bash
git remote add upstream https://github.com/original-owner/project.git
git fetch upstream
git merge upstream/main
```

- **Write clear commit messages** — Helps reviewers understand your changes
- Test changes locally before pushing
- **Communicate with your team** — Use PR comments and GitHub Issues
- Clean up old branches after merging to avoid clutter

## References & Resources

- [GitHub Forking Guide](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- [GitHub Collaboration Guide](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
- [Pro Git Book — Working with Remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes)