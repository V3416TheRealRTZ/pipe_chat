import QtQuick 2.7
import Box2D 2.0

Item {
    id: wall

    BoxBody {
        target: wall
        world: physicsWorld
        bodyType: Body.Static

        width: wall.width
        height: wall.height
    }

    Rectangle {
        anchors.fill: parent
        color: "brown"
    }
}
