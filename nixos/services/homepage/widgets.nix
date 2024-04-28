{
  services.homepage-dashboard.widgets = [
    {
      resources = {
        cpu = true;
        cputemp = true;
        memory = true;
      };
    }
    {
      openmeteo = {
        label = "Hong Kong";
        latitude = 22.2783;
        longitude = 114.1747;
        timezone = "Asia/Hong_Kong";
        units = "metric";
        cache = 5;
      };
    }
    {
      search = {
        provider = "google";
        target = "_blank";
        showSearchSuggestions = true;
      };
    }
    {
      search = {
        provider = "custom";
        url = "https://search.nixos.org/packages?channel=unstable&query=";
        target = "_blank";
      };
    }
  ];
}
