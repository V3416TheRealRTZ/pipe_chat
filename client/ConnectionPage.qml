import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Page {
    id: root
    Pane {
        id: pane
        Layout.fillWidth: true
        GridLayout {
            id: grid
            columns: 2
            width: parent.width

            Label {
                text: qsTr("ip")
            }

            TextField {
                id: ipField
                inputMask: "000.000.000.000;_"
            }

            Label {
                text: qsTr("Username")
            }

            TextField {
                id: usernameField
                placeholderText: qsTr("Username")
                validator: RegExpValidator{ regExp: /\w+/g }
                maximumLength: 24
            }

            Button {
                id: connectButton
                text: qsTr("Connect")
                Layout.fillWidth: true
                Layout.columnSpan: 2
                onClicked: {
                    //connect
                    root.StackView.view.push("qrc:/ChatroomPage.qml")
                }
            }
        }
    }
}
