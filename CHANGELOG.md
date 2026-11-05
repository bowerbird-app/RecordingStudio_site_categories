# recording_studio_site_categories Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2026-11-05

### Added

* `RecordingStudioSiteCategories.configuration.layout`. When Recording Studio
  core is loaded, assignment goes through `RecordingStudio::Layout.accept`.
  `nil` follows `RecordingStudio.configuration.layout`, then
  `recording_studio/default_layout`.

### Changed

* Dummy helpers validity demo uses FlatPack Table instead of a raw HTML table
* Dummy pins Recording Studio `v6.3.0`, Accessible `v0.24.1`, Trashable
  `v0.12.2`, Root Switchable `v0.11.5`, Cache `v0.6.2`, Metrics `v0.7.2`,
  and FlatPack `v0.1.341`. The gem itself still has no runtime
  `recording_studio` dependency.
* Dummy pins FlatPack `v0.1.331` and demo Buttons use `href:` so they render as `<a href>`
* Dummy Card, Alert, and Sidebar keywords updated for that FlatPack pin
* Dummy overrides the Root Switchable switch page so PageNav close and Card match FlatPack 0.1.331
* When `RecordingStudio::ControllerLayout` is defined, engine controllers
  call `recording_studio_layout { RecordingStudioSiteCategories.configuration.layout }`.
  Otherwise they keep `layout "recording_studio_site_categories/blank"`.
* The mounted categories index still falls back to a plain HTML table when
  FlatPack table components are missing. When FlatPack is present, `Table`
  uses `min_width: :none` and column `wrap: :wrap` so long item lists wrap
  at 390px instead of forcing a 40rem minimum. `content_for` title/subtitle
  feed core `PageTitle` when the default layout is on.
* Dummy Root Switchable `config.layout` is the `"flat_pack_sidebar"` layout
  name. Tag `v0.11.5` rejects a controller method symbol.
* Dummy Root Switchable show template stays overridden so PageNav uses
  `with_close(href:)` instead of removed constructor kwargs.
* Engine categories PageNav close control does not render on FlatPack 0.1.331.
  `anchor_url:` is a dead HTML attribute. The fallback HTML table is unchanged.
* Root and dummy lockfiles use Rails `8.1.4.1`, Rack `>= 3.2.8`, Nokogiri
  `>= 1.19.5`, Loofah `2.25.3`, and `rails-html-sanitizer` `>= 1.7.2`.
  RuboCop stays on `1.81.7` and rubocop-ast on `1.48.0`, matching main.

### Removed

* Template leftovers `docs/gem_template/`, `UPDATE_SUMMARY.md`, and
  `MIGRATION_NOTES.md`.

### Upgrade notes

- Registry, HasCategory, and helpers stay usable without a runtime
  Recording Studio dependency.
- Hosts that load Recording Studio `6.3` can set
  `RecordingStudioSiteCategories.configuration.layout` to a layout name,
  `false`, or `->(controller:) { ... }`. Do not hard-code
  `layout "recording_studio/default_layout"`.
- Hosts without core keep the blank engine layout and HTML table fallback.

## [0.3.1] - 2026-11-02

### Changed

* Dummy `Page` includes HasCategory for colour and publication type
* Dummy page writes go through `RecordingStudio.record!` and `revise`;
  destroy soft-deletes through Trashable and refuses unrecorded rows
* Dummy root switcher checks Accessible grants on the workspace root
* Dummy tests exercise the real FlatPack select instead of inventing one

### Fixed

* Stopped tracking SimpleCov HTML under `coverage/` and `test/dummy/coverage/`
* Removed leftover `gem_template` RuboCop paths
* Rename verification loads the engine instead of skipping

### Upgrade notes

- No host or schema change. This gem's public registry, HasCategory, and
  helpers are unchanged. Dummy-app-only cleanup.

## [0.3.0] - 2026-10-12

### Added

