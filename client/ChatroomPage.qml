import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Box2D 2.0

import pipechat.messagemodel 1.0

Page {
    id: root

    property var messageBoxes: []

    Component.onCompleted: {
        client.disconnected.connect(onDisconnected)
        client.messageArrived.connect(spawnMessage)
    }

    function spawnMessage(msg) {
        var messageBoxComponent = Qt.createComponent("MessageBox.qml")
        var msgBox = messageBoxComponent.createObject(physicsScene, {"text": msg, "world": physicsWorld, "x": spawnZone.anchors.leftMargin + 2})
//        msgBox.destroy()
        messageBoxes.push(msgBox)
    }

    function onDisconnected() {
        for (var i = 0; i < messageBoxes.length; i++)
            messageBoxes[i].destroy()
        root.StackView.view.pop()
    }

    header:
        ToolBar {
            ToolButton {
                id: disconnectButton
                text: qsTr("Disconnect")
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    client.disconnectFromHost()
                }
            }
        }

    ColumnLayout {
        anchors.fill: parent

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
            Rectangle {
                property Body pressedBody: null
                property MessageBox pressedMessageBox: null

                id: physicsScene
                color: "lightgrey"

                anchors.fill: parent

                Rectangle {
                    id: spawnZone
                    anchors.left: parent.left
                    anchors.leftMargin: 305
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    anchors.bottom: parent.bottom
                    color: "transparent"
                }

                MouseArea {
                    property alias pressedBody: physicsScene.pressedBody
                    property alias pressedMessageBox: physicsScene.pressedMessageBox

                    id: mouseArea
                    anchors.fill: parent
                    propagateComposedEvents: true

                    onPressed: {
                        if (pressedBody != null) {
                            mouseJoint.maxForce = pressedBody.getMass() * 500
                            mouseJoint.target = Qt.point(mouseX, mouseY)
                            mouseJoint.bodyB = pressedBody
                        }
                    }

                    onPositionChanged: {
                        mouseJoint.target = Qt.point(mouseX, mouseY)
                    }

                    function release() {
                        if(pressedMessageBox != null)
                            pressedMessageBox.release()
                        mouseJoint.bodyB = null
                        pressedBody = null
                        pressedMessageBox = null
                    }

                    onReleased: {
                        release()
                    }
                }

                MouseJoint {
                    id: mouseJoint
                    bodyA: anchor
                    dampingRatio: 0.8
                    maxForce: 100
                }

                World { id: physicsWorld }

                Body {
                    id: anchor
                    world: physicsWorld
                }

                Wall {
                    id: topWall
                    height: 2
                    anchors {
                        top: physicsScene.top
                        left: physicsScene.left
                        right: physicsScene.right
                    }
                }

                Wall {
                    id: bottomWall
                    height: 2
                    anchors {
                        bottom: physicsScene.bottom
                        left: physicsScene.left
                        right: physicsScene.right
                    }
                }

//                Wall {
//                    id: midWall
//                    width: 2
//                    anchors {
//                        left: spawnZone.left
//                        top: physicsScene.top
//                        bottom: physicsScene.bottom
//                    }
//                    collidesWith: Box.Category1 | Box.Category2
//                }

                Wall {
                    id: leftWall
                    width: 2
                    anchors {
                        left: physicsScene.left
                        top: physicsScene.top
                        bottom: physicsScene.bottom
                    }
                }

                Wall {
                    id: rightWall
                    width: 2
                    anchors {
                        top: physicsScene.top
                        bottom: physicsScene.bottom
                        right: physicsScene.right
                    }
                }

                Pipe {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    overlayColor: "transparent"
                }

                ListView {
                    id: userList
                    z: 1000
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    verticalLayoutDirection: ListView.TopToBottom
                    spacing: 2
                    model: client.userlist
                    delegate:
                        Pipe {
                            text: modelData.username
                            overlayColor: modelData.usercolor
                        }

                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }

        Pane {
            id: pane
            Layout.fillWidth: true

            RowLayout {
                width: parent.width

                TextField {
                    id: messageField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Compose message")
                    maximumLength: 300
                }

                Button {
                    id: emotesButton
                    text: qsTr("Emotes")
                    enabled: messageField.length < messageField.maximumLength
                    onClicked: emotesPopup.open()
                }

                Popup {
                        id: emotesPopup
                        x: emotesButton.x - width
                        y: emotesButton.y - height
                        height: 210
                        width: 180
                        modal: false
                        focus: true
                        closePolicy: Popup.CloseOnPressOutsideParent
                        contentItem:
                            GridView {
                                cellHeight: 50
                                cellWidth: 50
                                width: parent.width
                                height: parent.height
                                model: emotesModel
                                delegate: Button {
                                    id: emoteButton
                                    width: emoteImage.implicitWidth
                                    height: emoteImage.implicitHeight
                                    onClicked: {
                                        messageField.text += (' ' + emoteImage.emoteText + ' ')
                                    }
                                    highlighted: true
                                    background: Rectangle {
                                        width: emoteImage.implicitWidth
                                        height: emoteImage.implicitHeight
                                        color: "transparent"
                                    }

                                    Image {
                                        property string emoteText: modelData.slice(0, -4);
                                        id: emoteImage
                                        source: "emotes/" + modelData
                                    }
                                }
                            }
                    }

                Button {
                    id: sendButton
                    text: qsTr("Send")
                    enabled: messageField.length > 0
                    function activate() {
                        if(!enabled)
                            return
                        spawnMessage(client.username + ";;" + messageField.text)
                        messageField.text = ""
                    }
                    Shortcut {
                        enabled: sendButton.enabled
                        sequence: StandardKey.InsertParagraphSeparator
                        onActivated: parent.activate()
                    }
                    onClicked: {
                        activate()
                    }
                }
            }
        }
    }
}
