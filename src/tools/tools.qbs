import qbs

Project {
    name: "Tools"
    references: [
        "qtcdebugger/qtcdebugger.qbs",
        "qtcreatorcrashhandler/qtcreatorcrashhandler.qbs",
    ].concat(project.additionalTools)
}
