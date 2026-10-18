; Nixvim injects lua/vim, but not tmux. This fragment is appended to
; Nixvim's own queries/nix/injections.scm so that tmux options embedded in a
; Nix file are parsed and highlighted as tmux.
;
; The options are matched through the enclosing `programs.tmux` attrset: a bare
; `extraConfig` attribute would also match unrelated options such as
; `services.git.extraConfig` or `programs.starship.extraConfig`.

; programs.tmux.extraConfig / extraConfigEarly / extraConfigLater
(binding
  attrpath: (attrpath
    (identifier) @_ns
    (identifier) @_module
  )
  expression: (attrset_expression
    (binding_set
      (binding
        attrpath: (attrpath (identifier) @_attr)
        expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
          (list_expression [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
          ])
          (apply_expression argument: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
            (list_expression [
              (string_expression (string_fragment) @injection.content)
              (indented_string_expression (string_fragment) @injection.content)
            ])
          ])
        ]
      )
    )
  )
  (#eq? @_ns "programs")
  (#eq? @_module "tmux")
  (#any-of? @_attr "extraConfig" "extraConfigEarly" "extraConfigLater")
  (#set! injection.language "tmux"))

; programs.tmux.plugins.<plugin>.extraConfig
(binding
  attrpath: (attrpath
    (identifier) @_ns
    (identifier) @_module
    (identifier) @_plugins
    (identifier) @_plugin
  )
  expression: (attrset_expression
    (binding_set
      (binding
        attrpath: (attrpath (identifier) @_attr)
        expression: [
          (string_expression (string_fragment) @injection.content)
          (indented_string_expression (string_fragment) @injection.content)
        ]
      )
    )
  )
  (#eq? @_ns "programs")
  (#eq? @_module "tmux")
  (#eq? @_plugins "plugins")
  (#eq? @_attr "extraConfig")
  (#set! injection.language "tmux"))
