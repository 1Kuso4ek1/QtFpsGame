import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: default_OBJ_material
        objectName: "Default_OBJ"
        cullMode: Material.NoCulling
        baseColorMap: Texture {
            id: baseColor
            textureData: AssetManager.getTexture("file:resources/textures/map/map_color.jpg")
            generateMipmaps: true
        }
        normalMap: Texture {
            id: normalMap
            textureData: AssetManager.getTexture("file:resources/textures/map/map_normal.jpg")
            generateMipmaps: true
        }
        metalnessMap: Texture {
            id: metalnessMap
            textureData: AssetManager.getTexture("file:resources/textures/map/map_metalness.jpg")
            generateMipmaps: true
        }
        roughnessMap: Texture {
            id: roughnessMap
            textureData: AssetManager.getTexture("file:resources/textures/map/map_roughness.jpg")
            generateMipmaps: true
        }
    }

    // Nodes:
    Node {
        id: map_obj
        objectName: "map.obj"
        Model {
            id: town_Plane_001
            objectName: "Town_Plane.001"
            source: "file:resources/meshes/town_Plane_001_mesh.mesh"
            materials: [
                default_OBJ_material,
                default_OBJ_material
            ]
        }
    }

    // Animations:
}
