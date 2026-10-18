{ ... }:
{
  xdg.configFile."devenv/config.yaml".text = ''
    version: 1
    tui:
      statusline:
        enabled: false
    shell:
      prompt_prefix: false
  '';
}
