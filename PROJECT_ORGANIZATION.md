# Standard Modular Project Organization Guide

A clean, production-grade modular layout for Python / ML / AI / Backend projects. Easy to navigate, scales without bloat, and enforces strict separation between **library logic (`src/`)**, **configuration (`configs/`)**, **entrypoints (`scripts/`)**, and **artifacts (`outputs/`)**.

---

## 1. Directory Structure

```text
<project-name>/
├── README.md                  # Overview, layout, setup, and key commands
├── AGENTS.md                  # Brief instructions & commands for AI coding agents
├── pyproject.toml             # Package metadata, dependencies, ruff/pytest config
├── .env.example               # Template for secrets & environment variables
├── .gitignore                 # Ignores .venv/, data/, outputs/, __pycache__/, .env
│
├── configs/                   # Declarative configs (YAML/TOML) — no hardcoded values in code
│   └── default.yaml
│
├── src/
│   └── <pkg_name>/            # Core installable package (`pip install -e .` / `uv sync`)
│       ├── __init__.py
│       ├── config.py          # Config & env loading / validation
│       ├── data/              # Dataset readers, preprocessing, schemas
│       │   ├── __init__.py
│       │   ├── dataset.py
│       │   └── preprocess.py
│       ├── models/            # Model definitions, API/vLLM clients, architectures
│       │   ├── __init__.py
│       │   └── client.py
│       ├── pipeline/          # Core workflows (train, infer, judge, evaluate)
│       │   ├── __init__.py
│       │   ├── infer.py
│       │   └── evaluate.py
│       ├── prompts/           # Prompt templates (if LLM/agent project)
│       │   └── templates.py
│       └── utils/             # Shared helpers: logging, IO (json/jsonl), metrics, seeding
│           ├── __init__.py
│           ├── io.py
│           ├── logging.py
│           └── metrics.py
│
├── scripts/                   # Thin CLI entrypoints & shell runners (no core logic here)
│   ├── run.sh                 # One-command pipeline runner
│   ├── prepare_data.py
│   ├── run_infer.py
│   └── run_eval.py
│
├── deploy/                    # Serving & infra (Dockerfile, docker-compose, Slurm/vLLM scripts)
│   └── serve.sh
│
├── notebooks/                 # Exploration & result inspection (imports from `<pkg_name>`)
│   └── inspect_results.ipynb
│
├── tests/                     # Unit & integration tests mirroring `src/<pkg_name>/`
│   ├── test_data.py
│   ├── test_models.py
│   └── test_pipeline.py
│
├── data/                      # Local datasets (gitignored)
│   ├── raw/
│   └── processed/
│
└── outputs/                   # Self-contained run artifacts (gitignored)
    └── <run_id>/              # e.g. 20261026_143000_qwen3/
        ├── config.yaml        # Snapshot of config used for this run
        ├── predictions.jsonl  # Per-example outputs
        ├── metrics.json       # Aggregated scores
        ├── plots/             # Generated figures
        └── run.log            # Full execution log
```

---

## 2. Core Design Rules

### Rule 1: All Reusable Logic Lives in `src/<pkg_name>/`
- Install the project in editable mode (`uv sync` or `pip install -e .`).
- Never use `sys.path.append(...)` or relative path hacks. Everything (`scripts/`, `tests/`, `notebooks/`) imports cleanly from `src/<pkg_name>/`:
  ```python
  from <pkg_name>.pipeline.infer import run_inference
  from <pkg_name>.utils.io import read_jsonl, write_jsonl
  ```

### Rule 2: `scripts/` Are Thin Wrappers (< 50 Lines)
- Files in `scripts/` only:
  1. Parse CLI arguments (`argparse` or `typer`) and load `configs/*.yaml`.
  2. Set up logging and output directories.
  3. Call functions/classes from `src/<pkg_name>/`.
- Never define models, dataset parsers, or metric formulas inside `scripts/`.

### Rule 3: Configs & Secrets Are Externalized (`configs/` + `.env`)
- **Hyperparameters, model names, endpoints, and paths** go in `configs/default.yaml` (overridable via CLI flags).
- **API keys, credentials, and machine-specific paths** go in `.env` (with a committed `.env.example`).
- Never hardcode cluster IPs, user home paths (`/home/user/...`), or API keys in `.py` or `.sh` files.

### Rule 4: Strict Input (`data/`) vs. Output (`outputs/`) Separation
- `data/` is **read-only** during model runs (`data/raw/` -> `scripts/prepare_data.py` -> `data/processed/`).
- Every experiment/evaluation run writes to its own timestamped or named directory under `outputs/<run_id>/`:
  - Save a copy of the resolved `config.yaml` inside `outputs/<run_id>/` for reproducibility.
  - Store item-level outputs in `predictions.jsonl` and summary metrics in `metrics.json`.
  - Support **resumability**: if `outputs/<run_id>/predictions.jsonl` already exists, skip completed item IDs.

