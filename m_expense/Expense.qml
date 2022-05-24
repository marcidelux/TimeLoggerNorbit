import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    id: expense
    width: 700
    height: 40
    signal deleteThis()
    property var expData: ["0","","","","0","0",""]
    property string selectedPath: ""
    property int m_id: 0
   
    function get_data() {
        if(expense.fill_data()) {
            return expense.expData
        } else {
            return false
        }
    }

    function fill_data() {
        if (dateInp.text !== "0") {expData[0] = dateInp.text;} else {return false;}
        if(descInp.text === "Description") {expData[1] =  ""} else {expData[1] =  descInp.text}
        expData[2] = expType.displayText
        expData[3] = curency.displayText
        if (amountInp.text !== "0" ) {expData[4] = parseInt(amountInp.text);} else {return false;}
        if (exchangeInp.text === "EXCH" || exchangeInp.text === "") {expData[5] = 0} else {expData[5] = exchangeInp.text}
        if (fileText.text === "select file" || fileText.text === ""){return false}else{expData[6] = selectedPath}
        return true
    }

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
            MouseArea{anchors.fill: parent; onClicked: {dateInp.forceActiveFocus()}}

            TextInput {
                id: dateInp
                anchors.centerIn: parent
                color: "white"
                text: "0"
                maximumLength: 2
                validator: IntValidator {bottom: 1; top: 31}
                onFocusChanged: {
                    if (text === "0") {text = "";}
                }
            }
        }

        Rectangle {
            id: descCont
            width: 160
            height: parent.height
            anchors.left: dateCont.right
            anchors.top: parent.top
            color: "transparent"
            border.color: "gray"
            border.width: 2
            MouseArea{anchors.fill: parent; onClicked: {descInp.forceActiveFocus()}}

            TextInput {
                id: descInp
                anchors.centerIn: parent
                color: "white"
                text: "Description"
                maximumLength: 30
                onFocusChanged: {if (text === "Description") {text = "";};}
            }
        }

        ComboBox {
            id: expType
            width: 140
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
        }

        ComboBox {
            id: curency
            width: 75
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
            MouseArea{anchors.fill: parent; onClicked: {amountInp.forceActiveFocus()}}

            TextInput {
                id: amountInp
                anchors.centerIn: parent
                color: "white"
                text: "Amount"
                maximumLength: 20
                validator: IntValidator {bottom: 1; top: 1000000}
                onFocusChanged: {if (text === "Amount") {text = "";}}
            }
        }

        Rectangle {
            id: exchangeCont
            width: 60
            height: parent.height
            anchors.left: amountCont.right
            anchors.top: parent.top
            color: "transparent"
            border.color: "gray"
            border.width: 2
            MouseArea{anchors.fill: parent; onClicked: {exchangeInp.forceActiveFocus()}}

            TextInput {
                id: exchangeInp
                anchors.centerIn: parent
                color: "white"
                text: "EXCH"
                maximumLength: 20
                validator: IntValidator {bottom: 1; top: 1000000}
                onFocusChanged: {if (text === "EXCH") {text = "";}}
            }
        }


        Rectangle {
            id: filePath
            width: 100
            height: parent.height
            anchors.left: exchangeCont.right
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


        Button{
            width: 44
            height: 40
            anchors.top: parent.top
             anchors.left: filePath.right
            font.pixelSize : 30
            text: "-"
            onClicked: {
                expense.deleteThis()
            }
        }
    }

    FileDialog {
        id: expFileDialog
        nameFilters: [ "Invoice (*.pdg *.jpg *.png)", "All files (*)" ]
        onAccepted: {
            console.log(expFileDialog.selectedFile)
            selectedPath = expFileDialog.selectedFile.toString()
            var filename = expFileDialog.selectedFile.toString().replace(/^.*[\\\/]/, '')
            if (filename.length > 10) {
                filename = "..." + filename.substring(filename.length - 10)
            }
            fileText.text = filename
        }
    }

}