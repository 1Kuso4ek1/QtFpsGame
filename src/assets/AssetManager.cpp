#include "AssetManager.hpp"

#include <QImage>
#include <QtConcurrentRun>
#include <QFutureWatcher>
#include <QQmlEngine>

AssetManager::AssetManager(QObject* parent)
    : QObject(parent)
{
    m_threadPool.setMaxThreadCount(6);
    connect(this, &AssetManager::assetLoaded,
            this, [this](const auto& path)
            {
                (void)path;
                m_completedTasks++;
                emit progressChanged();

                if (m_completedTasks == m_totalTasks) {
                    emit loadingFinished();
                }
            });
}

AssetManager::~AssetManager()
{
    qDeleteAll(m_textures);
}

qreal AssetManager::progress() const
{
    if (m_totalTasks == 0) {
        return 1.0f;
    }
    return static_cast<qreal>(m_completedTasks) / static_cast<qreal>(m_totalTasks);
}

Texture* AssetManager::getTexture(const QString& path)
{
    if (m_textures.contains(path)) {
        return m_textures.value(path);
    }

    auto texture = new Texture();
    m_textures.insert(path, texture);

    m_totalTasks++;
    emit progressChanged();

    auto watcher = new QFutureWatcher<QImage>(this);
    connect(watcher, &QFutureWatcher<QImage>::finished,
            this, [this, path, watcher, texture]
            {
                if (const auto img = watcher->result();
                    !img.isNull()) {
                    texture->loadFromImage(img);
                } else {
                    qWarning() << "Failed to load:" << path;
                }

                emit assetLoaded(path);
                watcher->deleteLater();
            });

    const auto future = QtConcurrent::run([path] { return QImage(QUrl(path).toLocalFile()); });
    watcher->setFuture(future);

    QQmlEngine::setObjectOwnership(texture, QQmlEngine::CppOwnership);

    return texture;
}
