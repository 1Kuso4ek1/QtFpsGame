import QtQuick
import QtQuick3D
import QtQuick3D.Physics

import "../player"
import "../objects"
import "../objects/materials"

View3D {
    id: view3d

    required property var player

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
        movement: view3d.player.movement

        property vector3d previousPosition: position
        property real verticalVelocity: 0

        FrameAnimation {
            running: true
            onTriggered: {
                const dt = 0.016
                const deltaY = character.position.y - character.previousPosition.y
                character.verticalVelocity = deltaY / dt
                character.previousPosition = character.position
            }
        }

        FPSCamera {
            id: fpsCamera

            property vector3d basePosition: Qt.vector3d(0, 55, 0)

            property real bobAmplitudeY: 4.0
            property real bobAmplitudeX: 2.2
            property real bobFrequency: 1.8
            property real bobState: 0.0

            property real weaponBobX: 0.0
            property real weaponBobY: 0.0
            property real weaponBobRotate: 0.0

            property real weaponFallOffsetY: 0.0

            property real swayX: 0.0
            property real swayY: 0.0
            property real swayRotate: 0.0

            property real previousYaw: 0.0
            property real previousPitch: 0.0

            property real swaySmoothing: 0.08
            property real swayAmount: 0.15
            property real swayReturnSpeed: 0.1

            Behavior on weaponFallOffsetY {
                NumberAnimation {
                    duration: character.verticalVelocity > 50 ? 100 : 800
                    easing.type: character.onGround ? Easing.OutElastic : Easing.Linear
                }
            }

            Behavior on bobAmplitudeY {
                NumberAnimation {
                    duration: 600
                    easing.type: Easing.InOutQuad
                }
            }

            position: Qt.vector3d(
                basePosition.x + bobAmplitudeX * Math.sin(bobState * bobFrequency * 0.5) * 1.5,
                basePosition.y + bobAmplitudeY * Math.sin(bobState * bobFrequency) * 1.5,
                basePosition.z
            )

            eulerRotation: Qt.vector3d(
                view3d.player.cameraRotation.x,
                view3d.player.cameraRotation.y,
                Math.cos(bobState * bobFrequency) * 0.15 * (view3d.player.running ? 1.5 : 1.0)
            )

            FrameAnimation {
                running: true
                onTriggered: {
                    const isMoving = view3d.player.moving
                    const isRunning = view3d.player.running
                    const isGrounded = view3d.player.onGround
                    const verticalSpeed = character.verticalVelocity

                    const currentYaw = view3d.player.cameraRotation.y
                    const currentPitch = view3d.player.cameraRotation.x

                    const deltaYaw = currentYaw - fpsCamera.previousYaw
                    const deltaPitch = currentPitch - fpsCamera.previousPitch

                    fpsCamera.swayX += deltaYaw * fpsCamera.swayAmount
                    fpsCamera.swayY += deltaPitch * fpsCamera.swayAmount
                    fpsCamera.swayRotate += deltaYaw * fpsCamera.swayAmount * 0.5

                    fpsCamera.swayX += (0 - fpsCamera.swayX) * fpsCamera.swayReturnSpeed
                    fpsCamera.swayY += (0 - fpsCamera.swayY) * fpsCamera.swayReturnSpeed
                    fpsCamera.swayRotate += (0 - fpsCamera.swayRotate) * fpsCamera.swayReturnSpeed

                    fpsCamera.previousYaw = currentYaw
                    fpsCamera.previousPitch = currentPitch

                    if (isGrounded && isMoving) {
                        fpsCamera.bobState += isRunning ? 0.08 : 0.05
                    }

                    if (!isGrounded) {
                        if (verticalSpeed > 0) {
                            fpsCamera.weaponFallOffsetY = -8
                        } else if (verticalSpeed < 50) {
                            fpsCamera.weaponFallOffsetY = 15
                        }
                    } else {
                        fpsCamera.weaponFallOffsetY = 0
                    }

                    fpsCamera.wasGrounded = isGrounded

                    if (isMoving && isGrounded) {
                        const bobMult = isRunning ? 1.8 : 1.0
                        fpsCamera.weaponBobX = Math.sin(fpsCamera.bobState * fpsCamera.bobFrequency) * 0.08 * bobMult
                        fpsCamera.weaponBobY = Math.cos(fpsCamera.bobState * fpsCamera.bobFrequency * 2) * 0.06 * bobMult
                        fpsCamera.weaponBobRotate = Math.sin(fpsCamera.bobState * fpsCamera.bobFrequency) * 0.3 * bobMult
                    } else {
                        fpsCamera.weaponBobX += (0 - fpsCamera.weaponBobX) * 0.15
                        fpsCamera.weaponBobY += (0 - fpsCamera.weaponBobY) * 0.15
                        fpsCamera.weaponBobRotate += (0 - fpsCamera.weaponBobRotate) * 0.15
                    }
                }
            }

            property bool wasGrounded: true

            AK47 {
                position: Qt.vector3d(
                    20 + fpsCamera.weaponBobX * 10,
                    -35 + fpsCamera.weaponBobY * 10 + fpsCamera.weaponFallOffsetY,
                    -40
                )
                eulerRotation: Qt.vector3d(
                    -fpsCamera.swayX * 2,
                    90 + fpsCamera.weaponBobRotate * 4 - fpsCamera.swayRotate * 2,
                    fpsCamera.weaponBobRotate * 2 - fpsCamera.swayY * 3
                )
                scale: Qt.vector3d(0.4, 0.4, 0.4)
            }
        }
    }
}
