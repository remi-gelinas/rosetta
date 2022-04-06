{
  programs.starship = {
    enable = true;

    settings = {
      battery.display.threshold = 25;
      directory.fish_style_pwd_dir_length = 1;
      directory.truncation_length = 2;
      gcloud.disabled = true;
      memory_usage.disabled = true;
    };
  };
}
