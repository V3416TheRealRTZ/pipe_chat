import QtQuick 2.7
import Box2D 2.0
import QtQuick.Controls 2.1

Rectangle {
    property alias text: textField.text
    property alias body: messageBody

    readonly property real maxHeight: 100
    readonly property real maxWidth: 300

    id: messageBox
    width: textField.contentWidth + textField.rightPadding + textField.leftPadding
    height: textField.contentHeight + textField.topPadding + textField.bottomPadding
    color: "white"
    border.color: "black"

    function release() {
        messageBody.fixedRotation = false
        messageBody.active = true
        messageBodyBox.categories = Box.Category1
        //tooltip.visible = false
    }

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
                categories: Box.Category1
                collidesWith: Box.Category1 | Box.Category2 | Box.Category3
            }
        ]
    }

    Text {
        id: textField
        font.family: "Arial"
        font.pointSize: 12
        elide: Text.ElideRight
        width: implicitWidth > maxWidth ? maxWidth : undefined
        height: implicitHeight > maxHeight ? maxHeight : undefined
        wrapMode: Text.Wrap
        text: "Hello World"
    }

//    ToolTip {
//        id: tooltip
//        visible: false
//        text: "Hello World"
//    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        hoverEnabled: true
        onContainsMouseChanged: {
            if(containsMouse && textField.truncated) {
                ToolTip.visible = true
                ToolTip.text = textField.text
            }
        }

        onPressed: {
            mouse.accepted = false
            physicsScene.pressedMessageBox = messageBox
            physicsScene.pressedBody = messageBody
            messageBody.fixedRotation = true
            messageBox.rotation = 0
            messageBodyBox.categories = Box.Category3
            //tooltip.visible = text.truncated
        }
    }
}
