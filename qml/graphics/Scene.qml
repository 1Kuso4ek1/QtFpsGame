import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import QtQuick3D.SpatialAudio
import QtMultimedia

import "../player"
import "../objects"
import "../objects/materials"

View3D {
    id: view3d

    required property var player

    property alias character: character

    camera: fpsCamera
    environment: Environment {}

    AudioEngine {
        outputMode: AudioEngine.Headphone
    }

    Physics {
        id: physics
        scene: view3d.scene
        running: view3d.visible
    }

    DirectionalLight {
        eulerRotation.x: -45
        eulerRotation.y: -45

        brightness: 1
        ambientColor: "black"

        castsShadow: true
        shadowFactor: 100
        softShadowQuality: Light.PCF16
        use32BitShadowmap: true
        shadowMapFar: 10000
        shadowMapQuality: Light.ShadowMapQualityUltra
        shadowBias: 5
        csmNumSplits: 3
    }

    StaticRigidBody {
        scale: Qt.vector3d(40, 40, 40)
        collisionShapes: TriangleMeshShape {
            source: "file:resources/meshes/town_Plane_001_mesh.mesh"
        }

        Map {
            SpatialSound {
                position: Qt.vector3d(0, 50, 0)
                source: "file:resources/audio/music/test.mp3"
                distanceModel: SpatialSound.Linear
                volume: 0.1
            }

            AudioRoom {
                dimensions: Qt.vector3d(7000, 1000, 6000)
                backMaterial: AudioRoom.Material.Transparent
                frontMaterial: AudioRoom.Material.Metal
                leftMaterial: AudioRoom.Material.Metal
                rightMaterial: AudioRoom.Material.Metal
                ceilingMaterial: AudioRoom.Material.Transparent
                floorMaterial: AudioRoom.Material.ConcreteBlockCoarse
                reverbGain: 0.3
                reflectionGain: 0.3
                reverbBrightness: 0.3
            }
        }
    }

    Text {
        text: `position: ${character.position}`
        font.pixelSize: 24
        color: "white"
    }

    Rectangle {
        id: animation

        width: 512
        height: 512

        visible: false

        MediaPlayer {
            source: "file:resources/textures/animated/ishowspeed-ishowspeed-fortnite.mp4"
            loops: MediaPlayer.Infinite
            autoPlay: true
            videoOutput: videoOutput
        }

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
        }
    }

    Repeater3D {
        model: 100
        delegate: DynamicRigidBody {
            position: Qt.vector3d(0, 300 + index * 100, 200)
            collisionShapes: BoxShape {}

            function playSound() {
                sound.stop()
                sound.play()
            }

            SpatialSound {
                id: sound
                source: "file:resources/audio/sounds/ishowspeed-blackk.mp3"
                autoPlay: false
                distanceCutoff: 2000
            }

            Model {
                source: "#Cube"
                pickable: true
                materials: [PrincipledMaterial {
                    id: basicMaterial
                    /*baseColor: "#0000ff";*/ roughness: 0.7; metalness: 0.3
                    baseColorMap: Texture {
                        sourceItem: animation
                    }
                }]
            }
        }
    }

    DynamicRigidBody {
        position: Qt.vector3d(200, 200, 500)
        collisionShapes: SphereShape {}
        Model {
            source: "#Sphere"
            pickable: true
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

        property var footsteps: []

        Component.onCompleted: {
            for (let i = 1; i <= 4; i++) {
                footsteps.push(
                    Qt.createQmlObject(`
                        import QtQuick3D.SpatialAudio

                        SpatialSound {
                            source: "file:resources/audio/sounds/footsteps/footstep${i}.ogg"
                            autoPlay: false
                        }
                    `, character)
                )
            }
        }

        Timer {
            running: character.movement.length() > 0.0 && character.onGround
            repeat: true
            triggeredOnStart: true
            interval: view3d.player.running ? 350 : 550
            onTriggered: {
                const index = Math.floor(Math.random() * 4)
                character.footsteps[index].play()
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

            property real recoilZ: 0.0

            property bool wasGrounded: true

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
                        const bobMultiplier = isRunning ? 1.8 : 1.0
                        fpsCamera.weaponBobX = Math.sin(fpsCamera.bobState * fpsCamera.bobFrequency) * 0.08 * bobMultiplier
                        fpsCamera.weaponBobY = Math.cos(fpsCamera.bobState * fpsCamera.bobFrequency * 2) * 0.06 * bobMultiplier
                        fpsCamera.weaponBobRotate = Math.sin(fpsCamera.bobState * fpsCamera.bobFrequency) * 0.3 * bobMultiplier
                    } else {
                        fpsCamera.weaponBobX += (0 - fpsCamera.weaponBobX) * 0.15
                        fpsCamera.weaponBobY += (0 - fpsCamera.weaponBobY) * 0.15
                        fpsCamera.weaponBobRotate += (0 - fpsCamera.weaponBobRotate) * 0.15
                    }

                    fpsCamera.recoilZ += (0 - fpsCamera.recoilZ) * 0.15
                }
            }

            AudioListener {}

            AK47 {
                id: weapon
                position: Qt.vector3d(
                    20 + fpsCamera.weaponBobX * 10,
                    -35 + fpsCamera.weaponBobY * 10 + fpsCamera.weaponFallOffsetY,
                    -40 + fpsCamera.recoilZ
                )
                eulerRotation: Qt.vector3d(
                    -fpsCamera.swayX * 2,
                    90 + fpsCamera.weaponBobRotate * 4 - fpsCamera.swayRotate * 2,
                    fpsCamera.weaponBobRotate * 2 - fpsCamera.swayY * 3
                )
                scale: Qt.vector3d(0.4, 0.4, 0.4)

                Node {
                    id: muzzleFlashNode
                    position: Qt.vector3d(210, 60, 0)
                    visible: false

                    function fire() {
                        let randomScale = 0.7 + Math.random() * 0.2
                        flashModel.eulerRotation.x = Math.random() * 360
                        flashModel.scale = Qt.vector3d(randomScale * 1.5, randomScale, randomScale)
                        muzzleFlashNode.visible = true

                        hideTimer.restart()
                    }

                    Timer {
                        id: hideTimer
                        interval: 30
                        repeat: false
                        onTriggered: muzzleFlashNode.visible = false
                    }
                    Model {
                        id: flashModel
                        source: "#Sphere"
                        materials: [ PrincipledMaterial {
                            baseColor: "#ffff88"
                            emissiveFactor: Qt.vector3d(16.0, 8.0, 0.0)
                            // baseColorMap: Texture { source: "file:resources/textures/muzzle.png" }
                            // alphaMode: PrincipledMaterial.Blend
                        }]
                    }

                    PointLight {
                        color: "#ffa700"
                        brightness: 10.0
                        quadraticFade: 2.0
                        castsShadow: false
                    }
                }

                SpatialSound {
                    id: shot
                    source: "file:resources/audio/sounds/ak47/shot.mp3"
                    position: Qt.vector3d(200, 50, 0)
                    autoPlay: false
                }

                Timer {
                    running: view3d.player.shooting
                    repeat: true
                    triggeredOnStart: true
                    interval: 130
                    onTriggered: {
                        shot.stop()
                        shot.play()

                        fpsCamera.recoilZ = 22.0
                        muzzleFlashNode.fire()

                        let pickResult = view3d.pick(view3d.width / 2, view3d.height / 2)

                        if (pickResult && pickResult.objectHit) {
                            let hitModel = pickResult.objectHit
                            let hitBody = hitModel.parent

                            if (hitBody) {
                                let hitPos = pickResult.scenePosition
                                let camPos = fpsCamera.scenePosition

                                let dirX = hitPos.x - camPos.x
                                let dirY = hitPos.y - camPos.y
                                let dirZ = hitPos.z - camPos.z

                                let length = Math.sqrt(dirX*dirX + dirY*dirY + dirZ*dirZ)
                                dirX /= length; dirY /= length; dirZ /= length;

                                let impactForce = 1500000

                                let impulse = Qt.vector3d(dirX * impactForce, dirY * impactForce, dirZ * impactForce)
                                hitBody.applyCentralImpulse(impulse)
                                hitBody.playSound()
                            }
                        }
                    }
                }
            }
        }
    }
}
