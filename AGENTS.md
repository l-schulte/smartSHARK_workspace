# smartSHARK_workspace

A development harness that aggregates the user's forks of the
[smartSHARK](https://github.com/smartshark) ecosystem components so they can be
built and run together conveniently while developing new features.

## Repository structure & conventions

This workspace is a **parent git repository** (`github.com/l-schulte/smartSHARK_workspace`).
It does not contain the component source directly — it collects the components as
independent sibling repositories.

### Components are `*_fork/` directories (dynamic)

Each smartSHARK component lives in a directory named `<component>_fork/`, e.g.:

- `vcsSHARK_fork/`
- `prSHARK_fork/`
- `pycoSHARK_fork/`
- `labelSHARK_fork/`
- `linkSHARK_fork/`

Conventions to follow (these are patterns, not a fixed list — more may be added):

- **Every `<component>_fork/` is its own git repository.** It has its own remote
  under `github.com/l-schulte/<component>` and is listed in the parent's
  `.gitignore`. Treat them as sibling repos, **not git submodules**.
- **Discover components dynamically.** Glob `*_fork/` instead of assuming which
  ones exist. To learn what a component does, read its `README*` and source
  directly rather than guessing.
- Components are Python packages (typically with `setup.py` / `setup.cfg` /
  `pyproject.toml`).

### Upstream and contribution flow

- Upstream for every component is `github.com/smartshark/<component>`.
- The `*_fork` repos are where development happens.
- **Contribution rule:** finalized changes go upstream only via a **pull request**
  from the fork. There are **no direct pushes** to `smartshark/*`. Always prepare
  a PR; never push straight to upstream.

### Container / runtime

- `containerfile` builds a single dev image (Ubuntu-based) that installs the
  component forks (currently `vcsSHARK`, `prSHARK`, `pycoSHARK`) into one Python
  environment.
- `compose.yaml` orchestrates the services: a `mongo` database plus the shark
  services that depend on it. Edit `compose.yaml` to see which components are
  wired up. Note that `labelSHARK_fork` and `linkSHARK_fork` exist but are not
  yet part of the container/compose setup.
- Runtime configuration is read from `.env` (gitignored). It provides the
  database credentials (`DB_USER`, `DB_PW`, `DB_NAME`, `DB_HOST`, `DB_PORT`) and
  a GitHub token (`GH_TOKEN`). **Never commit, print, or expose `.env` contents.**

### Development loop

1. Edit the relevant `*_fork/` component.
2. Rebuild and run the containerized setup:

   ```sh
   docker compose build && docker compose up
   ```

Components are installed at image build time (via `COPY` in the `containerfile`),
so a rebuild is required to pick up changes — prefer this over live-mounting.
