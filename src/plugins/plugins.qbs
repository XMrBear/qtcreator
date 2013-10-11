import qbs

Project {
    name: "Plugins"

    references: [
        "coreplugin/coreplugin.qbs",
        "coreplugin/images/logo/logo.qbs",
        "cppeditor/cppeditor.qbs",
        "cpptools/cpptools.qbs",
        "diffeditor/diffeditor.qbs",
        "find/find.qbs",
        "git/git.qbs",
        "locator/locator.qbs",
        "projectexplorer/projectexplorer.qbs",
        "qbsprojectmanager/qbsprojectmanager.qbs",
        "qmljstools/qmljstools.qbs",
        "qtsupport/qtsupport.qbs",
        "texteditor/texteditor.qbs",
        "vcsbase/vcsbase.qbs",
    ].concat(project.additionalPlugins)
}
