import qbs

Project {
    name: "Plugins"

    references: [
        "analyzerbase/analyzerbase.qbs",
        "bineditor/bineditor.qbs",
        "bookmarks/bookmarks.qbs",
        "clangcodemodel/clangcodemodel.qbs",
        "classview/classview.qbs",
        "coreplugin/coreplugin.qbs",
        "coreplugin/images/logo/logo.qbs",
        "cppeditor/cppeditor.qbs",
        "cpptools/cpptools.qbs",
        "debugger/debugger.qbs",
        "diffeditor/diffeditor.qbs",
        "genericprojectmanager/genericprojectmanager.qbs",
        "git/git.qbs",
        "help/help.qbs",
        "imageviewer/imageviewer.qbs",
        "macros/macros.qbs",
        "modeleditor/modeleditor.qbs",
        "projectexplorer/projectexplorer.qbs",
        "qbsprojectmanager/qbsprojectmanager.qbs",
//        "qmldesigner/qmldesigner.qbs",
        "qmljseditor/qmljseditor.qbs",
        "qmljstools/qmljstools.qbs",
        "qmlprofiler/qmlprofiler.qbs",
        "qmakeprojectmanager/qmakeprojectmanager.qbs",
        "qtsupport/qtsupport.qbs",
        "resourceeditor/resourceeditor.qbs",
        "texteditor/texteditor.qbs",
        "todo/todo.qbs",
        "vcsbase/vcsbase.qbs",
        "welcome/welcome.qbs",
    ].concat(project.additionalPlugins)
}
