import QtQuick 2.7
import QtQuick.Controls 2.0

ApplicationWindow {
    minimumWidth: 1280
    minimumHeight: 900
    visible: true

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: ConnectionPage {}
    }
}
