{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  moonraker-api,
}:

buildHomeAssistantComponent rec {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    tag = version;
    hash = "sha256-BPlHMTGb1xSxFydeLsHKBlXSqgh1qmTrenPo+XPx2IM=";
  };

  dependencies = [
    moonraker-api
  ];

  #skip phases with nothing to do
  dontConfigure = true;
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${version}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
  };
}
