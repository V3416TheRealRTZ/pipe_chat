import QtQuick 2.7
import Box2D 2.0

Rectangle {
    property var self: null
    property alias text: textMetrics.text
    property alias density: messageBodyBox.density
    property alias restitution: messageBodyBox.restitution
    property alias friction: messageBodyBox.friction
    property alias bodyType: messageBody.bodyType

    id: messageBox
    width: textMetrics.width
    height: textMetrics.height
    color: "white"
    border.color: "black"

    Body {
        id: messageBody
        target: messageBox
        bodyType: Body.Dynamic
        fixtures: [
            Box {
                id: messageBodyBox
                width: messageBox.width
                height: messageBox.height
                density: 0.7
                restitution: 0.3
                friction: 0.7
            }
        ]
    }

    TextMetrics {
        id: textMetrics
        font.family: "Arial"
        font.pointSize: 14
        elide: Text.ElideRight
        elideWidth: physicsScene.width - leftWall.width - rightWall.width
        text: "Hello World"
    }

    Text {
        id: textField
        text: parent.text
        font: textMetrics.font
    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onPressed: {
            mouse.accepted = false
            physicsScene.pressedBox = messageBox
            physicsScene.pressedBody = messageBody
            physicsScene.pressedBodyBox = messageBodyBox
            physicsScene.pressedMessageBox = self
        }
    }
}