* English Rails I18n keys for select placeholders and HasCategory validation
  messages under `recording_studio.site_categories.select` and
  `recording_studio.site_categories.errors`

### Changed

* Select placeholder `Select %{label}` and HasCategory validation copy resolve
  through `t(...)` / `I18n.t(...)` at call time (English output unchanged)
* Existing view `t(...)` calls pass `default:` English so a host locale with no
  fallback never shows "translation missing"

### Fixed

* HasCategory single-value errors keep type `:inclusion` (with `value:`) so
  `of_kind?` / `added?` match pre-i18n behavior; membership still rejects
  Symbol values that are not exact list members

### Upgrade notes

- No migration or host code change is required for English.
- To translate or override the new defaults, add keys under
  `recording_studio.site_categories.select` and
  `recording_studio.site_categories.errors` in the host's locale files.
- For multiple-value HasCategory errors, `errors.details` carries the
  translated string in non-English locales (English remains byte-identical
  to 0.2.x).
- There is no dependency on `recording_studio_internationalization`.

## [0.2.0] - 2026-10-09

### Added

* English Rails I18n keys for static interface copy in the gem's own categories
  index (`config/locales/en.yml` under `recording_studio.site_categories`)

### Changed

* Categories index title, subtitle, and column headers resolve through `t(...)`
  (English output unchanged)

### Upgrade notes

- No migration or host code change is required for English.
- To translate or override the defaults, add keys under
  `recording_studio.site_categories` in the host's locale files.
- There is no dependency on `recording_studio_internationalization`.

## [0.1.2] - 2026-09-09

Shared dummy-app development master key. Regenerated
`test/dummy/config/credentials.yml.enc` with the RecordingStudio_*
development key. The category registry, helpers, and dummy demo are
unchanged.

### Upgrade notes

- No host or schema changes. Developers set `RAILS_MASTER_KEY` or
  `test/dummy/config/master.key` to the shared dummy key.

## [0.1.1] - 2026-09-04

Cloud Agent Builds for this gem now match Billing 0.9.13. The category
registry, helpers, and dummy demo are unchanged.

### Added
- `.cursor/fetch-skills.sh`, `.cursor/install.sh`, `.cursor/start.sh`, and
  `.cursor/environment.json` for Cloud Agent boot. Install skips apt,
  ruby-build, db:prepare, and tailwind when Ruby, bundle, and Postgres are
  already usable. A skippable provision failure does not fail the Build.
  Fetch-skills always runs last. Start only brings PostgreSQL up.

### Fixed
- RuboCop offenses that kept `main` CI red.
- Dummy `root` now points at `home#index` so `root_path` exists.

### Changed
- Bumped the dummy app FlatPack dependency from `0.1.2` to `0.1.33` and
  pinned it by tag in `test/dummy/Gemfile`

### Upgrade notes
- No host or schema changes. Rebuild the Cloud Agent environment with Draft
  off so Build loads the pack.

## [0.1.0] - 2025-12-04

### Added
- Initial release
- Rails mountable engine structure
- PostgreSQL with UUID primary keys support
- TailwindCSS v4 integration
- GitHub Codespaces devcontainer configuration
- Docker Compose setup with PostgreSQL and Redis
- Install generator for host applications
- Comprehensive README and documentation
- Basic test suite with Minitest

[0.4.0]: https://github.com/bowerbird-app/RecordingStudio_site_categories/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/bowerbird-app/RecordingStudio_site_categories/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/bowerbird-app/RecordingStudio_site_categories/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/bowerbird-app/RecordingStudio_site_categories/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/bowerbird-app/RecordingStudio_site_categories/releases/tag/v0.1.2
[0.1.1]: https://github.com/bowerbird-app/RecordingStudio_site_categories/releases/tag/v0.1.1
[0.1.0]: https://github.com/bowerbird-app/RecordingStudio_site_categories/releases/tag/v0.1.0
