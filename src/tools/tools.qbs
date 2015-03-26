import qbs

Project {
    name: "Tools"
    references: [
        "cplusplustools.qbs",
        "qtcdebugger/qtcdebugger.qbs",
        "qtcreatorcrashhandler/qtcreatorcrashhandler.qbs",
    ].concat(project.additionalTools)
}
