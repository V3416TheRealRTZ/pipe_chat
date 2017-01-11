import QtQuick 2.0
import Box2D 2.0

Image {
    property alias text: username.text
    property var target: undefined

    id: pipe

    width: 300
    height: 100
    z: 1000

    source: "images/pipe.png"

    Text {
        id: username
        text: ""
        font.family: "Arial"
        font.pointSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Wall {
        id: top
        anchors {
            top: parent.top
            topMargin: 12
            left: parent.left
            right: parent.right
        }
        height: 1
        width: parent.width
        xb: x
        yb: y
        z: 100
        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3
        color: "transparent"
        target: pipe
    }
    Wall {
        id: bottom
        anchors {
            bottom: parent.bottom
            bottomMargin: 12
            left: parent.left
            right: parent.right
        }
        width: parent.width
        height: 1
        xb: x
        yb: y
        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3
        color: "transparent"
        target: pipe
    }
//    Wall {
//        id: front
//        anchors {
//            top: parent.top
//            bottom: parent.bottom
//            right: parent.right
//        }
//        width: 1
//        xb: x
//        yb: y
//        widthb: width
//        heightb: height
//        categories: Box.Category2
//        collidesWith: Box.Category1 | Box.Category2
//        color: "black"
//        target: pipe
//    }
    Wall {
        id: topNudge
        anchors {
            top: parent.top
            right: parent.right
        }
        width: 43
        height: 12
        xb: x
        yb: y
        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3
        color: "transparent"
        target: pipe
    }
    Wall {
        id: bottomNudge
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
        width: 43
        height: 12
        xb: x
        yb: y
        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3
        color: "transparent"
        target: pipe
    }

    Wall {
        id: back
        anchors {
            top: parent.top
            topMargin: 13
            bottom: parent.bottom
            bottomMargin: 13
            left: parent.left
        }
        width: 3
        xb: x
        yb: y
        categories: Box.Category2
        collidesWith: Box.Category1 | Box.Category2 | Box.Category3
        color: "transparent"
        target: pipe
        onBeginContact: {
            if(other) {
                var parts = other.rectangle.text.split(";")
                if(username.text.length > 0)
                    client.sendMessage(other.rectangle.author + ';' + username.text + ';' + other.rectangle.message)
                else
                    client.sendMessage(other.rectangle.author + ";;" + other.rectangle.message)
                mouseArea.release()
                other.rectangle.destroy()
            }
        }
    }
}
