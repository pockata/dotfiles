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

disableUserPackageKeymaps = ->
    skip = ['vim-mode']
    for ap in atom.packages.getLoadedPackages() when ap.keymaps.length isnt 0
        unless atom.packages.isBundledPackage(ap.name) || skip.indexOf(ap.name) != -1 # filter core packages
            console.log "Disabling #{ap.name}, #{ap.path}"
            atom.keymaps.removeBindingsFromSource keymap[0] for keymap in ap.keymaps

    undefined

disableUserPackageKeymaps()

# https://github.com/atom-community/linter/issues/726
process.env.PATH = ["/usr/local/bin", process.env.PATH].join(":")
