import QtQuick 2.7
import Box2D 2.0
import QtQuick.Controls 2.1

Rectangle {
    property alias text: textField.encodedText
    property alias author: textField.author
    property alias message: textField.message
    property alias body: messageBody

    readonly property real maxHeight: 75
    readonly property real maxWidth: 300

    id: messageBox
    width: {
        var x = textField.contentWidth + textField.rightPadding + textField.leftPadding
        if (x < 300)
            return 300
        return x
    }

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
        function destroy() {
            parent.destroy()
        }

        fixtures: [
            Box {
                property alias rectangle: messageBox
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
        property string encodedText: ""
        property var author: {
            var parts = encodedText.split(";")
            return parts[0]
        }
        property string message: {
            var parts = encodedText.split(";")
            return parts[2]
        }

        id: textField
        font.family: "Arial"
        font.pointSize: 14
        elide: Text.ElideRight
        width: implicitWidth > maxWidth ? maxWidth : undefined
        height: implicitHeight > maxHeight ? maxHeight : undefined
        wrapMode: Text.Wrap
        text: {
            var words = message.split(" ")
            for(var i = 0; i < words.length; ++i)
                for(var j = 0; j < emotesModel.length; ++j)
                    if(emotesModel[j] === (words[i] + ".png")) {
                        words[i] = "<img src=\"emotes/" + words[i] + ".png\">"
                        break;
                    }

            return "<b>" + author + ":</b> " + words.join(" ")
        }
    }

    Dialog {
        id: fullMessage
        modal: true
        standardButtons: Dialog.Ok


        bottomMargin: 500
        topMargin: 500
        rightMargin: 500
        leftMargin: 500
//        topMargin: root.height / 2 - implicitHeight / 2
//        leftMargin: root.width / 2 - implicitWidth / 2
//        bottomMargin: root.height / 2 - implicitHeight / 2
//        rightMargin: root.width / 2 - implicitWidth / 2

        title: textField.author

        contentItem: Text {
            text: textField.message
            wrapMode: Text.Wrap
        }
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
//        onContainsMouseChanged: {
//            if(containsMouse && textField.truncated) {
//                ToolTip.visible = true
//                ToolTip.text = textField.text
//                ToolTip.contentItem.wrapMode = Text.WrapAnywhere
//                //ToolTip.contentWidth = 300
//                //ToolTip.width = 300
//            }
//        }

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onDoubleClicked: {
            fullMessage.open()
        }

        onPressed: {
            if(mouse.button === Qt.RightButton) {
                mouseArea.release()
                messageBox.destroy()
                return
            }
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
