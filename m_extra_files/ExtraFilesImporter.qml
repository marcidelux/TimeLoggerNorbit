import QtQuick 6.0
import QtQuick.Controls 6.0


Item {
    id: extraFiles
    width: 184
    height: 165

    signal get_extra_files_signal()
    signal get_extra_files_finished_signal()

    property int cntr: 0
    property var allData : []

    function get_extra_files_slot() {
        if(modelExtr.count) {
            extraFiles.allData = []
            extraFiles.cntr = 0
            extraFiles.get_extra_files_signal()
        } else {
            console.log("Extra files modell is empty")
        }
    }

    function get_extra_files_finished_slot() {
        for (var i = 0; i < extraFiles.allData.length; i++){
            if(extraFiles.allData[i] === false) {
                popupNonFilled.open()
                return
            }
        }
        console.log("send data to backend: " + extraFiles.allData);
        EFS.copy_extra_files(extraFiles.allData)
    }

    Rectangle {
        id: contRect
        anchors.fill: parent
        border.width: 2
        border.color: "gray"
        color: "transparent"

        Rectangle { id: r1; color: "black"; border.color: "gray"; border.width: 2; width: 140; height: 30;
            anchors.top: parent.top; anchors.left: parent.left
            Text{anchors.centerIn: parent; color: "white"; text: "Extra Files"}
        }

        Button { width: 44; height: 30;
            id: btAdd
            anchors.top: parent.top
            anchors.left: r1.right
            text: "+"
            font.pixelSize : 30
            onClicked: {
                modelExtr.create_day()
            }
        }

        ListModel { id: modelExtr;
            property int id_cntr : 0
            function create_day() {
                id_cntr += 1
                modelExtr.append({id_to_pass: id_cntr})
            }
        }

        ListView {
            id: lvExtra;
            width: parent.width
            height: parent.height - 30
            anchors.left: parent.left
            anchors.top: r1.bottom
            anchors.topMargin: 6
            model: modelExtr
            spacing: 4

            delegate: ExtraFile {
                id: extra_delegate
                m_id: id_to_pass

                onDeleteThis: {
                    var target_idx = 0
                    for(target_idx; target_idx < modelExtr.count; target_idx++) {
                        if (modelExtr.get(target_idx).id_to_pass === m_id) {
                            break
                        }
                    }
                    modelExtr.remove(target_idx)
                }

                Connections {
                    target: extraFiles
                    function onGet_extra_files_signal() {
                        extraFiles.cntr += 1
                        extraFiles.allData.push(extra_delegate.get_data())
                        if (modelExtr.count === extraFiles.cntr) {
                            console.log("send signal data get finished");
                            extraFiles.get_extra_files_finished_slot()
                        }
                    }
                }
            }
        }

        Rectangle {
            id: hideRect
            width: parent.width
            height: 15
            anchors.top: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 2
            color: "black"
        }

    }


    Popup {
        id: popupNonFilled
        x: 40
        y: 80
        width: 500
        height: 80
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

        contentItem: Text {
            font.pixelSize: 20
            color: "red"
            text: "Choose path for all extra files field"
        }
    }
}