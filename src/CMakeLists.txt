
if (NOT STATIC_LIBRARY)
    ecm_create_qm_loader(klimbgrades_QM_LOADER klimbgrades_qt)
endif()

set(klimbgrades_SRCS
    availablegradesmodel.cpp
    data.cpp
    main.cpp
    )

qt_add_resources(RESOURCES resources.qrc)

add_executable(klimbgrades ${klimbgrades_SRCS} ${RESOURCES})
target_link_libraries(klimbgrades Qt::Core Qt::Qml Qt::Quick Qt::QuickControls2 Qt::Svg KF6::ConfigCore)

if(NOT ANDROID)
    target_link_libraries(klimbgrades Qt::Widgets)
endif()

install(TARGETS klimbgrades ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

if (ANDROID)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/android/version.gradle.in ${CMAKE_BINARY_DIR}/version.gradle)
    install(FILES klimbgrades.svg DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami.2/icons)
else()
    install(FILES klimbgrades.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)
endif()

#include(KF6KirigamiMacros.cmake)
kirigami_package_breeze_icons(ICONS documentinfo view-refresh edit-clear games-highscores)
