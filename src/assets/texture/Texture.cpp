#include "Texture.hpp"

#include <QImage>

void Texture::loadFromImage(const QImage& image)
{
    const auto converted = image.convertToFormat(QImage::Format_RGBA8888).flipped();
    const auto imageSize = converted.size();
    const bool hasAlpha = converted.hasAlphaChannel();

    m_data.reserve(converted.sizeInBytes());
    m_data = {
        reinterpret_cast<const char*>(converted.constBits()),
        converted.sizeInBytes()
    };

    setFormat(RGBA8);
    setSize(imageSize);
    setHasTransparency(hasAlpha);
    setTextureData(m_data);

    update();
}
