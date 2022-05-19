import QtQuick 6.0
import QtQuick.Controls 6.0
import QtQuick.Window 6.0


Item {
    id: expSetter
    width: 700
    height: 200

    property int cntr: 0
    property var allData : []

    signal get_expense_data_signal()
    signal get_expense_finished_signal()

    Connections{
        target: expSetter
        function onGet_expense_finished_signal() {
            expSetter.get_all_finished()
        }
    }

    function get_expense_data() {
        expSetter.allData = []
        expSetter.cntr = 0
        expSetter.get_expense_data_signal()
    }

    function get_all_finished() {
        console.log("Finished getting exp data")
        console.log(expSetter.allData)

        for (var i = 0; i < expSetter.allData.length; i++){
            if(expSetter.allData[i] === false) {
                popupNonFilled.open()
                return
            }
        }
        console.log("Data is fine lets send it to backend.")
        EXP.get_expenses_slot(expSetter.allData)
    }

    function send_espenses() {
        var expenses_list = []
        
        for(var i = 0; i < expModel.count; i++) {
            expenses_list.push(expModel.get(i).exp_data)
        }

        console.log(expenses_list)

    }

    Rectangle {
        id: contRect
        width: 700
        height: 260
        border.width: 2
        border.color: "gray"
        color: "transparent"
        
        ListModel { id: expModel;
            property int id_cntr : 0
            function create_day() {
                id_cntr += 1
                expModel.append({id_to_pass: id_cntr, exp_data: []})
            }
        }

        ListView {id: lvExp;
            width: 700
            height: 200
            anchors.left: parent.left
            anchors.top: r6.bottom
            model: expModel
            spacing: 4

            delegate: Expense {
                id: exp_del
                m_id: id_to_pass
                onDeleteThis: {
                    var target_idx = 0
                    for(target_idx; target_idx < expModel.count; target_idx++) {
                        if (expModel.get(target_idx).id_to_pass === m_id) {
                            break
                        }
                    }
                    console.log("ID: " + m_id + " IDX: " + target_idx)
                    expModel.remove(target_idx)
                }

                Connections {
                    target: expSetter
                    function onGet_expense_data_signal() {
                        expSetter.cntr += 1
                        expSetter.allData.push(exp_del.get_data())
                        if (expModel.count === expSetter.cntr) {
                            expSetter.get_expense_finished_signal()
                        }
                    }
                }
            }
        }

        Rectangle { id: r1; color: "black"; border.color: "gray"; border.width: 2; width: 40; height: 40;
            anchors.top: parent.top; anchors.left: parent.left
            Text{anchors.centerIn: parent; color: "white"; text: "Date"}
        }
        Rectangle { id: r2; color: "black"; border.color: "gray"; border.width: 2; width: 160; height: 40;
            anchors.top: parent.top; anchors.left: r1.right
            Text{anchors.centerIn: parent; color: "white"; text: "Description"}
        }
        Rectangle { id: r3; color: "black"; border.color: "gray"; border.width: 2; width: 140; height: 40;
            anchors.top: parent.top; anchors.left: r2.right
            Text{anchors.centerIn: parent; color: "white"; text: "Topic"}
        }
        Rectangle { id: r4; color: "black"; border.color: "gray"; border.width: 2; width: 75; height: 40;
            anchors.top: parent.top; anchors.left: r3.right
            Text{anchors.centerIn: parent; color: "white"; text: "Curency"}
        }
        Rectangle { id: r5; color: "black"; border.color: "gray"; border.width: 2; width: 80; height: 40;
            anchors.top: parent.top; anchors.left: r4.right
            Text{anchors.centerIn: parent; color: "white"; text: "Amount"}
        }
        Rectangle { id: r6; color: "black"; border.color: "gray"; border.width: 2; width: 60; height: 40;
            anchors.top: parent.top; anchors.left: r5.right
            Text{anchors.centerIn: parent; color: "white"; text: "EX rate"}
        }
        Rectangle { id: r7; color: "black"; border.color: "gray"; border.width: 2; width: 100; height: 40;
            anchors.top: parent.top; anchors.left: r6.right
            Text{anchors.centerIn: parent; color: "white"; text: "File Path"}
        }
        Button { width: 44; height: 40;
            id: btAdd
            anchors.top: parent.top
            anchors.left: r7.right
            text: "+"
            font.pixelSize : 30
            onClicked: {
                expModel.create_day()
            }
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
            text: "Field is missing at one of the Expenses!\nIf rate isnt set, than it will be filled automatically."
        }
    }


}