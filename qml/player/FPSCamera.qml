import QtQuick
import QtQuick3D

PerspectiveCamera {
    id: perspectiveCamera

    position: Qt.vector3d(0, 55, 0)

    fieldOfView: 90
    clipNear: 0.01
    frustumCullingEnabled: true
}
