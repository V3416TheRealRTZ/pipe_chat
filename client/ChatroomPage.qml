import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import Box2D 2.0

import pipechat.messagemodel 1.0

Page {
    property date currentDate: new Date()

    id: root

    Component.onCompleted: {
        client.disconnected.connect(onDisconnected)
        client.messageArrived.connect(onMessageArrived)
    }

    function onDisconnected() {
        root.StackView.view.pop()
    }

    function onMessageArrived(msg) {
        var parts = msg.split(";")
        //chatModel.addMessage(parts[0], parts[1], parts.slice(2).join(";"))
        var messageBoxComponent = Qt.createComponent("MessageBox.qml")
        var msgBox = messageBoxComponent.createObject(physicsScene, {"text": msg, "world": physicsWorld})
        msgBox.self = msgBox
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

    GridLayout {
        anchors.fill: parent
        columns: 2
        rows: 2

        Rectangle {
            property var pressedBox: null
            property Body pressedBody: null
            property Box pressedBodyBox: null
            property MessageBox pressedMessageBox: null

            id: physicsScene
            color: "green"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding

            MouseJoint {
                id: mouseJoint
                bodyA: anchor
                dampingRatio: 0.8
                maxForce: 100
            }

            MouseArea {
                property alias pressedBox: physicsScene.pressedBox
                property alias pressedBody: physicsScene.pressedBody
                property alias pressedBodyBox: physicsScene.pressedBodyBox
                property alias pressedMessageBox: physicsScene.pressedMessageBox

                id: mouseArea
                anchors.fill: parent
                propagateComposedEvents: true

                onPressed: {
                    if (pressedBody != null) {
                        mouseJoint.maxForce = pressedBody.getMass() * 500
                        mouseJoint.target = Qt.point(mouseX, mouseY)
                        mouseJoint.bodyB = pressedBody

                        //pressedBody.bodyType = Body.Kinematic
                    }
//                    if(pressedBodyBox != null) {
//                        pressedBodyBox.density = 0
//                        pressedBodyBox.rotation = 0
//                    }
//                    if(pressedMessageBox != null) {
//                        pressedMessageBox.text = "Hello World"
//                        pressedMessageBox.density = 0
//                        pressedMessageBox.restitution = 0
//                        pressedMessageBox.friction = 0
//                        pressedMessageBox.bodyType = Body.Kinematic
//                    }
                }

                onPositionChanged: {
                    mouseJoint.target = Qt.point(mouseX, mouseY)
                }

                onReleased: {
                    mouseJoint.bodyB = null
                    //pressedBody = null
                    //pressedBodyBox = null
                }
            }

            World { id: physicsWorld }

            Body {
                id: anchor
                world: physicsWorld
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
                    right: physicsScene.right
                    top: physicsScene.top
                    bottom: physicsScene.bottom
                }
            }
        }

       /* ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
            displayMarginBeginning: 40
            displayMarginEnd: 40
            verticalLayoutDirection: ListView.BottomToTop
            spacing: 12
            model: PipeChatMessageModel {
                id: chatModel
            }
            delegate: Column {
                anchors.right: sentByMe ? parent.right : undefined
                spacing: 6

                readonly property bool sentByMe: author.text == client.username

                Row {
                    id: messageRow
                    spacing: 6
                    anchors.right: sentByMe ? parent.right : undefined

                    Label {
                        id: author
                        text: model.author
                        font.bold: true
                        color: "black"
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Label.Wrap
                    }

                    Rectangle {
                        width: messageText.implicitWidth + 24
                        height: messageText.implicitHeight + 24
                        color: sentByMe ? "lightgrey" : "steelblue"

                        Label {
                            id: messageText
                            text: model.text
                            color: sentByMe ? "black" : "white"
                            anchors.fill: parent
                            anchors.margins: 12
                            wrapMode: Label.Wrap
                        }
                    }
                }

                Label {
                    id: timestampText
                    text: {
                        model.timestamp
                    }

                    color: "lightgrey"
                    anchors.right: sentByMe ? parent.right : undefined
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }*/

        ListView {
            id: userList
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
            displayMarginBeginning: 40
            displayMarginEnd: 40
            verticalLayoutDirection: ListView.TopToBottom
            spacing: 12
            model: client.userlist
            delegate: ItemDelegate {
                text: modelData
                width: userList.width - userList.leftMargin - userList.rightMargin
                height: 32
                leftPadding: 32
            }

            ScrollBar.vertical: ScrollBar {}
        }

        Pane {
            id: pane
            Layout.fillWidth: true
            Layout.columnSpan: 2

            RowLayout {
                width: parent.width

                TextField {
                    id: messageField
                    Layout.fillWidth: true
                    placeholderText: qsTr("Compose message")
                }

                Button {
                    id: sendButton
                    text: qsTr("Send")
                    enabled: messageField.length > 0
                    function activate() {
                        if(!enabled)
                            return
                        client.sendMessage(messageField.text)
                        messageField.text = ""
                    }
                    Shortcut {
                        enabled: parent.enabled
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
