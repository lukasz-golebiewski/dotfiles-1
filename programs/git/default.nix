{ settings }: {
  programs.git = {
    enable = true;
    userEmail = "little-dude@mailbox.org";
    userName = "little-dude";
    extraConfig = {
      push = { default = "matching"; };
      core = {
        editor = "nvim";
        excludesfile = "${./gitignore}";
        ignorecase = false;
        pager = "diff-so-fancy | less --tabs=4 -RFX";
        commentChar = "@";
      };
      github = { user = "little-dude"; };
      forge = {
        # By default, forge uses the remote named "origin" as the
        # *upstream*, but we follow a different convention where
        # "upstream" is the upstream remote and "origin" is our own
        # fork.
        remote = "upstream";
      };
      color = {
        ui = true;
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
        diff = {
          meta = 11;
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
      };
    };
    includes = [{
      condition = "gitdir:${settings.workdir}/**";
      path = ./work.config;
    }];

  };
}
