# Real-World Demos and Figure Scripts

Runnable plot scripts are vendored in this skill under `../demos/figure_*/`
(snapshot of the upstream `figure_*` folders — see `../.source`). Each folder
is self-contained: `cd ../demos/figure_<project>/` and run
`python3 plot_*.py`; outputs go to `./figures/`.

The design theory, patterns, and guidance in this skill are derived from these
scripts. Upstream originals (for browsing history/issues) live in
[figures4papers](https://github.com/ChenLiu-1996/figures4papers).

## Project folders (demos)

Each folder contains Python scripts that follow the skill's house style. Use them as references for bar charts, trend and line panels, heatmaps, radar or polar comparisons, and multi-panel layouts.

| Project | Local scripts | Upstream | Notes |
|--------|---------------|----------|-------|
| **figure_ImmunoStruct** | [demos/figure_ImmunoStruct](../demos/figure_ImmunoStruct) | [figures4papers/figure_ImmunoStruct](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_ImmunoStruct) | Bar plots for quantitative comparison |
| **figure_CellSpliceNet** | [demos/figure_CellSpliceNet](../demos/figure_CellSpliceNet) | [figures4papers/figure_CellSpliceNet](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_CellSpliceNet) | Bar comparison, ablation |
| **figure_Brainteaser** | [demos/figure_Brainteaser](../demos/figure_Brainteaser) | [figures4papers/figure_Brainteaser](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_Brainteaser) | Bar composition breakdown |
| **figure_VIGIL** | [demos/figure_VIGIL](../demos/figure_VIGIL) | [figures4papers/figure_VIGIL](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_VIGIL) | Radar plots, line plots |
| **figure_ophthal_review** | [demos/figure_ophthal_review](../demos/figure_ophthal_review) | [figures4papers/figure_ophthal_review](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_ophthal_review) | Trend plots |
| **figure_RNAGenScape** | [demos/figure_RNAGenScape](../demos/figure_RNAGenScape) | [figures4papers/figure_RNAGenScape](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_RNAGenScape) | Heat maps |
| **figure_Dispersion** | [demos/figure_Dispersion](../demos/figure_Dispersion) | [figures4papers/figure_Dispersion](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_Dispersion) | 3D-style spheres, performance plots |
| **figure_Cflows** | [demos/figure_Cflows](../demos/figure_Cflows) | [figures4papers/figure_Cflows](https://github.com/ChenLiu-1996/figures4papers/tree/main/figure_Cflows) | Comparison, ablation, trajectory plots |

For full scripts, outputs, and data, clone or browse the repo. The figure_* folders are the canonical implementations of this skill's style.

## Related files

- [SKILL.md](../SKILL.md) — When to load this skill
- [api.md](api.md) — Constants, helpers, validation
- [common-patterns.md](common-patterns.md) — Layout and legend patterns
- [design-theory.md](design-theory.md) — Style theory and reproduction rules
- [tutorials.md](tutorials.md) — Step-by-step figure builds
