import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Page {
    id: root

    Component.onCompleted: {
        client.connected.connect(setupConnected)
        client.error.connect(showError)
        client.stateChanged.connect(showSocketState)
        client.fatalError.connect(setErrorText)
    }

    function setupConnected() {
        infoLabel.text = ""
        errorLabel.text = ""
        root.StackView.view.push("qrc:/ChatroomPage.qml")
    }

    function setErrorText(text) {
        errorLabel.text = text
    }

    function showError(errorCode) {
        setErrorText(qsTr(connectionErrorToStr(errorCode)))
    }

    function showSocketState(socketState) {
        infoLabel.text = socketStateToStr(socketState)
        errorLabel.text = ""
    }

    function socketStateToStr(socketState) {
        switch(socketState) {
        case 1:
            return "Looking up hostname..."
        case 2:
            return "Establishing connection..."
        default:
            return ""
        }
    }

    function connectionErrorToStr(errorCode) {
        switch(errorCode) {
        case 0:
            return "Connection refused by peer."
        case 1:
            return "Remote host closed the connection."
        case 2:
            return "Host address not found."
        case 3:
            return "Insufficient application privileges."
        case 4:
            return "Local system ran out of resources."
        case 5:
            return "The socket operation timed out."
        case 6:
            return "Network error."
        default:
            return "Socket error, code " + errorCode
        }
    }

    Pane {
        id: pane
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        ColumnLayout {
            id: grid
            width: parent.width

            Row {
                spacing: 10
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Hostname")
                }

                TextField {
                    id: ipField
                    placeholderText: qsTr("127.0.0.1")
                    selectByMouse: true
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Port")
                }

                TextField {
                    id: portField
                    width: ipField.width / 3
                    validator: IntValidator{ bottom: 0 }
                    selectByMouse: true
                }
            }

            Row {
                spacing: 10
                Label {
                    text: qsTr("Username")
                    Layout.columnSpan: 2
                }

                TextField {
                    id: usernameField
                    Layout.columnSpan: 2
                    placeholderText: qsTr("Username")
                    validator: RegExpValidator{ regExp: /\w+/g }
                    maximumLength: 24
                    selectByMouse: true
                }
            }

            Button {
                id: connectButton
                text: qsTr("Connect")
                Layout.fillWidth: true
                enabled: ipField.length > 0 && portField.length > 0 && usernameField.length > 0
                onClicked: {
                    activate()
                }
                function activate() {
                    client.username = usernameField.text
                    client.connectToHost(ipField.text, parseInt(portField.text))
                }
                Shortcut {
                    enabled: parent.enabled
                    sequence: StandardKey.InsertParagraphSeparator
                    onActivated: parent.activate()
                }
            }

            Label {
                text: ""
                color: "blue"
                id: infoLabel
            }

            Label {
                text: ""
                color: "red"
                font.bold: true
                id: errorLabel
            }

            Button {
                text: qsTr("About")
                onClicked: dialog.open()
            }
        }
    }

    Dialog {
        id: dialog
        modal: true
        standardButtons: Dialog.Ok

        topMargin: parent.height / 2 - implicitHeight / 2
        leftMargin: parent.width / 2 - implicitWidth / 2
        bottomMargin: parent.height / 2 - implicitHeight / 2
        rightMargin: parent.width / 2 - implicitWidth / 2

        title: qsTr("About PipeChat")
        contentItem: Text {
            text: "PipeChat version " + BUILD
        }
    }
}
