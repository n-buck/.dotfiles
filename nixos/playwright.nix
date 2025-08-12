{
  config,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    playwright-driver.browsers
  ];

  environment.variables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };
}
