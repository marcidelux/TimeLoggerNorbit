import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    id: expense
    width: 820
    height: 40
    property var expData: [0,"","","HUF",0,""]
   
   Rectangle {
        id: container
        anchors.fill: parent
        border.width: 2
        border.color: "gray"
        color: "transparent"

        Rectangle {
            id: dateCont
            width: 40
            height: parent.height
            anchors.left: parent.left
            anchors.top: parent.top
            color: "transparent"
            border.color: "gray"
            border.width: 2
            MouseArea{anchors.fill: parent; onClicked: {dateInp.focus = true;}}

            TextInput {
                id: dateInp
                anchors.centerIn: parent
                color: "white"
                text: "DT"
                maximumLength: 2
                validator: IntValidator {bottom: 1; top: 31}
                onFocusChanged: {if (text === "DT") {text = "";};expData[0] = parseInt(text);console.log(expData);}
            }
        }

        Rectangle {
            id: descCont
            width: 300
            height: parent.height
            anchors.left: dateCont.right
            anchors.top: parent.top
            color: "transparent"
            border.color: "gray"
            border.width: 2
            MouseArea{anchors.fill: parent; onClicked: {descInp.focus = true;}}

            TextInput {
                id: descInp
                anchors.centerIn: parent
                color: "white"
                text: "Description"
                maximumLength: 30
                onFocusChanged: {if (text === "Description") {text = "";}expData[1] = text;}
                
            }
        }

        ComboBox {
            id: expType
            width: 160
            height: parent.height
            anchors.left: descCont.right
            anchors.top: parent.top
            editable: false

            model: ListModel {
                id: exp_model
                ListElement { text: "Hotel" }
                ListElement { text: "Transport" }
                ListElement { text: "Fuel" }
                ListElement { text: "Allowance" }
                ListElement { text: "Phone" }
                ListElement { text: "Entertainment" }
                ListElement { text: "Other" }
            }

            onActivated: {
                if (expType.currentIndex === 6) {
                    expType.editable = true
                    expType.editText = ""
                } else {
                    expType.editable = false
                }
            }

            onFocusChanged: {expData[2] = editText;}
        }

        ComboBox {
            id: curency
            width: 120
            height: parent.height
            anchors.left: expType.right
            anchors.top: parent.top
            editable: false

            model: ListModel {
                id: cur_model
                ListElement { text: "HUF" }
                ListElement { text: "EUR" }
                ListElement { text: "USD" }
                ListElement { text: "NOK" }
            }

            onFocusChanged: {expData[3] = displayText;}
        }

        Rectangle {
            id: amountCont
            width: 80
            height: parent.height
            anchors.left: curency.right
            anchors.top: parent.top
            color: "transparent"
            border.color: "gray"
            border.width: 2
            MouseArea{anchors.fill: parent; onClicked: {amountInp.focus = true;}}

            TextInput {
                id: amountInp
                anchors.centerIn: parent
                color: "white"
                text: "Amount"
                maximumLength: 20
                validator: IntValidator {bottom: 1; top: 1000000}
                onFocusChanged: {if (text === "Amount") {text = "";} expData[4] = parseInt(text)}
            }
        }

        Rectangle {
            id: filePath
            width: 120
            height: parent.height
            anchors.left: amountCont.right
            anchors.top: parent.top
            color: "transparent"
            border.color: "gray"
            border.width: 2
            MouseArea{anchors.fill: parent; onClicked: {expFileDialog.open()}}

            Text {
                id: fileText
                anchors.centerIn: parent
                color: "white"
                text: "select file"
            }
        }
    }


    FileDialog {
        id: expFileDialog
        onAccepted: {
            console.log(expFileDialog.selectedFile)
            expData[5] = expFileDialog.selectedFile.toString()
            fileText.text = expFileDialog.selectedFile.toString().replace(/^.*[\\\/]/, '')
        }
    }

}