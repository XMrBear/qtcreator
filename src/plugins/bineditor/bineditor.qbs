import qbs 1.0

QtcPlugin {
    name: "BinEditor"
    condition: project.fullBuilds

    Depends { name: "Qt.widgets" }
    Depends { name: "Aggregation" }
    Depends { name: "Utils" }

    Depends { name: "Core" }
    Depends { name: "TextEditor" }

    files: [
        "bineditor.cpp",
        "bineditor.h",
        "bineditorconstants.h",
        "bineditorplugin.cpp",
        "bineditorplugin.h",
        "markup.h",
    ]
}

