# Upgrading recording_studio_site_categories

## 0.3.x to 0.4.0

1. Install Recording Studio `6.3.0` or newer (below 7) before or with this gem.
2. Registry, HasCategory, and `recording_studio_site_category_select` keep their
   current contracts. FlatPack remains optional for the helper; the mounted
   categories index now expects FlatPack because it renders `Table`.
3. `RecordingStudioSiteCategories.configuration.layout` defaults to `nil`.
   `nil` uses `RecordingStudio.configuration.layout`, then
   `recording_studio/default_layout`. Assign a layout name, `false`, or a
   callable that accepts `controller:`.
4. Call `recording_studio_layout` on engine and host controllers. Do not
   include `RecordingStudio::UsesDefaultLayout` and do not hard-code
   `layout "recording_studio/default_layout"` or
   `layout "recording_studio_site_categories/blank"`.
5. If you copied the engine categories index into the host, delete the blank
   layout, the Tailwind table fallback, and PageNav `anchor_url:`.
