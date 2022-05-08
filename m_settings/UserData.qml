import QtQuick 6.0
import QtQuick.Controls 6.0

Item {
    width: 380
    height: 128
    Rectangle {
        id: contrect
        anchors.fill: parent
        color: "transparent"

        DataInput {
            id: fieldFirstName
            anchors.left: contrect.left
            anchors.top: contrect.top
            input_name: "First Name"
            input_value: CONF.first_name

            Connections {
                target: fieldFirstName
                function onChanged(new_text) {
                    CONF.first_name = new_text
                }
            }
        }

        DataInput {
            id: fieldLastName
            anchors.left: contrect.left
            anchors.top: fieldFirstName.bottom
            anchors.topMargin: 4
            input_name: "Last Name"
            input_value: CONF.last_name

            Connections {
                target: fieldLastName
                function onChanged(new_text) {
                    CONF.last_name = new_text
                }
            }
        }

        DataInput {
            id: fieldTitle
            anchors.left: contrect.left
            anchors.top: fieldLastName.bottom
            anchors.topMargin: 4
            input_name: "Title"
            input_value: CONF.role
            Connections {
                target: fieldTitle
                function onChanged(new_text) {
                    CONF.role = new_text
                }
            }
        }
    
    }

    Component.onCompleted: {
        console.log(CONF.test)

        CONF.test = 2929
        console.log(CONF.test)
    }

}