#pragma once
#include <QQuick3DTextureData>

class Texture : public QQuick3DTextureData
{
    Q_OBJECT
public:
    void loadFromImage(const QImage& image);

private:
    QByteArray m_data{};
};
