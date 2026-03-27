import QtQuick
import QtQuick.Controls

import "graphics"
import "physics"
import "player"

ApplicationWindow {
    id: appWindow

    width: 1280
    height: 720

    visibility: Window.FullScreen
    visible: true

    title: "FPS Game"

    LoadingScreen {
        anchors.fill: parent
    }

    Scene {
        id: scene

        player: player

        anchors.fill: parent
    }

    Player {
        id: player

        mouseArea: mouseArea
        appWindow: appWindow
        onGround: scene.character.onGround
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        propagateComposedEvents: true
        acceptedButtons: Qt.NoButton
    }
}
