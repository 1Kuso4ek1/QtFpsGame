#include "PlayerController.hpp"
#include "InputHandler.hpp"

PlayerController::PlayerController(QObject* parent)
    : QObject(parent)
{}

void PlayerController::setInputHandler(InputHandler* inputHandler)
{
    if (!m_inputHandler) {
        m_inputHandler = inputHandler;

        connect(m_inputHandler, &InputHandler::keyPressed,
                this, [this](const int key)
                {
                    const auto flag = keyToFlag(static_cast<Qt::Key>(key));
                    m_inputState.setFlag(flag, true);
                    if (flag == Sprint) {
                        emit runningChanged();
                    }

                    emit inputChanged();
                });
        connect(m_inputHandler, &InputHandler::keyReleased,
                this, [this](const int key)
                {
                    const auto flag = keyToFlag(static_cast<Qt::Key>(key));
                    m_inputState.setFlag(flag, false);
                    if (flag == Sprint) {
                        emit runningChanged();
                    }

                    emit inputChanged();
                });
        connect(m_inputHandler, &InputHandler::mouseMoved,
                this, [this](const qreal dx, const qreal dy)
                {
                    m_cameraRotation.setY(m_cameraRotation.y() - static_cast<float>(dx));
                    m_cameraRotation.setX(m_cameraRotation.x() - static_cast<float>(dy));
                    m_cameraRotation.setX(std::max(-89.0f, std::min(89.0f, m_cameraRotation.x())));

                    emit cameraRotationChanged();
                    emit inputChanged();
                });
    }
}

QVector3D PlayerController::movement()
{
    const auto speed = m_speed * (m_inputState.testFlag(Sprint) ? m_sprintMultiplier : 1.0f);
    const auto radYaw = m_cameraRotation.y() * M_PIf / 180.0f;

    const auto forwardX = std::sin(radYaw);
    const auto forwardZ = std::cos(radYaw);
    const auto rightX = std::cos(radYaw);
    const auto rightZ = -std::sin(radYaw);

    auto dx{0.0f}, dy{0.0f}, dz{0.0f};

    if (m_inputState.testFlag(Forward)) { dx -= forwardX; dz -= forwardZ; }
    if (m_inputState.testFlag(Backward)) { dx += forwardX; dz += forwardZ; }
    if (m_inputState.testFlag(Right)) { dx += rightX; dz += rightZ; }
    if (m_inputState.testFlag(Left)) { dx -= rightX; dz -= rightZ; }

    if (m_onGround) {
        if (m_inputState.testFlag(Jump)) {
            dy = m_jumpForce;
        }
        m_jumpVelocity = 0;
    } else {
        m_jumpVelocity = dy;
    }

    if (const bool isMoving = dx != 0.0f && dy != 0.0f && dz != 0.0f;
        m_moving != isMoving) {
        m_moving = isMoving;
        emit movingChanged();
    }

    QVector3D vec{ dx, 0, dz };
    vec.normalize();
    vec *= speed;
    vec.setY(dy);

    return vec;
}

PlayerController::InputState PlayerController::keyToFlag(const Qt::Key key)
{
    switch (key) {
    case Qt::Key_W: return Forward;
    case Qt::Key_S: return Backward;
    case Qt::Key_D: return Right;
    case Qt::Key_A: return Left;
    case Qt::Key_Space: return Jump;
    case Qt::Key_Shift: return Sprint;
    default: return None;
    }
}
