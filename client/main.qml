import QtQuick 2.7
import QtQuick.Controls 2.0

ApplicationWindow {
    width: 540
    height: 960
    visible: true

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: ConnectionPage {}
    }
}
