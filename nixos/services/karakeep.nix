{ pkgs, ... }:
{
  services.karakeep = {
    enable = true;
    package = pkgs.unstable.karakeep;
    extraEnvironment = {
      CRAWLER_VIDEO_DOWNLOAD = "true";
      CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = "-1";
      OLLAMA_BASE_URL = "http://192.168.1.228:11434";
      INFERENCE_TEXT_MODEL = "llama3.2:1b";
      INFERENCE_IMAGE_MODEL = "llava-phi3";
      INFERENCE_CONTEXT_LENGTH = "4096";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
