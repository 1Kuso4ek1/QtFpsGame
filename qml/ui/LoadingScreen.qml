import QtQuick
import QtQuick.Controls

import FpsGame

Rectangle {
    id: loadingScreen

    color: "#0a0a0c"
    z: 100

    Behavior on opacity {
        NumberAnimation {
            duration: 2000
            easing.type: Easing.InOutQuad
        }
    }

    Connections {
        target: AssetManager

        function onLoadingFinished() {
            loadingScreen.opacity = 0.0
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 30

        Text {
            text: "LOADING"

            color: "#ffffff"
            font.pixelSize: 48

            anchors.horizontalCenter: parent.horizontalCenter
        }

        ProgressBar {
            id: progressBar

            width: 600
            height: 12

            from: 0.0
            to: 1.0
            value: AssetManager.progress

            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
