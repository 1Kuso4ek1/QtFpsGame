import QtQuick
import QtQuick3D
import QtQuick3D.Physics

import "materials"

StaticRigidBody {
    position: Qt.vector3d(0, 0, 0)
    scale: Qt.vector3d(20, 1, 20)
    collisionShapes: BoxShape {}

    Model {
        source: "#Cube"
        materials: [ MetalMaterial { id: metalMaterial } ]
    }
}
