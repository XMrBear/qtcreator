import qbs

Project {
    name: "Tools"
    references: [
        "clangbackend/clangbackend.qbs",
        "cplusplustools.qbs",
        "qtcdebugger/qtcdebugger.qbs",
        "qtcreatorcrashhandler/qtcreatorcrashhandler.qbs",
    ].concat(project.additionalTools)
}
