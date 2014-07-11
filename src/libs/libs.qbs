import qbs

Project {
    name: "Libs"
    references: [
        "aggregation/aggregation.qbs",
        "cplusplus/cplusplus.qbs",
        "extensionsystem/extensionsystem.qbs",
        "languageutils/languageutils.qbs",
        "qmljs/qmljs.qbs",
        "qmldebug/qmldebug.qbs",
        "ssh/ssh.qbs",
        "utils/process_stub.qbs",
        "utils/process_ctrlc_stub.qbs",
        "utils/utils.qbs",
    ].concat(project.additionalLibs)
}
