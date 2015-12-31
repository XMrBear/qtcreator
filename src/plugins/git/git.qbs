import qbs 1.0

QtcPlugin {
    name: "Git"
    condition: project.fullBuilds

    Depends { name: "Qt"; submodules: ["widgets", "network"] }
    Depends { name: "Utils" }

    Depends { name: "Core" }
    Depends { name: "TextEditor" }
    Depends { name: "VcsBase" }
    Depends { name: "DiffEditor" }

    files: [
        "annotationhighlighter.cpp",
        "annotationhighlighter.h",
        "branchadddialog.cpp",
        "branchadddialog.h",
        "branchadddialog.ui",
        "branchcheckoutdialog.cpp",
        "branchcheckoutdialog.h",
        "branchcheckoutdialog.ui",
        "branchdialog.cpp",
        "branchdialog.h",
        "branchdialog.ui",
        "branchmodel.cpp",
        "branchmodel.h",
        "changeselectiondialog.cpp",
        "changeselectiondialog.h",
        "changeselectiondialog.ui",
        "commitdata.cpp",
        "commitdata.h",
        "git.qrc",
        "gitclient.cpp",
        "gitclient.h",
        "gitconstants.h",
        "giteditor.cpp",
        "giteditor.h",
        "githighlighters.cpp",
        "githighlighters.h",
        "gitplugin.cpp",
        "gitplugin.h",
        "gitsettings.cpp",
        "gitsettings.h",
        "gitsubmiteditor.cpp",
        "gitsubmiteditor.h",
        "gitsubmiteditorwidget.cpp",
        "gitsubmiteditorwidget.h",
        "gitsubmitpanel.ui",
        "gitutils.cpp",
        "gitutils.h",
        "gitversioncontrol.cpp",
        "gitversioncontrol.h",
        "logchangedialog.cpp",
        "logchangedialog.h",
        "mergetool.cpp",
        "mergetool.h",
        "remoteadditiondialog.ui",
        "remotedialog.cpp",
        "remotedialog.h",
        "remotedialog.ui",
        "remotemodel.cpp",
        "remotemodel.h",
        "settingspage.cpp",
        "settingspage.h",
        "settingspage.ui",
        "stashdialog.cpp",
        "stashdialog.h",
        "stashdialog.ui",
    ]

    Group {
        name: "Gerrit"
        prefix: "gerrit/"
        files: [
            "branchcombobox.cpp",
            "branchcombobox.h",
            "gerritdialog.cpp",
            "gerritdialog.h",
            "gerritmodel.cpp",
            "gerritmodel.h",
            "gerritoptionspage.cpp",
            "gerritoptionspage.h",
            "gerritparameters.cpp",
            "gerritparameters.h",
            "gerritplugin.cpp",
            "gerritplugin.h",
            "gerritpushdialog.cpp",
            "gerritpushdialog.h",
            "gerritpushdialog.ui",
        ]
    }
}
