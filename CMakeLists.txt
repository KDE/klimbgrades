cmake_minimum_required(VERSION 3.16)

project(klimbgrades VERSION 0.1)

set(KF_MIN_VERSION "5.18.0")
set(QT_MIN_VERSION "5.15.0")
if (ANDROID)
    set(QT_MIN_VERSION "5.15.8")
endif()

find_package(ECM ${KF_MIN_VERSION} REQUIRED NO_MODULE)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(FeatureSummary)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMPoQmTools)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt${QT_MAJOR_VERSION} ${QT_MIN_VERSION} REQUIRED NO_MODULE COMPONENTS Core Quick Test Gui Svg QuickControls2)

if(NOT ANDROID)
    find_package(Qt${QT_MAJOR_VERSION}Widgets REQUIRED)
endif()

find_package(KF${QT_MAJOR_VERSION}Config ${KF${QT_MAJOR_VERSION}_DEP_VERSION} "5.22.0")
find_package(KF${QT_MAJOR_VERSION}Kirigami2 ${KF${QT_MAJOR_VERSION}_DEP_VERSION} "5.22.0")

set (CMAKE_CXX_STANDARD 11)

add_subdirectory(src)

if (IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/po")
    ecm_install_po_files_as_qm(po)
endif()

install(FILES org.kde.klimbgrades.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
install(PROGRAMS org.kde.klimbgrades.desktop DESTINATION ${KDE_INSTALL_APPDIR})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)

