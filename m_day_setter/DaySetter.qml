import QtQuick 6.0
import QtQuick.Controls 6.0


Item {
    id: root
    width: 400
    height: 40
    property int date_idx: 0
    property string day_name: ""
    property alias status: cb_status.currentIndex
    signal dayStatusChanged(int st)

    Rectangle {
        id: date_rect
        width: parent.width / 3
        height: parent.height
        color: "black"
        anchors.left: parent.left
        anchors.top: parent.top
        border.width: 1
        border.color: "gray"

        Text {
            id: date_text
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5
            color: "white"
            text: root.date_idx + " " + root.day_name 
        }
    }

    ComboBox {
        id: cb_status
        width: parent.width * 2 / 3
        height: parent.height
        anchors.right: parent.right
        anchors.top: parent.top
        editable: false

        model: ListModel {
            id: model
            ListElement { text: "Home Office" }
            ListElement { text: "Irodai munkanap" }
            ListElement { text: "Beteg szabadság" }
            ListElement { text: "Fizetett szabadság" }
            ListElement { text: "Fizetett igazolt távollét" }
            ListElement { text: "Elrendelt fizetett állásidő" }
            ListElement { text: "Külföldi munka" }
            ListElement { text: "Nem fizetett szabadság" }
            ListElement { text: "Nem fizetett igazolt távollét" }
            ListElement { text: "Igazolatlan hiányzás" }
        }
        
        onActivated: {
            root.dayStatusChanged(status)
        }
    }

}