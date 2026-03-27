import QtQuick
import QtQuick3D

PrincipledMaterial {
    readonly property var textures: [
        colorTexture,
        normalTexture,
        roughnessTexture,
        metalnessTexture,
        occlusionTexture
    ]

    baseColorMap: Texture {
        id: colorTexture
        textureData: AssetManager.getTexture("file:resources/textures/diamondPlate/DiamondPlate008C_2K-JPG_Color.jpg")
        scaleU: 8
        scaleV: 8
        generateMipmaps: true
    }
    normalMap: Texture {
        id: normalTexture
        textureData: AssetManager.getTexture("file:resources/textures/diamondPlate/DiamondPlate008C_2K-JPG_NormalGL.jpg")
        scaleU: 8
        scaleV: 8
        generateMipmaps: true
    }
    roughnessMap: Texture {
        id: roughnessTexture
        textureData: AssetManager.getTexture("file:resources/textures/diamondPlate/DiamondPlate008C_2K-JPG_Roughness.jpg")
        scaleU: 8
        scaleV: 8
        generateMipmaps: true
    }
    metalnessMap: Texture {
        id: metalnessTexture
        textureData: AssetManager.getTexture("file:resources/textures/diamondPlate/DiamondPlate008C_2K-JPG_Metalness.jpg")
        scaleU: 8
        scaleV: 8
        generateMipmaps: true
    }
    occlusionMap: Texture {
        id: occlusionTexture
        textureData: AssetManager.getTexture("file:resources/textures/diamondPlate/DiamondPlate008C_2K-JPG_AmbientOcclusion.jpg")
        scaleU: 8
        scaleV: 8
        generateMipmaps: true
    }
}
