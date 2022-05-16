
import QtQuick 6.2
import QtQuick.Controls 6.2
    
Item {
    id: data_input
    width: 400
    height: 40
    property alias input_name: fieldName.text
    property alias input_value: fieldValue.text
    signal changed(string new_text)

    Rectangle {
        id: container
        anchors.fill: parent
        color: "black"
        border.color: "gray"
        border.width: 2

        Rectangle {
            id: nameContRect
            width: 150 
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top
            border.color: "gray"
            border.width: 2
            color: "transparent"
            
            Text {
                id: fieldName
                anchors.centerIn: parent
                color: "white"
                text: "" 
            }
        }

        Rectangle {
            width: 230
            height: parent.height
            anchors.left: nameContRect.right
            anchors.top: nameContRect.top
            color: "transparent"

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    fieldValue.focus = true
                }
            }

            TextInput {
                id: fieldValue
                anchors.centerIn: parent
                color: "white"
                text: ""
                maximumLength: 20

                onEditingFinished: {
                    data_input.changed(fieldValue.text)
                }
            }
        }
    }

}