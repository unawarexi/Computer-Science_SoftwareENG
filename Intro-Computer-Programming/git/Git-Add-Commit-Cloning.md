# Git Basics: Clone, Add, and Commit

A comprehensive guide to fundamental Git operations including cloning repositories, staging changes, and creating commits.

## Table of Contents

- [Introduction](#introduction)
- [Cloning a Repository](#cloning-a-repository)
- [Understanding Git's Three Areas](#understanding-gits-three-areas)
- [Adding Files to the Staging Area](#adding-files-to-the-staging-area)
- [Committing Changes](#committing-changes)
- [Checking Status and History](#checking-status-and-history)
- [Complete Example Workflow](#complete-example-workflow)
- [Best Practices](#best-practices)
- [Common Scenarios](#common-scenarios)
- [Resources](#resources)

## Introduction

Git is a distributed version control system that helps developers track changes in code, collaborate with others, and maintain a history of their project's evolution.

The fundamental Git workflow consists of four key steps:

1. **Clone** a repository from a remote server
2. **Modify** files in your working directory
3. **Stage** changes to prepare them for commit
4. **Commit** changes to your local repository

## Cloning a Repository

Cloning creates a local copy of a remote repository (from GitHub, GitLab, Bitbucket, etc.) on your machine.

### Basic Clone Command

```bash
git clone <repository-url>
```

### Examples

**Clone from GitHub:**
```bash
git clone https://github.com/username/project.git
```

**Clone into a specific directory:**
```bash
git clone https://github.com/username/project.git my-custom-folder
```

**Clone a specific branch:**
```bash
git clone -b develop https://github.com/username/project.git
```

### What Happens During Clone

- Downloads all files and complete version history
- Creates a `.git` folder containing the repository metadata
- Sets up the remote origin pointing to the source repository
- Checks out the default branch (usually `main` or `master`)

## Understanding Git's Three Areas

Git organizes your work into three distinct areas:

### 1. Working Directory
- Where you edit and modify files
- Contains the current state of your project files
- Changes here are **untracked** until staged

### 2. Staging Area (Index)
- Intermediate area that prepares files for commit
- Contains a snapshot of changes ready to be committed
- Allows you to selectively choose what to include in your next commit

### 3. Repository (Local Git Database)
- Stores all committed snapshots and version history
- Contains the complete project history with all branches and commits

### Visual Flow

```
Working Directory → git add → Staging Area → git commit → Repository
```

## Adding Files to the Staging Area

Before committing changes, you must stage files to tell Git which changes you want to include in your next commit.

### Stage Individual Files

```bash
git add filename.txt
```

### Stage Multiple Files

```bash
git add file1.txt file2.txt file3.txt
```

### Stage All Changes

```bash
# Stage all changes (new, modified, deleted files)
git add .

# Stage all files in current directory and subdirectories
git add -A
```

### Stage by File Type

```bash
# Stage all .txt files
git add *.txt

# Stage all files in a directory
git add src/
```

### Check Staging Status

```bash
git status
```

**Output interpretation:**
- **Green text** = staged (ready to commit)
- **Red text** = unstaged (modified but not staged)
- **Untracked files** = new files not yet tracked by Git

## Committing Changes

A commit creates a permanent snapshot of your staged changes in the repository history.

### Basic Commit

```bash
git commit -m "Your descriptive commit message"
```

### Examples of Good Commit Messages

```bash
git commit -m "Add user authentication feature"
git commit -m "Fix navigation bar responsive design"
git commit -m "Update README with installation instructions"
```

### Commit All Modified Files

```bash
# Stage and commit all modified/deleted files (not new files)
git commit -a -m "Update existing files"
```

### Multi-line Commit Messages

```bash
# Opens default editor for detailed commit message
git commit

# Example multi-line format:
# Add user registration functionality
# 
# - Create registration form component
# - Add email validation
# - Implement password strength checker
# - Add user feedback for form errors
```

## Checking Status and History

### Check Current Status

```bash
git status
```

Shows:
- Modified files (not staged)
- Staged files (ready to commit)
- Untracked files
- Current branch information

### View Commit History

```bash
# Full commit history
git log

# Condensed one-line format
git log --oneline

# Show last 5 commits
git log -5

# Show commits with file changes
git log --stat
```

### Check Differences

```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --staged

# Show changes in specific file
git diff filename.txt
```

## Complete Example Workflow

Here's a complete example of the clone-add-commit workflow:

```bash
# 1. Clone the repository
git clone https://github.com/username/awesome-project.git
cd awesome-project

# 2. Make changes to files
echo "# Welcome to My Project" > README.md
echo "console.log('Hello, World!');" > app.js

# 3. Check status
git status

# 4. Stage changes
git add README.md app.js

# 5. Verify staging
git status

# 6. Commit changes
git commit -m "Initialize project with README and basic app structure"

# 7. View history
git log --oneline
```

## Best Practices

### Commit Guidelines
- **Commit Early and Often** - Make small, frequent commits rather than large ones
- **Atomic Commits** - Each commit should represent one logical change
- **Clear Messages** - Write descriptive commit messages that explain what and why

### Staging Best Practices
- **Review Before Staging** - Use `git diff` to see what you're staging
- **Selective Staging** - Don't always stage everything; be intentional
- **Check Status** - Always run `git status` before committing

### Message Format
- **Present Tense** - "Add feature" not "Added feature"
- **Imperative Mood** - Write as if giving a command
- **Concise but Descriptive** - Aim for 50 characters in the subject line

### Repository Maintenance
- **Use .gitignore** - Exclude files you don't want to track
- **Regular Pulls** - Keep your local repository up-to-date
- **Meaningful Structure** - Organize your commits and branches logically

## Common Scenarios

### Undoing Changes

```bash
# Unstage a file
git reset HEAD filename.txt

# Discard unstaged changes
git checkout -- filename.txt

# Undo last commit (keep changes staged)
git reset --soft HEAD~1
```

### Working with .gitignore

Create a `.gitignore` file to exclude certain files:

```
# Node.js
node_modules/
npm-debug.log

# Logs
*.log

# OS files
.DS_Store
Thumbs.db

# IDE files
.vscode/
*.swp
```

### Checking Remote Information

```bash
# Show remote repositories
git remote -v

# Show remote branches
git branch -r
```

## Troubleshooting

### Common Issues and Solutions

**"Nothing to commit, working tree clean"**
- All changes are already committed
- Check `git status` to verify

**"Changes not staged for commit"**
- You have modifications that aren't staged
- Use `git add` to stage them

**"Untracked files present"**
- New files that Git isn't tracking yet
- Add them with `git add` or ignore them with `.gitignore`

## Resources

- [Pro Git Book](https://git-scm.com/book) - Comprehensive Git documentation
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials) - Interactive learning resources
- [Git Documentation](https://git-scm.com/docs) - Official command reference
- [GitHub Git Handbook](https://guides.github.com/introduction/git-handbook/) - Practical Git guide
- [Visualizing Git](https://git-school.github.io/visualizing-git/) - Interactive Git visualization tool

## Contributing

If you find any issues with this guide or have suggestions for improvement, please feel free to open an issue or submit a pull request.

## License

This guide is available under the MIT License.