# AGENTS.md

This repo (`envs`) is a personal skills monorepo. Canonical skills live in `skills/`.

- Each `skills/<name>/` follows the [Agent Skills spec](https://agentskills.io/specification): `SKILL.md` (+ `references/`, `scripts/`, `assets/`).
- `skills/<name>/.source` records upstream provenance (repo, pinned commit, license).
- Owned skills in `skills/` are snapshot-copied (no upstream dependency); personalize in place.
- Vendored skills live as git submodules under `vendor/<repo>/skills/*` (read-only); `scripts/install.sh` links both owned and vendored skills into harness paths.
- After adding/editing a skill, run `./scripts/install.sh` to refresh harness symlinks.
