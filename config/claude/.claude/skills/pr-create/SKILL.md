---
name: pr-create
description: Create or update GitHub pull requests using the gh CLI. Use when the user asks to create a PR, open a pull request, submit changes for review, or update an existing PR description.
---

# Pull Request Creation

Create and update GitHub pull requests with well-structured descriptions following conventional commits format.

## When to Use

- User asks to "create a PR" or "open a pull request"
- User wants to "submit for review" or "push and create PR"
- User asks to "update PR description"

## Process

### 1. Ask About Draft Status

Before gathering context, ask the user:
> "Should I create this as a draft PR or ready for review?"

### 2. Gather Context

Run these commands to understand the changes:

```bash
# Get current branch
git branch --show-current

# Check if branch is pushed to remote
git ls-remote --heads origin $(git branch --show-current)

# List commits on this branch (not in main)
git log --oneline main..HEAD

# Get summary of changed files
git diff --stat main..HEAD

# Get full diff for understanding changes
git diff main..HEAD

# Get available labels for the repo
gh label list --json name,description
```

### 3. Push Branch if Needed

If the branch is not pushed to remote:

```bash
git push -u origin $(git branch --show-current)
```

### 4. Analyze Changes

From the commits and diff, identify:

- **Type**: feat, fix, refactor, docs, test, chore, perf, ci
- **Scope**: Component or area affected (optional)
- **Summary**: One-line description of the overall change
- **Changes**: Bullet points of what was modified
- **Issues**: Look for issue references in commits (#123) or branch name
- **Labels**: Match against available repo labels (see labeling rules below)

### 5. Generate PR Title

Follow conventional commits format:

```text
<type>(<scope>): <description>
```

Examples:

- `feat(auth): add OAuth2 login flow`
- `fix: resolve memory leak in worker pool`
- `refactor(api): simplify error handling`

### 6. Generate PR Body

Use this structure:

```markdown
## Summary

<1-3 sentences explaining what this PR does and why>

## Changes

- <change 1>
- <change 2>
- <change 3>

## Related Issues

Closes #<issue> (if applicable)
```

### 7. Create the PR

Use gh CLI to create the PR, always targeting main:

```bash
# For draft PR
gh pr create --base main --title "<title>" --body "<body>" --draft --label "<label1>" --label "<label2>"

# For ready PR
gh pr create --base main --title "<title>" --body "<body>" --label "<label1>" --label "<label2>"
```

For updating an existing PR:

```bash
gh pr edit --title "<title>" --body "<body>" --add-label "<label>"
```

## Label Selection Rules

Be **conservative** with labels - only apply when clearly appropriate:

| Change Type | Consider Labels |
|-------------|-----------------|
| New feature | `enhancement`, `feature` |
| Bug fix | `bug`, `fix` |
| Documentation only | `documentation`, `docs` |
| Breaking change | `breaking-change` |
| Dependencies | `dependencies` |
| CI/CD changes | `ci`, `github-actions` |

**Rules:**

- Only use labels that exist in the repo (from `gh label list`)
- When uncertain, use NO labels rather than wrong ones
- Max 2-3 labels per PR
- Don't apply labels like `help-wanted`, `good-first-issue`, `wontfix`, `invalid`, `duplicate` - these are for maintainer triage

## Best Practices

- Keep the summary concise but informative
- Group related changes in the bullet points
- Don't list every file changed, summarize by feature/area
- If no issue is referenced, omit the Related Issues section
- Use imperative mood: "Add feature" not "Added feature"
- Always target `main` branch

## Example Output

**Title:** `feat(cli): add dotfiles sync command`

**Labels:** `enhancement`

**Body:**

```markdown
## Summary

Add a new `sync` command to the dotfiles CLI that pulls latest changes and re-applies stow configurations.

## Changes

- Add `sync` command to CLI with dry-run support
- Update zsh plugins during sync
- Pull latest git changes with rebase

## Related Issues

Closes #42
```