### Rule 5: Notebooks Are Consumers, Not Codebases
- `notebooks/` are strictly for interactive inspection, plotting, and error analysis.
- If a function in a notebook grows beyond ~15 lines or is needed twice, move it into `src/<pkg_name>/` and import it.

### Rule 6: Clean Repository Hygiene
- **Never commit**: `__pycache__/`, `.ipynb_checkpoints/`, `.venv/`, `.idea/`, `.vscode/`, `.DS_Store`, `.env`, model weights (`*.pt`, `*.bin`, `*.safetensors`), raw data, or `* - Copy` backup folders.
- **Always include**: `pyproject.toml`, `.gitignore`, `.env.example`, and basic `pytest` tests in `tests/`.

---

## 3. Minimal `pyproject.toml` Template

```toml
[build-system]
requires = ["setuptools>=68.0"]
build-backend = "setuptools.build_meta"

[project]
name = "<pkg_name>"
version = "0.1.0"
description = "Short description of the project"
readme = "README.md"
requires-python = ">=3.10"
dependencies = [
    "pyyaml>=6.0",
    "tqdm>=4.66",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "ruff>=0.6",
]

[tool.setuptools.packages.find]
where = ["src"]

[tool.ruff]
line-length = 100
target-version = "py310"

[tool.pytest.ini_options]
testpaths = ["tests"]
```

---

## 4. Copy-Paste Agent Prompt (Create or Restructure a Project)

Use the prompt below to instruct your coding agent to scaffold a new project or refactor an existing one into this modular design:

```markdown
Organize (or restructure) this project using the Standard Modular Production Layout:

1. **Directory Structure**:
   - `src/<pkg_name>/`: All reusable code organized into clear submodules:
     - `config.py` (config & env loader)
     - `data/` (dataset loading, schemas, preprocessing)
     - `models/` (model architectures, API/vLLM clients)
     - `pipeline/` (core workflows: train, infer, judge, evaluate)
     - `prompts/` (prompt templates, if applicable)
     - `utils/` (`io.py` for json/jsonl, `logging.py`, `metrics.py`, `seed.py`)
   - `configs/`: YAML configuration files (`configs/default.yaml`). Remove hardcoded paths, IPs, and hyperparameters from Python code.
   - `scripts/`: Thin CLI entrypoints (<50 lines each) that parse args/configs and call `src/<pkg_name>/`, plus a top-level `scripts/run.sh` orchestrator (`set -euo pipefail`, supports `--limit N` for smoke tests).
   - `deploy/`: Server/cluster launch scripts (`Dockerfile`, `docker-compose.yml`, Slurm/vLLM scripts).
   - `notebooks/`: Interactive analysis/inspection notebooks that import from `<pkg_name>`.
   - `tests/`: Unit/smoke tests mirroring `src/<pkg_name>/` (runnable via `pytest`).
   - `data/` (`raw/`, `processed/`) and `outputs/<run_id>/` (`config.yaml`, `predictions.jsonl`, `metrics.json`, `plots/`, `run.log`) — both gitignored.

2. **Packaging & Imports**:
   - Create/update `pyproject.toml` using the `src/` layout so `<pkg_name>` is installable via `uv sync` or `pip install -e .`.
   - Replace any `sys.path` hacks or relative cross-folder imports with clean package imports (`from <pkg_name>... import ...`).

3. **Cleanup & Hygiene**:
   - Delete duplicate/backup files (`* - Copy`, `backup_*`, unused scratch scripts) after migrating useful logic into `src/<pkg_name>/`.
   - Move loose root `.py` modules into their appropriate `src/<pkg_name>/` or `scripts/` location, loose notebooks into `notebooks/`, and loose plots/outputs into `outputs/`.
   - Add a comprehensive `.gitignore` (`.venv/`, `__pycache__/`, `.ipynb_checkpoints/`, `.idea/`, `.vscode/`, `.DS_Store`, `.env`, `data/`, `outputs/`, `*.pt`, `*.log`) and `.env.example`.

4. **Documentation**:
   - Update `README.md` with: (1) Project summary, (2) Directory layout tree, (3) Setup (`uv sync` or `pip install -e .`), and (4) Usage commands (data prep, inference/training, evaluation, tests).
   - Add a concise `AGENTS.md` (<25 lines) documenting setup, test/lint commands, and module boundaries.
```
