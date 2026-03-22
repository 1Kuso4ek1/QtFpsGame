cmake_minimum_required(VERSION 3.16)

project(FpsGame VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Quick3D Quick3DPhysics WaylandCompositor)

qt_standard_project_setup(REQUIRES 6.10.0)

set(FPS_GAME_SOURCES
    src/main.cpp
    src/input/InputHandler.cpp
    src/input/InputHandler.hpp
    src/player/PlayerController.cpp
    src/player/PlayerController.hpp
)

set(FPS_GAME_QML
    qml/graphics/Environment.qml
    qml/graphics/Scene.qml
    qml/objects/materials/MetalMaterial.qml
    qml/objects/Floor.qml
    qml/physics/Physics.qml
    qml/player/FPSCamera.qml
    qml/player/FPSCharacterController.qml
    qml/player/Player.qml
    qml/Main.qml
)

qt_add_executable(FpsGameApp
    ${FPS_GAME_SOURCES}
)

qt_add_qml_module(FpsGameApp
    URI FpsGame
    VERSION 1.0
    QML_FILES
        ${FPS_GAME_QML}
)

add_custom_command(TARGET FpsGameApp
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_SOURCE_DIR}/resources
    ${CMAKE_BINARY_DIR}/resources
    COMMENT "Copying resources to build directory..."
)

#[[qt_add_resources(FpsGameApp
    PREFIX "/"
    FILES
)]]

set_target_properties(FpsGameApp PROPERTIES
    WIN32_EXECUTABLE TRUE
)

target_include_directories(FpsGameApp PRIVATE
    src/input
    src/player
)

target_link_libraries(FpsGameApp PRIVATE
    Qt6::Quick Qt6::Quick3D Qt6::Quick3DPhysics Qt6::WaylandCompositor
)

include(GNUInstallDirs)
install(TARGETS FpsGameApp
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
