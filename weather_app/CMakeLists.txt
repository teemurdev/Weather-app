cmake_minimum_required(VERSION 3.16)

project(weather_app VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(weather_app
    main.cpp
    datafetcher.h
    datafetcher.cpp
)

qt_add_qml_module(weather_app
    URI weather_app
    VERSION 1.0
    QML_FILES
        Main.qml
        ForecastView.qml
        CurrentView.qml
        Next12hView.qml
    RESOURCES resources.qrc
)

file(GLOB SYMBOL_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} resources/symbols/dark/*.svg resources/symbols/light/*.svg)
file(GLOB BACKGROUND_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} resources/backgrounds/*.jpg)

qt_add_resources(weather_app "symbols"
    PREFIX "/"
    FILES ${SYMBOL_FILES} ${BACKGROUND_FILES}
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(weather_app PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appweather_app
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(weather_app
    PRIVATE Qt6::Quick Qt6::Core
)

include(GNUInstallDirs)
install(TARGETS weather_app
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
