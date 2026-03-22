import QtQuick
import QtQuick3D
import QtQuick3D.Physics

import "../player"
import "../objects"
import "../objects/materials"

View3D {
    id: view3d

    required property var cameraRotation
    required property var movement

    property alias character: character

    camera: fpsCamera
    environment: Environment {}

    Physics {
        id: physics
        scene: view3d.scene
    }

    DirectionalLight {
        eulerRotation.x: -45
        eulerRotation.y: -45

        ambientColor: "#373737"

        castsShadow: true
        softShadowQuality: Light.Hard
        shadowMapQuality: Light.ShadowMapQualityUltra
        shadowBias: 5
    }

    Floor {}

    DynamicRigidBody {
        position: Qt.vector3d(0, 300, 200)
        collisionShapes: BoxShape {}

        Model {
            source: "#Cube"
            materials: [PrincipledMaterial {
                baseColor: "#0000ff"; roughness: 0.7; metalness: 0.3
            }]
        }
    }

    DynamicRigidBody {
        position: Qt.vector3d(200, 200, 500)
        collisionShapes: SphereShape {}
        Model {
            source: "#Sphere"
            materials: [PrincipledMaterial {
                baseColor: "#ffffff"; emissiveFactor: Qt.vector3d(8.0, 8.0, 8.0)
            }]
        }
    }

    DynamicRigidBody {
        position: Qt.vector3d(0, 700, 200)
        collisionShapes: BoxShape { extents: Qt.vector3d(500, 100, 20) }
        AK47 {}
    }

    FPSCharacterController {
        id: character

        position: Qt.vector3d(0, 200, 200)
        eulerRotation.y: fpsCamera.eulerRotation.y

        gravity: physics.gravity
        movement: view3d.movement

        FPSCamera {
            id: fpsCamera
            eulerRotation: view3d.cameraRotation

            AK47 {
                position: Qt.vector3d(20, -30, -40)
                eulerRotation.x: -90
                eulerRotation.y: 120
                scale: Qt.vector3d(0.4, 0.4, 0.4)
            }
        }
    }
}
