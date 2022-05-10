import QtQuick.Window 6.0
import QtQuick.Controls.Universal 6.0

import "m_day_setter"
import "m_settings"
import "m_expense"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "NORBIT HUN TIME LOGGER"
    height: 600
    width: 1200
    x: 1000
    y: 400
    Universal.theme: Universal.Dark
    Universal.accent: Universal.Violet
    DaysSetter {
        id: daySetter
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.topMargin: 5
    }

    UserData {
        anchors.top: parent.top
        anchors.left: daySetter.right
        anchors.leftMargin: 5
        anchors.topMargin: 5
    }


    Button {
        id: btUpdate
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 100
        height: 100
        text: "UPDATE"
        onClicked: {
            daySetter.send_setted_days()
        }
    }

    Button {
        id: btSave
        anchors.top: btUpdate.top
        anchors.left: btUpdate.right
        anchors.leftMargin: 5
        width: 100
        height: 100
        text: "SAVE"
        onClicked: {
            CONF.save_user_data()
            TDG.save()
        }
    }

    Expense {
        id: testExpense
        anchors.top: btSave.top
        anchors.left: btSave.right
    }
    
    Image {
        source: "norlogoi.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}