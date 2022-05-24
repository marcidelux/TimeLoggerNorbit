import QtQuick.Window 6.0
import QtQuick.Controls.Universal 6.0

import "m_day_setter"
import "m_settings"
import "m_expense"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "NORBIT HUN TIME LOGGER V1.0"
    height: 595
    width: 1130
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    Universal.theme: Universal.Dark
    Universal.accent: Universal.Violet

    DaysSetter {
        id: daySetter
        anchors.top: userData.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10
    }

    UserData {
        id: userData
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 10
    }

    Expenses {
        id: expenses
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.left: userData.right
    }

    Button {
        id: btSave
        anchors.bottom: parent.bottom
        anchors.left: daySetter.right
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        width: 100
        height: 100
        text: "SAVE"
        onClicked: {
            startSave.start()
            saving_msg.text = "Saving..."
        }
    }


    CheckBox {
        id: cbDelete
        checked: true
        text: "Delete result folder"
        anchors.bottom: btSave.bottom
        anchors.left: btSave.right
        anchors.leftMargin: 10
    }

    Rectangle {
        width: 60
        height: 20
        anchors.top: btSave.top
        anchors.left: btSave.right
        anchors.leftMargin: 20
        anchors.topMargin: 20
        color: "transparent"

        Text {
            id: saving_msg
            anchors.fill: parent
            color: "white"
            text: ""
        }
    }

    Image {
        source: CONF.logo_path
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 20
        anchors.rightMargin: 20
    }

    Connections {
        target: EDG
        function onSaved_signal() {
            console.log("Data saved")
            saving_msg.text = "Done"
        }
    }

    Connections {
        target: TDG
        function onData_updated_signal() {
            console.log("Get expenses slot")
            expenses.get_expense_data()
        }
    }

    Connections {
        target: EDG
        function onReady_to_save_signal() {
            console.log("Main - save data")
            CONF.save_user_data()
            TDG.save()
            EDG.save(cbDelete.checked)
        }
    }

    Timer {
       id: startSave
       interval: 10
       repeat: false
       running: false
       onTriggered: {
            daySetter.send_setted_days()
       }
   }
}