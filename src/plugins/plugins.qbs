import qbs

Project {
    name: "Plugins"

    references: [
        "coreplugin/coreplugin.qbs",
        "coreplugin/images/logo/logo.qbs",
        "cppeditor/cppeditor.qbs",
        "cpptools/cpptools.qbs",
        "find/find.qbs",
        "help/help.qbs",
        "locator/locator.qbs",
        "projectexplorer/projectexplorer.qbs",
        "qbsprojectmanager/qbsprojectmanager.qbs",
        "qmljstools/qmljstools.qbs",
        "qtsupport/qtsupport.qbs",
        "texteditor/texteditor.qbs",
        "welcome/welcome.qbs",
    ].concat(project.additionalPlugins)
}
