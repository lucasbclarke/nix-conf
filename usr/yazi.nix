{ ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      mgr = {
        show_hidden = true;
        ratio = [ 1 4 3 ];
        sort_by = "natural";
        sort_dir_first = true;
      };
      
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
    };

    keymap = {
      mgr.prepend_keymap = [
      { on = [ "J" ]; run = "seek 5";  desc = "Seek down in preview"; }
      { on = [ "K" ]; run = "seek -5"; desc = "Seek up in preview"; }
      ];
    };

  };
}
