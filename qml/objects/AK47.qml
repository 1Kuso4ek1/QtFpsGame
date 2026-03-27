import QtQuick
import QtQuick3D

import FpsGame

Node {
    id: node

    PrincipledMaterial {
        id: wood_ak_47_material
        objectName: "Wood_ak-47"
        baseColorMap: Texture {
            id: woodColor
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Wood_ak-47_Base_Color.png")
            generateMipmaps: true
        }
        normalMap: Texture {
            id: woodNormal
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Wood_ak-47_Normal_OpenGL.png")
            generateMipmaps: true
        }
        roughnessMap: Texture {
            id: woodRoughness
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Wood_ak-47_Roughness.png")
            generateMipmaps: true
        }
        metalnessMap: Texture {
            id: woodMetalness
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Wood_ak-47_Metallic.png")
            generateMipmaps: true
        }
    }
    PrincipledMaterial {
        id: metall_ak_47_material
        objectName: "Metall_ak-47"
        baseColorMap: Texture {
            id: metalColor
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Metall_ak-47_Base_Color.png")
            generateMipmaps: true
        }
        normalMap: Texture {
            id: metalNormal
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Metall_ak-47_Normal_OpenGL.png")
            generateMipmaps: true
        }
        roughnessMap: Texture {
            id: metalRoughness
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Metall_ak-47_Roughness.png")
            generateMipmaps: true
        }
        metalnessMap: Texture {
            id: metalMetalness
            textureData: AssetManager.getTexture("file:resources/textures/ak47/Metall_ak-47_Metallic.png")
            generateMipmaps: true
        }
    }

    // Nodes:
    Node {
        id: rootNode
        objectName: "RootNode"
        Model {
            id: ak_47
            objectName: "Ak-47"
            position: Qt.vector3d(-90.682, -4.499, -3.04796e-07)
            rotation: Qt.quaternion(0.707107, -0.707107, 0, 0)
            scale: Qt.vector3d(100, 100, 100)
            source: "file:resources/meshes/ak_47_mesh.mesh"
            materials: [
                wood_ak_47_material,
                metall_ak_47_material
            ]
        }
    }

    // Animations:
}
