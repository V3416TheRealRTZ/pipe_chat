import QtQuick 2.7
import Box2D 2.0

Rectangle {
    id: wall
    property alias xb: wallBody.x
    property alias yb: wallBody.y
    property alias categories: wallBody.categories
    property alias collidesWith: wallBody.collidesWith
    property alias target: wallBody.target

    signal beginContact(Fixture other)
    signal endContact(Fixture other)

    color: "brown"

    BoxBody {
        id: wallBody
        target: wall
        world: physicsWorld
        bodyType: Body.Static

        width: wall.width
        height: wall.height

        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3

        onBeginContact: wall.beginContact(other)
        onEndContact: wall.endContact(other)
    }
}
