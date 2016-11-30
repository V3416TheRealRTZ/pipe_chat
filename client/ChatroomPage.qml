import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

import pipechat.messagemodel 1.0

Page {
    property date currentDate: new Date()

    id: root

    Component.onCompleted: {
        client.disconnected.connect(onDisconnected)
    }

    function onDisconnected() {
        root.StackView.view.pop()
    }

    header: ToolBar {
            ToolButton {
                text: qsTr("Disconnect")
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    client.disconnectFromHost()
                }

            /*Label {
                id: pageTitle
                text: "test"
                font.pixelSize: 20
                anchors.centerIn: parent
            }*/
        }
    }

        GridLayout {
            anchors.fill: parent
            columns: 2
            rows: 2

            ListView {
                id: listView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: pane.leftPadding + messageField.leftPadding
                displayMarginBeginning: 40
                displayMarginEnd: 40
                verticalLayoutDirection: ListView.BottomToTop
                spacing: 12
                model: PipeChatMessageModel {}
                delegate: Column {
                    anchors.right: sentByMe ? parent.right : undefined
                    spacing: 6

                    readonly property bool sentByMe: index % 2 == 0

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
                        text:  {
                        if (Qt.formatDate(currentDate) != Qt.formatDate(currentDate))
                            Qt.formatDateTime(currentDate)
                        else
                            Qt.formatTime(currentDate)
                        }

                        color: "lightgrey"
                        anchors.right: sentByMe ? parent.right : undefined
                    }
                }

                ScrollBar.vertical: ScrollBar {}
            }

            ListView {
                id: userList
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.margins: pane.leftPadding + messageField.leftPadding
                displayMarginBeginning: 40
                displayMarginEnd: 40
                verticalLayoutDirection: ListView.TopToBottom
                spacing: 12
                model: 10
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

                    TextArea {
                        id: messageField
                        Layout.fillWidth: true
                        placeholderText: qsTr("Compose message")
                        wrapMode: TextArea.Wrap
                    }

                    Button {
                        id: sendButton
                        text: qsTr("Send")
                        enabled: messageField.length > 0
                        onClicked: {
                            messageField.text = "";
                        }
                    }
                }
            }
        }
}
