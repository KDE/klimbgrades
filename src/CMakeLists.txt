
set(climbinggrades_SRCS
    availablegradesmodel.cpp
    data.cpp
    main.cpp
    )

qt5_add_resources(RESOURCES resources.qrc)

add_executable(climbinggrades ${climbinggrades_SRCS} ${RESOURCES})
target_link_libraries(climbinggrades Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Svg Qt5::QuickControls2 KF5::ConfigCore)

install(TARGETS climbinggrades ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

#FIXME:hack for the icon on android
install(FILES climbinggrades.svg DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/kirigami/icons)

#include(KF5KirigamiMacros.cmake)
kirigami_package_breeze_icons(ICONS documentinfo view-refresh edit-clear games-highscores)
