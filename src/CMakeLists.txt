
set(climbinggrades_SRCS
    data.cpp
    main.cpp
    )

qt5_add_resources(RESOURCES resources.qrc)

add_executable(climbinggrades ${climbinggrades_SRCS} ${RESOURCES})
target_link_libraries(climbinggrades Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Svg)

install(TARGETS climbinggrades ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

#include(KF5KirigamiMacros.cmake)
kirigami_package_breeze_icons(ICONS documentinfo view-refresh)
