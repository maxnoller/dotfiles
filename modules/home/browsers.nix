{ config, pkgs, ... }:

{
  programs.google-chrome = {
    enable = true;
    # No nixGL wrapper needed - GPU is set up system-wide via targets.genericLinux.gpu
    commandLineArgs = [
      "--ozone-platform=x11"
      "--disable-gpu-memory-buffer-video-frames"
      "--disable-features=VaapiVideoDecoder"
    ];
  };
}
