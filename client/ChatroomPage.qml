import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0

Page {
    property date currentDate: new Date()

    id: root

    header: ToolBar {
            ToolButton {
                text: qsTr("Disconnect")
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    // Disconnect
                    root.StackView.view.pop()
            }

            /*Label {
                id: pageTitle
                text: "test"
                font.pixelSize: 20
                anchors.centerIn: parent
            }*/
        }
    }

    ColumnLayout {
        anchors.fill: parent

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
            displayMarginBeginning: 40
            displayMarginEnd: 40
            verticalLayoutDirection: ListView.BottomToTop
            spacing: 12
            model: 10
            delegate: Column {
                anchors.right: sentByMe ? parent.right : undefined
                spacing: 6

                readonly property bool sentByMe: index % 2 == 0

                Row {
                    id: messageRow
                    spacing: 6
                    anchors.right: sentByMe ? parent.right : undefined

                    Rectangle {
                        width: 80
                        height: 40
                        color: sentByMe ? "lightgrey" : "steelblue"

                        Label {
                            id: messageText
                            text: index
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

        Pane {
            id: pane
            Layout.fillWidth: true

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
