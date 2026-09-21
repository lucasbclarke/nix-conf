require("nvim-treesitter").install({ "qmljs" })

vim.filetype.add({
    extension = { qml = "qml" },
})

local function find_qml_dir(exe)
    local resolved = vim.fn.exepath(exe)
    if resolved == "" then
        return nil
    end
    resolved = vim.fn.resolve(resolved)
    local qml = vim.fn.fnamemodify(resolved, ":h:h") .. "/lib/qt-6/qml"
    if vim.fn.isdirectory(qml) == 1 then
        return qml
    end
    return nil
end

local cmd = { "qmlls" }
for _, dir in ipairs({ find_qml_dir("quickshell"), find_qml_dir("qmlls") }) do
    if dir and not vim.tbl_contains(cmd, dir) then
        table.insert(cmd, "-I")
        table.insert(cmd, dir)
    end
end

vim.lsp.config("qmlls", {
    cmd = cmd,
    filetypes = { "qml" },
    root_dir = vim.uv.cwd(),
})

vim.lsp.enable("qmlls")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "qml" },
    callback = function()
        vim.treesitter.start()
    end,
})
