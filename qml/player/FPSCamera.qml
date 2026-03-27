import QtQuick
import QtQuick3D

PerspectiveCamera {
    id: perspectiveCamera

    fieldOfView: 90
    clipFar: 10000.0
    clipNear: 0.01
    frustumCullingEnabled: true
}
