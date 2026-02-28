# vim:fileencoding=utf-8:foldmethod=marker


def setup(c, samecolorrows = False):
    palette = {
        "base": "#191724",
        "surface": "#1f1d2e",
        "overlay": "#26233a",
        "muted": "#6e6a86",
        "subtle": "#908caa",
        "text": "#e0def4",
        "love": "#eb6f92",
        "gold": "#f6c177",
        "rose": "#ebbcba",
        "pine": "#31748f",
        "foam": "#9ccfd8",
        "iris": "#c4a7e7",
        "highlight low": "#21202e",
        "highlight med": "#302d41",
        "highlight high": "#524f67",
    }


    # completion {{{
    ## Background color of the completion widget category headers.
    c.colors.completion.category.bg = palette["base"]
    ## Bottom border color of the completion widget category headers.
    c.colors.completion.category.border.bottom = palette["surface"]
    ## Top border color of the completion widget category headers.
    c.colors.completion.category.border.top = palette["subtle"]
    ## Foreground color of completion widget category headers.
    c.colors.completion.category.fg = palette["foam"]
    ## Background color of the completion widget for even and odd rows.
    if samecolorrows:
        c.colors.completion.even.bg = palette["surface"]
        c.colors.completion.odd.bg = c.colors.completion.even.bg
    else:
        c.colors.completion.even.bg = palette["surface"]
        c.colors.completion.odd.bg = palette["overlay"]
    ## Text color of the completion widget.
    c.colors.completion.fg = palette["subtle"]

    ## Background color of the selected completion item.
    c.colors.completion.item.selected.bg = palette["rose"]
    ## Bottom border color of the selected completion item.
    c.colors.completion.item.selected.border.bottom = palette["rose"]
    ## Top border color of the completion widget category headers.
    c.colors.completion.item.selected.border.top = palette["rose"]
    ## Foreground color of the selected completion item.
    c.colors.completion.item.selected.fg = palette["base"]
    ## Foreground color of the selected completion item.
    c.colors.completion.item.selected.match.fg = palette["rose"]
    ## Foreground color of the matched text in the completion.
    c.colors.completion.match.fg = palette["pine"]

    ## Color of the scrollbar in completion view
    c.colors.completion.scrollbar.bg = palette["overlay"]
    ## Color of the scrollbar handle in completion view.
    c.colors.completion.scrollbar.fg = palette["muted"]
    # }}}

    # downloads {{{
    c.colors.downloads.bar.bg = palette["base"]
    c.colors.downloads.error.bg = palette["base"]
    c.colors.downloads.start.bg = palette["base"]
    c.colors.downloads.stop.bg = palette["base"]

    c.colors.downloads.error.fg = palette["love"]
    c.colors.downloads.start.fg = palette["pine"]
    c.colors.downloads.stop.fg = palette["foam"]
    c.colors.downloads.system.fg = "none"
    c.colors.downloads.system.bg = "none"
    # }}}

    # hints {{{
    ## Background color for hints. Note that you can use a `rgba(...)` value
    ## for transparency.
    c.colors.hints.bg = palette["rose"]

    ## Font color for hints.
    c.colors.hints.fg = palette["base"]

    ## Hints
    c.hints.border = "1px solid " + palette["muted"]

    ## Font color for the matched part of hints.
    c.colors.hints.match.fg = palette["subtle"]
    # }}}

    # keyhints {{{
    ## Background color of the keyhint widget.
    c.colors.keyhint.bg = palette["base"]

    ## Text color for the keyhint widget.
    c.colors.keyhint.fg = palette["text"]

    ## Highlight color for keys to complete the current keychain.
    c.colors.keyhint.suffix.fg = palette["pine"]
    # }}}

    # messages {{{
    ## Background color of an error message.
    c.colors.messages.error.bg = palette["base"]
    ## Background color of an info message.
    c.colors.messages.info.bg = palette["base"]
    ## Background color of a warning message.
    c.colors.messages.warning.bg = palette["base"]

    ## Border color of an error message.
    c.colors.messages.error.border = palette["base"]
    ## Border color of an info message.
    c.colors.messages.info.border = palette["base"]
    ## Border color of a warning message.
    c.colors.messages.warning.border = palette["base"]

    ## Foreground color of an error message.
    c.colors.messages.error.fg = palette["love"]
    ## Foreground color an info message.
    c.colors.messages.info.fg = palette["text"]
    ## Foreground color a warning message.
    c.colors.messages.warning.fg = palette["rose"]
    # }}}

    # prompts {{{
    ## Background color for prompts.
    c.colors.prompts.bg = palette["overlay"]

    # ## Border used around UI elements in prompts.
    c.colors.prompts.border = "1px solid " + palette["overlay"]

    ## Foreground color for prompts.
    c.colors.prompts.fg = palette["text"]

    ## Background color for the selected item in filename prompts.
    c.colors.prompts.selected.bg = palette["surface"]

    ## Background color for the selected item in filename prompts.
    c.colors.prompts.selected.fg = palette["rose"]
    # }}}

    # statusbar {{{
    ## Background color of the statusbar.
    c.colors.statusbar.normal.bg = palette["base"]
    ## Background color of the statusbar in insert mode.
    c.colors.statusbar.insert.bg = palette["overlay"]
    ## Background color of the statusbar in command mode.
    c.colors.statusbar.command.bg = palette["base"]
    ## Background color of the statusbar in caret mode.
    c.colors.statusbar.caret.bg = palette["base"]
    ## Background color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.bg = palette["base"]

    ## Background color of the progress bar.
    c.colors.statusbar.progress.bg = palette["base"]
    ## Background color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.bg = palette["base"]

    ## Foreground color of the statusbar.
    c.colors.statusbar.normal.fg = palette["text"]
    ## Foreground color of the statusbar in insert mode.
    c.colors.statusbar.insert.fg = palette["rose"]
    ## Foreground color of the statusbar in command mode.
    c.colors.statusbar.command.fg = palette["text"]
    ## Foreground color of the statusbar in passthrough mode.
    c.colors.statusbar.passthrough.fg = palette["rose"]
    ## Foreground color of the statusbar in caret mode.
    c.colors.statusbar.caret.fg = palette["rose"]
    ## Foreground color of the statusbar in caret mode with a selection.
    c.colors.statusbar.caret.selection.fg = palette["rose"]

    ## Foreground color of the URL in the statusbar on error.
    c.colors.statusbar.url.error.fg = palette["love"]

    ## Default foreground color of the URL in the statusbar.
    c.colors.statusbar.url.fg = palette["text"]

    ## Foreground color of the URL in the statusbar for hovelove links.
    c.colors.statusbar.url.hover.fg = palette["iris"]

    ## Foreground color of the URL in the statusbar on successful load
    c.colors.statusbar.url.success.http.fg = palette["foam"]

    ## Foreground color of the URL in the statusbar on successful load
    c.colors.statusbar.url.success.https.fg = palette["foam"]

    ## Foreground color of the URL in the statusbar when there's a warning.
    c.colors.statusbar.url.warn.fg = palette["gold"]

    ## PRIVATE MODE COLORS
    ## Background color of the statusbar in private browsing mode.
    c.colors.statusbar.private.bg = palette["surface"]
    ## Foreground color of the statusbar in private browsing mode.
    c.colors.statusbar.private.fg = palette["subtle"]
    ## Background color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.bg = palette["base"]
    ## Foreground color of the statusbar in private browsing + command mode.
    c.colors.statusbar.command.private.fg = palette["subtle"]

    # }}}

    # tabs {{{
    ## Background color of the tab bar.
    c.colors.tabs.bar.bg = palette["overlay"]
    ## Background color of unselected even tabs.
    c.colors.tabs.even.bg = palette["overlay"]
    ## Background color of unselected odd tabs.
    c.colors.tabs.odd.bg = palette["overlay"]

    ## Foreground color of unselected even tabs.
    c.colors.tabs.even.fg = palette["subtle"]
    ## Foreground color of unselected odd tabs.
    c.colors.tabs.odd.fg = palette["subtle"]

    ## Color for the tab indicator on errors.
    c.colors.tabs.indicator.error = palette["love"]
    ## Color gradient interpolation system for the tab indicator.
    ## Valid values:
    ##	 - rgb: Interpolate in the RGB color system.
    ##	 - hsv: Interpolate in the HSV color system.
    ##	 - hsl: Interpolate in the HSL color system.
    ##	 - none: Don't show a gradient.
    c.colors.tabs.indicator.system = "none"

    # ## Background color of selected even tabs.
    c.colors.tabs.selected.even.bg = palette["rose"]
    # ## Background color of selected odd tabs.
    c.colors.tabs.selected.odd.bg = palette["rose"]

    # ## Foreground color of selected even tabs.
    c.colors.tabs.selected.even.fg = palette["base"]
    # ## Foreground color of selected odd tabs.
    c.colors.tabs.selected.odd.fg = palette["base"]
    # }}}

    # context menus {{{
    c.colors.contextmenu.menu.bg = palette["base"]
    c.colors.contextmenu.menu.fg = palette["text"]

    c.colors.contextmenu.disabled.bg = palette["muted"]
    c.colors.contextmenu.disabled.fg = palette["muted"]

    c.colors.contextmenu.selected.bg = palette["muted"]
    c.colors.contextmenu.selected.fg = palette["rose"]
    # }}}

    # background color for webpages {{{
    c.colors.webpage.bg = palette["base"]
    # }}}
