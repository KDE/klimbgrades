
if (NOT STATIC_LIBRARY)
    ecm_create_qm_loader(klimbgrades_QM_LOADER klimbgrades_qt)
endif()

set(klimbgrades_SRCS
    availablegradesmodel.cpp
    data.cpp
    main.cpp
    )

qt5_add_resources(RESOURCES resources.qrc)

add_executable(klimbgrades ${klimbgrades_SRCS} ${RESOURCES})
target_link_libraries(klimbgrades Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Svg KF5::ConfigCore)

install(TARGETS klimbgrades ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

if (ANDROID)
    install(FILES klimbgrades.svg DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami.2/icons)
else()
    install(FILES klimbgrades.svg DESTINATION ${KDE_INSTALL_FULL_ICONDIR}/hicolor/scalable/apps)
endif()

#include(KF5KirigamiMacros.cmake)
kirigami_package_breeze_icons(ICONS documentinfo view-refresh edit-clear games-highscores)
