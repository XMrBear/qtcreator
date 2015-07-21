import qbs 1.0

QtcPlugin {
    name: "ImageViewer"
    condition: project.fullBuilds

    Depends { name: "Qt"; submodules: ["widgets"] }
    Depends { name: "Utils" }

    Depends { name: "Core" }
    cpp.defines: base.concat([
        "QT_NO_SVG"
    ])

    files: [
        "imageview.cpp",
        "imageview.h",
        "imageviewer.cpp",
        "imageviewer.h",
        "imageviewer.qrc",
        "imagevieweractionhandler.cpp",
        "imagevieweractionhandler.h",
        "imageviewerconstants.h",
        "imageviewerfactory.cpp",
        "imageviewerfactory.h",
        "imageviewerfile.cpp",
        "imageviewerfile.h",
        "imageviewerplugin.cpp",
        "imageviewerplugin.h",
        "imageviewertoolbar.ui",
    ]
}
