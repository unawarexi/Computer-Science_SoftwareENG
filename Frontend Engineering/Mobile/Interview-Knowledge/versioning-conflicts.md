# Top 30 Release Versioning & Git Conflict Resolution

A senior engineer's guide to managing app versioning, releases, and Git workflows.

## Versioning, Releases, and Environment Conflicts (1-10)

### 1. How do you manage app versioning across multiple environments (dev, staging, production)?

Use semantic versioning (MAJOR.MINOR.PATCH), automate version bump in CI/CD, and separate config files (.env.dev, .env.staging).

**Lesson**: Never manually increment versions — automate and track.

### 2. What's the difference between build number and version name?

Version name = user-facing (1.2.0), build number = internal increment for store updates.

**Example**: Flutter → `version: 1.2.0+45`; React Native → in build.gradle and Info.plist.

### 3. How do you handle version drift between Android and iOS builds?

Centralize version control in a single script or CI config (e.g., fastlane or melos for Flutter).

**Lesson**: Sync through CI, not manually per platform.

### 4. Describe how you handle dependency version conflicts

Run audits (`flutter pub deps`, `npm list`), lock dependencies, align transitive versions manually or via resolution strategies.

**Lesson**: Always commit lockfiles.

### 5. How do you ensure stable release builds with many contributors?

Use release branches, tag each release (v1.3.0), and freeze dependencies pre-release.

**Lesson**: Code freeze before tagging.

### 6. What's your release versioning strategy for continuous delivery?

Automate tagging per merge to main (vX.Y.Z), with changelog generation (e.g., semantic-release, standard-version).

**Lesson**: Consistent versioning = predictable releases.

### 7. How do you handle dependency updates that break builds?

Lock versions, create upgrade branches, test in CI, merge after verification.

**Lesson**: Upgrade ≠ Update — always validate.

### 8. When do you bump major, minor, or patch versions?

- **Major** = breaking change
- **Minor** = new features (no break)
- **Patch** = fixes

**Lesson**: Stick to Semantic Versioning (SemVer) discipline.

### 9. How do you handle Flutter or React Native version upgrades safely?

Check changelogs, upgrade stepwise, run migration tools (`flutter upgrade`, `react-native upgrade`), test on staging.

**Lesson**: Never jump multiple versions at once.

### 10. How do you maintain multiple app versions live (e.g., legacy + latest)?

Use feature flags + backend version gating. Maintain separate release branches for LTS.

**Lesson**: Legacy support = stability + compatibility testing.

## Git Conflicts, Branching Strategies, and Team Coordination (11-20)

### 11. Explain your preferred Git branching strategy

Use GitFlow or Trunk-based model depending on scale:

- `main` → production
- `develop` → integration
- `feature/*`, `hotfix/*`, `release/*`

**Lesson**: Branching is communication.

### 12. How do you resolve a complex merge conflict in Git?

Use `git mergetool` or IDE diff, manually verify each conflicting section, re-test locally, commit with a clear message.

**Lesson**: Resolve logically, not blindly.

### 13. How do you avoid frequent Git merge conflicts in a large team?

Rebase often, pull frequently, keep PRs small and short-lived.

**Lesson**: The longer a branch lives, the more conflicts await.

### 14. How do you handle force pushes or rebases on shared branches?

Strictly disallow force-push on shared branches. Use protected branch rules.

**Lesson**: Preserve team history integrity.

### 15. What's your process for handling diverged branches?

Identify common ancestor (`git merge-base`), decide merge vs rebase, communicate before resolving.

**Lesson**: Align early — never surprise teammates with force merges.

### 16. How do you fix commits that were pushed to the wrong branch?

Use `git cherry-pick <commit>`, revert from wrong branch, push correction.

**Lesson**: Cherry-pick, don't manually copy.

### 17. How do you handle binary conflicts (e.g., assets or lockfiles)?

Keep asset changes in separate PRs, use `.gitattributes` to manage binary merge behavior.

**Lesson**: Separate code from assets.

### 18. Describe a time when a bad merge caused production issues

Implemented stricter CI checks, automatic tests, and mandatory reviews after rollback.

**Lesson**: Automation > human trust.

### 19. How do you manage simultaneous releases from multiple teams?

Tag release branches per team, maintain release calendar, and coordinate merge windows.

**Lesson**: Version control needs schedule discipline.

### 20. When do you prefer merge vs rebase?

Rebase for clean history (private branches), merge for shared branches to preserve context.

**Lesson**: History clarity > ego of "clean branches."

## CI/CD, Build, and Hotfix Scenarios (21-30)

### 21. How do you manage versioning in CI/CD pipelines?

Auto-increment versions via script, generate changelog, tag in Git, and upload to store.

**Lesson**: No manual version bumps in 2025.

### 22. How do you fix a broken release already deployed to users?

Roll back version via app store, apply hotfix branch, tag new patch, redeploy.

**Lesson**: Always tag last working build.

### 23. How do you ensure changelog accuracy across versions?

Auto-generate from commit messages using Conventional Commits or GitHub Actions.

**Lesson**: Consistency comes from automation.

### 24. How do you track versions across mobile and backend?

Use shared version metadata endpoint in backend; app pings to check compatibility.

**Lesson**: Always version APIs alongside apps.

### 25. Describe your workflow for managing app store releases

Build signed artifacts, increment versions, upload via CI (Fastlane / Codemagic), track rollout % for monitoring.

**Lesson**: Use staged rollouts for safety.

### 26. How do you handle Git submodules or monorepos?

Keep dependencies isolated with yarn workspaces / melos in Flutter; tag each module independently.

**Lesson**: Version modules, not monoliths.

### 27. What's your strategy for fixing merge conflicts in package-lock or pubspec.lock?

Always regenerate lockfile after clean install, review diff, test before committing.

**Lesson**: Never merge both sides blindly.

### 28. How do you avoid version mismatches between devs locally?

Enforce `.nvmrc` / `.tool-versions`, fvm, or CI-based dependency checks.

**Lesson**: Same tools, same results.

### 29. How do you manage API versioning alongside app releases?

Introduce `/v1`, `/v2` endpoints, deprecate old versions gracefully, and communicate timelines.

**Lesson**: Deprecation ≠ deletion.

### 30. Describe a time a versioning conflict caused a failed store submission

iOS build version mismatch with last upload — fixed by syncing build number via CI increment script.

**Lesson**: Automate both platforms with shared build ID logic.

## Senior Takeaways

- Automate all versioning — from tag to store submission
- Keep lockfiles committed and up-to-date
- Rebase often, merge smartly
- Tag everything — every build, every rollback
- Version your API, dependencies, and mobile apps together