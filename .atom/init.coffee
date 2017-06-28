# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"


## キーバインドを有効にする Community Package
keymapsToEnable = [
  'advanced-open-file'
  'atom-runner'
  'foldingtext-for-atom'
  'markdown-preview-plus'
  'markdown-table-editor'
  'markdown-writer'
  'pdf-view'
  'project-manager'
  'tablr'
]

## Community Package のキーバインドを無効にする
for p in atom.packages.getLoadedPackages()
  if not atom.packages.isBundledPackage(p.name) and p.name not in keymapsToEnable
    p.deactivateKeymaps()
    console.log "Package keymaps deactivated: #{p.name}"


## prefix key 'ctrl-k' を無効にする
for b in atom.keymaps.getKeyBindings()
  k = b.keystrokes
  if /^ctrl-k /.test(k)
    c = b.command
    b.command = 'unset!'
    console.log "Keybinding disabled: #{k}\t #{c}\t #{b.selector}\t #{b.source}"
