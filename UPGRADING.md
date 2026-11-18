# Upgrading recording_studio_site_categories

## 0.4.0 to 0.4.1

1. This gem still has no runtime `recording_studio` dependency. Registry,
   HasCategory, and `recording_studio_site_category_select` are unchanged.
2. The dummy app now pins Recording Studio `7.7.1`, Accessible `0.54.0`,
   Trashable `1.2.0`, Root Switchable `0.16.0`, Cache `0.7.0`, Metrics
   `0.9.1`, and FlatPack `0.1.378`.
3. Hosts that do not load Recording Studio can ignore those pins. Hosts
   that copied the dummy addon stack need Recording Studio `7.7` with the
   same tags. This release was tested on `7.7.1` only.

## 0.3.x to 0.4.0

1. This gem still has no runtime `recording_studio` dependency. Dummy and
   hosts that already use Recording Studio can pin core `6.3.0` or newer
   (below 7) for the default layout.
2. Registry, HasCategory, and `recording_studio_site_category_select` keep
   their current contracts. FlatPack remains optional: the select helper and
   the mounted index both fall back when FlatPack components are missing.
3. `RecordingStudioSiteCategories.configuration.layout` defaults to `nil`.
   When core is loaded, `nil` uses `RecordingStudio.configuration.layout`,
   then `recording_studio/default_layout`. Assign a layout name, `false`, or
   a callable that accepts `controller:`.
4. Call `recording_studio_layout` only when core defines
   `RecordingStudio::ControllerLayout`. Without core, the engine still uses
   `layout "recording_studio_site_categories/blank"`. Do not include
   `RecordingStudio::UsesDefaultLayout` and do not hard-code
   `layout "recording_studio/default_layout"`.
5. If you copied the engine categories index into the host, keep the HTML
   table fallback. FlatPack `Table` now uses `min_width: :none` and wrap.
6. With a host layout set via `configuration.layout = "application"`, the
   page title appears only in the HTML `<title>` because the in-view
   PageTitle is gone.
