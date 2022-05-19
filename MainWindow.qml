import QtQuick.Window 6.0
import QtQuick.Controls.Universal 6.0

import "m_day_setter"
import "m_settings"
import "m_expense"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "NORBIT HUN TIME LOGGER"
    height: 595
    width: 1130
    x: 200
    y: 200
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
        id: btUpdate
        anchors.bottom: parent.bottom
        anchors.left: daySetter.right
        anchors.leftMargin: 10
        width: 100
        height: 100
        text: "UPDATE"
        onClicked: {
            daySetter.send_setted_days()
            expenses.get_expense_data()
        }
    }

    Button {
        id: btSave
        anchors.top: btUpdate.top
        anchors.left: btUpdate.right
        anchors.leftMargin: 10
        width: 100
        height: 100
        text: "SAVE"
        onClicked: {
            CONF.save_user_data()
            TDG.save()
            EDG.save()
        }
    }


    
    Image {
        source: CONF.logo_path
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }
}