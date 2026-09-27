# envs

Personal agentic-coding environments and skills. Single source of truth for
reusable agent skills, portable across harnesses (VS Code Copilot, Claude Code,
Codex CLI, Cursor) via the open [Agent Skills spec](https://agentskills.io/specification).

## Layout

```text
envs/
  skills/<skill-name>/          # owned skills: snapshot-copied, personalized here
  skills/<skill-name>/.source   # upstream provenance: repo, pinned commit, license
  vendor/<repo>/                # third-party git submodules (read-only, pinned)
  scripts/install.sh            # symlink owned + vendored skills into every harness
  AGENTS.md                     # pointer so agents discover skills/
  .agents/skills -> ../skills   # in-repo discovery (Codex/Cursor/Copilot)
  .claude/skills -> ../skills   # in-repo discovery (Claude)
```

Two skill kinds:
- **Owned** (`skills/`): snapshot-copied so this repo survives upstream
  deletion; personalizations live here. Re-sync manually for upstream updates.
- **Vendored** (`vendor/`): git submodules pinned to a commit; updated via
  `git submodule update --remote`. `install.sh` links `vendor/*/skills/*`
  directly — no copies to drift.

## Skills

| Skill | Kind | Source | License |
|-------|------|--------|---------|
| `scientific-figure-making` | owned | snapshot of [figures4papers](https://github.com/ChenLiu-1996/figures4papers) `scientific-figure-making/` + `figure_*/plot_*.py` @ `f0bb755` (2026-09-25) | CC-BY-NC-4.0 ([LICENSE](https://github.com/ChenLiu-1996/figures4papers/blob/main/LICENSE)) |
| `ponytail`, `ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help` | vendored | submodule [ponytail](https://github.com/dietrichgebert/ponytail) @ `e3ba2aa` (v4.10.0, 2026-09-14) | MIT |

## Setup

```bash
./scripts/install.sh          # symlink all skills to ~/.agents/skills, ~/.claude/skills, ~/.cursor/skills, ~/.copilot/skills, ~/.codex/skills
./scripts/install.sh --check  # verify links
SKILLS="scientific-figure-making" ./scripts/install.sh  # subset
```

Restart the agent (or refresh its skill list) after linking.

## Adding a new skill

Owned (snapshot, personalized):
1. Snapshot-copy the upstream `SKILL.md` (+ `references/`, `scripts/`, `assets/`) into `skills/<name>/`.
2. Verify `name:` in frontmatter matches the directory name (spec requirement).
3. Record provenance in `skills/<name>/.source` (repo URL, commit SHA, date, license).
4. Run `./scripts/install.sh` and commit.

Vendored (submodule, read-only):
1. `git submodule add <url> vendor/<repo>` (shallow is fine for pinning).
2. Run `./scripts/install.sh` — `vendor/*/skills/*` are linked automatically.
3. Update with `git submodule update --remote vendor/<repo>`; commit the new pin.