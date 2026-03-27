import QtQuick
import QtQuick3D

Texture {
    id: root

    property string imageSource: ""
    property real progress: image.progress
    property int status: image.status

    generateMipmaps: true
    magFilter: Texture.Linear
    minFilter: Texture.Linear
    mipFilter: Texture.Linear

    sourceItem: Image {
        id: image
        source: root.imageSource
        asynchronous: true
        mipmap: true
        visible: false
    }
}
