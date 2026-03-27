import QtQuick3D
import QtQuick3D.Helpers

ExtendedSceneEnvironment {
    tonemapMode: SceneEnvironment.TonemapModeAces
    aoEnabled: true
    aoDither: true
    aoDistance: 100
    aoStrength: 100
    aoSoftness: 50
    aoSampleRate: 4
    // lensFlareEnabled: true
    // lensFlareBloomBias: 7.9
    // lensFlareBloomScale: 1
    // lensFlareApplyDirtTexture: true
    // lensFlareApplyStarburstTexture: true
    // lensFlareBlurAmount: 20
    // lensFlareDistortion: 4
    ditheringEnabled: true
    // depthOfFieldEnabled: true
    // depthOfFieldFocusDistance: 400
    // depthOfFieldFocusRange: 200
    // depthOfFieldBlurAmount: 4
    /*fog: Fog {
        density: 0.5
        depthEnabled: true
        enabled: true
        transmitCurve: 2.0
        transmitEnabled: true
    }*/
    vignetteEnabled: true
    vignetteRadius: 0.1
    specularAAEnabled: true
    fxaaEnabled: true
    glowEnabled: true
    glowQualityHigh: true
    glowUseBicubicUpscale: true
    glowStrength: 1.0
    glowIntensity: 0.1
    glowBloom: 1.0
    glowHDRMinimumValue: 4.0
    glowHDRScale: 4.0
    glowBlendMode: ExtendedSceneEnvironment.GlowBlendMode.Screen
    glowLevel: (ExtendedSceneEnvironment.GlowLevel.One
                | ExtendedSceneEnvironment.GlowLevel.Two
                | ExtendedSceneEnvironment.GlowLevel.Three
                | ExtendedSceneEnvironment.GlowLevel.Four
                | ExtendedSceneEnvironment.GlowLevel.Five
                | ExtendedSceneEnvironment.GlowLevel.Six
                | ExtendedSceneEnvironment.GlowLevel.Seven)
    backgroundMode: SceneEnvironment.SkyBox
    lightProbe: Texture {
        // textureData: ProceduralSkyTextureData {
        //     textureQuality: ProceduralSkyTextureData.SkyTextureQualityMedium
        //     skyEnergy: 0.3
        //     sunEnergy: 1
        // }
        source: "file:resources/textures/hdri/suburban_garden_4k.hdr"
    }
    exposure: 1.0
}
