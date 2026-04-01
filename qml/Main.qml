import QtQuick
import QtQuick.Controls

import "graphics"
import "physics"
import "player"
import "ui"

ApplicationWindow {
    id: appWindow

    width: 1280
    height: 720

    visibility: Window.FullScreen
    visible: true

    title: "FPS Game"

    LoadingScreen {
        anchors.fill: parent

        onLoadingFinished: scene.visible = true
    }

    Scene {
        id: scene

        player: player
        visible: false

        anchors.fill: parent
    }

    Rectangle {
        anchors.centerIn: parent

        width: 4
        height: 4

        color: "green"
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
    }
}
