#pragma once
#include <QThreadPool>
#include <QtQml/qqmlregistration.h>

#include "texture/Texture.hpp"

class AssetManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
public:
    explicit AssetManager(QObject* parent = nullptr);
    ~AssetManager() override;

    qreal progress() const;

    Q_INVOKABLE Texture* getTexture(const QString& path);

signals:
    void progressChanged();
    void assetLoaded(const QString& path);
    void loadingFinished();

private:
    size_t m_totalTasks{}, m_completedTasks{};

    QHash<QString, Texture*> m_textures;
    QThreadPool m_threadPool;
};
