import QtQuick 2.7
import Box2D 2.0

Item {
    id: wall
    property alias categories: wallBody.categories
    property alias collidesWith: wallBody.collidesWith

    BoxBody {
        id: wallBody
        target: wall
        world: physicsWorld
        bodyType: Body.Static

        width: wall.width
        height: wall.height

        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3
    }

    Rectangle {
        anchors.fill: parent
        color: "brown"
    }
}
