# recording_studio_site_categories Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2026-11-05

### Added

* `RecordingStudioSiteCategories.configuration.layout`, assigned through
  `RecordingStudio::Layout.accept`. `nil` follows
  `RecordingStudio.configuration.layout`, then `recording_studio/default_layout`.

### Changed

* Requires `recording_studio` `>= 6.3.0`, `< 7`. Dummy pins Recording Studio
  `v6.3.0`, Accessible `v0.24.1`, Trashable `v0.12.2`, Root Switchable
  `v0.11.5`, Cache `v0.6.2`, Metrics `v0.7.2`, and FlatPack `v0.1.341`.
* Engine controllers call
  `recording_studio_layout { RecordingStudioSiteCategories.configuration.layout }`.
* The mounted categories index uses core's default layout with FlatPack
  `PageTitle` (via `content_for`) and `Table`. PageNav is omitted so the
  default layout owns back and close. Table `min_width: :none` so long item
  lists wrap at 390px instead of forcing a 40rem minimum.
* Dummy page edit/update/destroy look up the recording under
  `current_root_recording` so a page id from another workspace 404s.
* Dummy Root Switchable `config.layout` is the `"flat_pack_sidebar"` layout
  name. Tag `v0.11.5` rejects a controller method symbol.
* Dummy Root Switchable show template stays overridden so PageNav uses
  `with_close(href:)` instead of removed constructor kwargs.
* Root and dummy lockfiles use Rails `8.1.4.1`, Rack `>= 3.2.8`, Nokogiri
  `>= 1.19.5`, Loofah `2.25.3`, and `rails-html-sanitizer` `>= 1.7.2`.

### Removed

* Engine layout `recording_studio_site_categories/blank`.
* Tailwind HTML table fallback on the categories index.
* Dead PageNav `anchor_url:` and the unused FlatPack Card availability check
  on that page.
* Template leftovers `docs/gem_template/`, `UPDATE_SUMMARY.md`, and
  `MIGRATION_NOTES.md`.

### Upgrade notes

- Hosts need Recording Studio `6.3.0` or newer, below 7.
- Mounted categories screens now use core's default layout. Set
  `RecordingStudioSiteCategories.configuration.layout` to a layout name,
  `false`, or `->(controller:) { ... }` if the host must wrap them
  differently. Do not hard-code `layout "recording_studio/default_layout"`.
- If you overrode the engine categories index, drop the blank layout, the
  HTML table fallback, and PageNav `anchor_url:`.
- Dummy-only: page ids are scoped to the current workspace root.

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
