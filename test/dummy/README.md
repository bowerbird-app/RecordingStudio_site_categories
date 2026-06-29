# Dummy App

This Rails app demonstrates `recording_studio_site_categories` inside a RecordingStudio host app.

## What It Covers

- Devise authentication with a seeded admin user
- Existing RecordingStudio `Workspace`, `Folder`, and `Page` recordables
- A boot-time `:colour` site category group
- A mounted categories index under `/recording_studio_site_categories`
- A simple Pages CRUD demo that assigns `site_colour` values with FlatPack inputs

## Quick Start

```bash
cd test/dummy
bundle install
bin/rails db:setup
bin/dev
```

Then sign in with:

- Email: `admin@admin.com`
- Password: `Password`

## Useful Routes

- `/` - overview page for the demo
- `/recording_studio_site_categories` - registered category groups
- `/pages` - create and edit demo pages with site colours
- `/recording_studio` - mounted RecordingStudio engine entrypoint
- `/users/sign_in` - Devise sign-in page
- `/up` - Rails health check
