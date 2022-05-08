import QtQuick.Window 6.0
import QtQuick.Controls.Universal 6.0

import "m_day_setter"
import "m_settings"

ApplicationWindow {
    id: mainWindow
    visible: true
    title: "NORBIT HUN TIME LOGGER"
    height: 600
    width: 800
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

    /*
    Button {
        anchors.top: parent.top
        anchors.right: parent.right
        width: 100
        height: 100
        onClicked: {
            daySetter.send_setted_days()
        }
    }
    */
}