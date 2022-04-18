self: super: {
  utils = {
    bash = {
      shebang = "#!/usr/bin/env bash";
      result = cmd: "$(${cmd})";
    };

    sh = {
      shebang = "#!/usr/bin/env sh";
    };

    sketchybar = {
      cmds = config: {
        plugin = name: "\"${config.xdg.configHome}/sketchybar/plugins/${name}\"";
        item = name: "source \"${config.xdg.configHome}/sketchybar/items/${name}\"";
      };
    };
  };
}
