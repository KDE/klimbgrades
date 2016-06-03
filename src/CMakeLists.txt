
set(climbinggrades_SRCS
    data.cpp
    main.cpp
    )

qt5_add_resources(RESOURCES resources.qrc)

add_executable(climbinggrades ${climbinggrades_SRCS} ${RESOURCES})
target_link_libraries(climbinggrades Qt5::Core  Qt5::Qml Qt5::Quick Qt5::Svg)

install(TARGETS climbinggrades ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})

#include(${CMAKE_SOURCE_DIR}/KF5KirigamiMacros.cmake)
#kirigami_package_breeze_icons(ICONS applications-graphics view-list-icons folder-sync view-list-details configure document-edit dialog-cancel document-decrypt mail-reply-sender bookmarks folder)
