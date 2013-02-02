import qbs.base 1.0

import "../QtcPlugin.qbs" as QtcPlugin
import "../../../qbs/defaults.js" as Defaults

QtcPlugin {
    name: "ProjectExplorer"

    Depends { name: "Qt"; submodules: ["widgets", "xml", "network", "script", "declarative"] }
    Depends { name: "Core" }
    Depends { name: "Locator" }
    Depends { name: "Find" }
    Depends { name: "TextEditor" }
    Depends { name: "QtcSsh" }

    Depends { name: "cpp" }
    cpp.defines: base.concat("QTC_CPU=X86Architecture")
    cpp.includePaths: base.concat([
        "customwizard",
        "publishing"
    ])

    files: [
        "abi.cpp",
        "abi.h",
        "abiwidget.cpp",
        "abiwidget.h",
        "abstractprocessstep.cpp",
        "abstractprocessstep.h",
        "allprojectsfilter.cpp",
        "allprojectsfilter.h",
        "allprojectsfind.cpp",
        "allprojectsfind.h",
        "applicationlauncher.cpp",
        "applicationlauncher.h",
        "appoutputpane.cpp",
        "appoutputpane.h",
        "baseprojectwizarddialog.cpp",
        "baseprojectwizarddialog.h",
        "buildconfiguration.cpp",
        "buildconfiguration.h",
        "buildconfigurationmodel.cpp",
        "buildconfigurationmodel.h",
        "buildenvironmentwidget.cpp",
        "buildenvironmentwidget.h",
        "buildmanager.cpp",
        "buildmanager.h",
        "buildprogress.cpp",
        "buildprogress.h",
        "buildsettingspropertiespage.cpp",
        "buildsettingspropertiespage.h",
        "buildstep.cpp",
        "buildstep.h",
        "buildsteplist.cpp",
        "buildsteplist.h",
        "buildstepspage.cpp",
        "buildstepspage.h",
        "buildtargetinfo.h",
        "cesdkhandler.cpp",
        "cesdkhandler.h",
        "clangparser.cpp",
        "clangparser.h",
        "codestylesettingspropertiespage.cpp",
        "codestylesettingspropertiespage.h",
        "codestylesettingspropertiespage.ui",
        "compileoutputwindow.cpp",
        "compileoutputwindow.h",
        "copytaskhandler.cpp",
        "copytaskhandler.h",
        "corelistenercheckingforrunningbuild.cpp",
        "corelistenercheckingforrunningbuild.h",
        "currentprojectfilter.cpp",
        "currentprojectfilter.h",
        "currentprojectfind.cpp",
        "currentprojectfind.h",
        "customtoolchain.cpp",
        "customtoolchain.h",
        "dependenciespanel.cpp",
        "dependenciespanel.h",
        "deployablefile.cpp",
        "deployablefile.h",
        "deployconfiguration.cpp",
        "deployconfiguration.h",
        "deployconfigurationmodel.cpp",
        "deployconfigurationmodel.h",
        "deploymentdata.h",
        "doubletabwidget.cpp",
        "doubletabwidget.h",
        "doubletabwidget.ui",
        "editorconfiguration.cpp",
        "editorconfiguration.h",
        "editorsettingspropertiespage.cpp",
        "editorsettingspropertiespage.h",
        "editorsettingspropertiespage.ui",
        "environmentitemswidget.cpp",
        "environmentitemswidget.h",
        "environmentwidget.cpp",
        "environmentwidget.h",
        "foldernavigationwidget.cpp",
        "foldernavigationwidget.h",
        "gccparser.cpp",
        "gccparser.h",
        "gcctoolchain.cpp",
        "gcctoolchain.h",
        "gcctoolchainfactories.h",
        "gnumakeparser.cpp",
        "gnumakeparser.h",
        "headerpath.h",
        "ioutputparser.cpp",
        "ioutputparser.h",
        "iprojectmanager.h",
        "iprojectproperties.h",
        "itaskhandler.h",
        "kit.cpp",
        "kit.h",
        "kitchooser.cpp",
        "kitchooser.h",
        "kitconfigwidget.h",
        "kitinformation.cpp",
        "kitinformation.h",
        "kitinformationconfigwidget.cpp",
        "kitinformationconfigwidget.h",
        "kitmanager.cpp",
        "kitmanager.h",
        "kitmanagerconfigwidget.cpp",
        "kitmanagerconfigwidget.h",
        "kitmodel.cpp",
        "kitmodel.h",
        "kitoptionspage.cpp",
        "kitoptionspage.h",
        "ldparser.cpp",
        "ldparser.h",
        "linuxiccparser.cpp",
        "linuxiccparser.h",
        "localapplicationrunconfiguration.cpp",
        "localapplicationrunconfiguration.h",
        "localapplicationruncontrol.cpp",
        "localapplicationruncontrol.h",
        "metatypedeclarations.h",
        "miniprojecttargetselector.cpp",
        "miniprojecttargetselector.h",
        "namedwidget.cpp",
        "namedwidget.h",
        "nodesvisitor.cpp",
        "nodesvisitor.h",
        "outputparser_test.cpp",
        "outputparser_test.h",
        "pluginfilefactory.cpp",
        "pluginfilefactory.h",
        "processparameters.cpp",
        "processparameters.h",
        "processstep.cpp",
        "processstep.h",
        "processstep.ui",
        "project.cpp",
        "project.h",
        "projectconfiguration.cpp",
        "projectconfiguration.h",
        "projectexplorer.cpp",
        "projectexplorer.h",
        "projectexplorer.qrc",
        "projectexplorer_export.h",
        "projectexplorerconstants.h",
        "projectexplorersettings.h",
        "projectexplorersettingspage.cpp",
        "projectexplorersettingspage.h",
        "projectexplorersettingspage.ui",
        "projectfilewizardextension.cpp",
        "projectfilewizardextension.h",
        "projectmacroexpander.cpp",
        "projectmacroexpander.h",
        "projectmodels.cpp",
        "projectmodels.h",
        "projectnodes.cpp",
        "projectnodes.h",
        "projecttreewidget.cpp",
        "projecttreewidget.h",
        "projectwelcomepage.cpp",
        "projectwelcomepage.h",
        "projectwindow.cpp",
        "projectwindow.h",
        "projectwizardpage.cpp",
        "projectwizardpage.h",
        "projectwizardpage.ui",
        "removetaskhandler.cpp",
        "removetaskhandler.h",
        "runconfiguration.cpp",
        "runconfiguration.h",
        "runconfigurationmodel.cpp",
        "runconfigurationmodel.h",
        "runsettingspropertiespage.cpp",
        "runsettingspropertiespage.h",
        "session.cpp",
        "session.h",
        "sessiondialog.cpp",
        "sessiondialog.h",
        "sessiondialog.ui",
        "settingsaccessor.cpp",
        "settingsaccessor.h",
        "showineditortaskhandler.cpp",
        "showineditortaskhandler.h",
        "showoutputtaskhandler.cpp",
        "showoutputtaskhandler.h",
        "target.cpp",
        "target.h",
        "targetselector.cpp",
        "targetselector.h",
        "targetsettingspanel.cpp",
        "targetsettingspanel.h",
        "targetsettingswidget.cpp",
        "targetsettingswidget.h",
        "targetsettingswidget.ui",
        "task.cpp",
        "task.h",
        "taskhub.cpp",
        "taskhub.h",
        "taskmodel.cpp",
        "taskmodel.h",
        "taskwindow.cpp",
        "taskwindow.h",
        "toolchain.cpp",
        "toolchain.h",
        "toolchainconfigwidget.cpp",
        "toolchainconfigwidget.h",
        "toolchainmanager.cpp",
        "toolchainmanager.h",
        "toolchainoptionspage.cpp",
        "toolchainoptionspage.h",
        "vcsannotatetaskhandler.cpp",
        "vcsannotatetaskhandler.h",
        "customwizard/customwizard.cpp",
        "customwizard/customwizard.h",
        "customwizard/customwizardpage.cpp",
        "customwizard/customwizardpage.h",
        "customwizard/customwizardparameters.cpp",
        "customwizard/customwizardparameters.h",
        "customwizard/customwizardpreprocessor.cpp",
        "customwizard/customwizardpreprocessor.h",
        "customwizard/customwizardscriptgenerator.cpp",
        "customwizard/customwizardscriptgenerator.h",
        "devicesupport/desktopdevice.cpp",
        "devicesupport/desktopdevice.h",
        "devicesupport/desktopdevicefactory.cpp",
        "devicesupport/desktopdevicefactory.h",
        "devicesupport/deviceapplicationrunner.cpp",
        "devicesupport/deviceapplicationrunner.h",
        "devicesupport/devicefactoryselectiondialog.cpp",
        "devicesupport/devicefactoryselectiondialog.h",
        "devicesupport/devicefactoryselectiondialog.ui",
        "devicesupport/devicemanager.cpp",
        "devicesupport/devicemanager.h",
        "devicesupport/devicemanagermodel.cpp",
        "devicesupport/devicemanagermodel.h",
        "devicesupport/deviceprocessesdialog.cpp",
        "devicesupport/deviceprocessesdialog.h",
        "devicesupport/deviceprocesslist.cpp",
        "devicesupport/deviceprocesslist.h",
        "devicesupport/devicesettingspage.cpp",
        "devicesupport/devicesettingspage.h",
        "devicesupport/devicesettingswidget.cpp",
        "devicesupport/devicesettingswidget.h",
        "devicesupport/devicesettingswidget.ui",
        "devicesupport/deviceusedportsgatherer.cpp",
        "devicesupport/deviceusedportsgatherer.h",
        "devicesupport/idevice.cpp",
        "devicesupport/idevice.h",
        "devicesupport/idevicefactory.cpp",
        "devicesupport/idevicefactory.h",
        "devicesupport/idevicewidget.h",
        "devicesupport/localprocesslist.cpp",
        "devicesupport/localprocesslist.h",
        "devicesupport/sshdeviceprocesslist.cpp",
        "devicesupport/sshdeviceprocesslist.h",
        "images/BuildSettings.png",
        "images/CodeStyleSettings.png",
        "images/Desktop.png",
        "images/DeviceConnected.png",
        "images/DeviceDisconnected.png",
        "images/DeviceReadyToUse.png",
        "images/EditorSettings.png",
        "images/MaemoDevice.png",
        "images/ProjectDependencies.png",
        "images/RunSettings.png",
        "images/Simulator.png",
        "images/build.png",
        "images/build_32.png",
        "images/build_small.png",
        "images/clean.png",
        "images/clean_small.png",
        "images/closetab.png",
        "images/compile_error.png",
        "images/compile_warning.png",
        "images/debugger_start.png",
        "images/debugger_start_small.png",
        "images/findallprojects.png",
        "images/findproject.png",
        "images/leftselection.png",
        "images/midselection.png",
        "images/projectexplorer.png",
        "images/rebuild.png",
        "images/rebuild_small.png",
        "images/rightselection.png",
        "images/run.png",
        "images/run_small.png",
        "images/session.png",
        "images/stop.png",
        "images/stop_small.png",
        "images/targetbuildselected.png",
        "images/targetleftbutton.png",
        "images/targetpanel_bottom.png",
        "images/targetpanel_gradient.png",
        "images/targetremovebutton.png",
        "images/targetremovebuttondark.png",
        "images/targetrightbutton.png",
        "images/targetrunselected.png",
        "images/targetseparatorbackground.png",
        "images/targetunselected.png",
        "images/window.png",
        "publishing/ipublishingwizardfactory.h",
        "publishing/publishingwizardselectiondialog.cpp",
        "publishing/publishingwizardselectiondialog.h",
        "publishing/publishingwizardselectiondialog.ui",
    ]

    Group {
        condition: qbs.targetOS == "windows" || Defaults.testsEnabled(qbs)
        files: [
           "abstractmsvctoolchain.cpp",
           "abstractmsvctoolchain.h",
           "msvcparser.cpp",
           "msvcparser.h",
           "msvctoolchain.cpp",
           "msvctoolchain.h",
           "wincetoolchain.cpp",
           "wincetoolchain.h",
           "windebuginterface.cpp",
           "windebuginterface.h",
        ]
    }

    Group {
        condition: Defaults.testsEnabled(qbs)
        files: ["outputparser_test.h", "outputparser_test.cpp"]
    }

    ProductModule {
        Depends { name: "Qt.network" }
    }
}
