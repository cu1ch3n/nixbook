{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        "browser.tabs.loadBookmarksInTabs" = true; # Opening bookmarks in new tabs
        "browser.tabs.firefox-view" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable pocket
        "extensions.pocket.enabled" = false; # Disable pocket
        "identity.fxaccounts.enabled" = false; # Disable Firefox accounts integration
        "media.eme.enabled" = true; # Enable DRM
        "media.gmp-widevinecdm.visible" = true; # Enable DRM
        "media.gmp-widevinecdm.enabled" = true; # Enable DRM
        "media.videocontrols.picture-in-picture.video-toggle.always-show" = true; # Always shows the Picture in Picture toggle
        "narrate.enabled" = false; # Disable text to speech in reader mode
        "signon.autofillForms" = false; # Disable built-in form-filling
        "signon.rememberSignons" = false; # Disable built-in password manager
        "ui.systemUsesDarkTheme" = true; # Dark mode
      };

      search = {
        default = "Google";
      };
    };
  };
}
