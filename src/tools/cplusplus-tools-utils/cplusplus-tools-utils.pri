DEPENDPATH += $$PWD
INCLUDEPATH += $$PWD $$PWD/../../libs/utils

DEFINES += PATH_PREPROCESSOR_CONFIG=\\\"$$PWD/pp-configuration.inc\\\"
DEFINES += QTCREATOR_UTILS_STATIC_LIB

HEADERS += \
    $$PWD/cplusplus-tools-utils.h \
    $$PWD/../../libs/utils/environment.h

SOURCES += \
    $$PWD/cplusplus-tools-utils.cpp \
    $$PWD/../../libs/utils/environment.cpp
