# recording_studio_site_categories

`recording_studio_site_categories` is a small Rails engine gem that provides a site-level, in-memory category registry.
Other gems and host apps can register category groups during boot, then use those groups for validation and FlatPack-backed form inputs.

## Why this gem exists

RecordingStudio addons often need shared category vocabularies such as colours, tags, or classifications that should be defined once and reused across models and views.
This gem centralizes those groups without creating its own tables or taking a runtime dependency on `recording_studio`.

## Installation

Add the gem to your application:

```ruby
gem "recording_studio_site_categories"
```

Then install dependencies:

```bash
bundle install
```

Run the install generator to create the host initializer:

```bash
bin/rails generate recording_studio_site_categories:install
```

The generator creates `config/initializers/recording_studio_site_categories.rb` with a sample group registration.

## Registering groups

Register groups in the generated initializer or from addon boot code:

```ruby
RecordingStudioSiteCategories.register_group(
  key: :colour,
  label: "Site colours",
  items: ["Red", "Black", "Blue"],
  source: "HostApp"
)
```

Each group has:

- `key` - unique machine-friendly identifier
- `label` - display label for UI and validation copy
- `items` - allowed values for the group
- `source` - optional owner string used in duplicate-key errors

Duplicate registrations raise immediately during boot:

```ruby
RecordingStudioSiteCategories::DuplicateGroupError
```

## Model concern

Use `RecordingStudioSiteCategories::HasCategory` to validate an attribute against a registered group:

```ruby
class Page < ApplicationRecord
  include RecordingStudioSiteCategories::HasCategory.for(:colour, attribute: :site_colour)
end
```

The concern allows blank values, rejects values outside the registered group, and exposes `site_category_group_key` on the model instance.

## View helpers

The engine provides helpers for labels, values, validation checks, and FlatPack select rendering:

- `recording_studio_site_category_label(group_key)`
- `recording_studio_site_category_items(group_key)`
- `recording_studio_site_category_options(group_key)`
- `recording_studio_site_category_valid?(group_key, value)`
- `recording_studio_site_category_select(form, group_key, attribute_name: group_key, **system_args)`

`recording_studio_site_category_select` renders the installed FlatPack select component with the current field value and validation error state.

## Runtime and schema notes

- The gem has **no database tables of its own**.
- The gem does **not** depend on `recording_studio` at runtime.
- The dummy app continues to use RecordingStudio so the feature can be demonstrated against the existing `Page` recordable.

## Dummy app demo

The repository includes a dummy host app under `test/dummy` that shows:

- a registered `:colour` category group
- a mounted categories listing page
- a Pages CRUD flow using the existing RecordingStudio `Page` recordable
- FlatPack form inputs wired through `recording_studio_site_category_select`

Run the standard checks from the repository root with:

```bash
bundle exec rake test
```

If you change dummy app boot, migrations, or assets, also validate the dummy app flow used in CI.
