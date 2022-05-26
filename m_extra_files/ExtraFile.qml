import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

Item {
    id: extraFile
    width: 184
    height: 30
    property string selectedPath: ""
    property int m_id: 0
    signal deleteThis()


    function get_data() {
        console.log("get data called");
        if (fileText.text != "select file") {
            return extraFile.selectedPath
        }
        return false
    }

    Rectangle {
        id: filePath
        width: 140
        height: 30
        anchors.left: parent.left
        anchors.top: parent.top
        color: "transparent"
        border.color: "gray"
        border.width: 2
        MouseArea{anchors.fill: parent; onClicked: {extFileDialog.open()}}

        Text {
            id: fileText
            anchors.centerIn: parent
            color: "white"
            text: "select file"
        }
    }

    Button{
        width: 44
        height: 30
        anchors.top: parent.top
        anchors.left: filePath.right
        font.pixelSize : 30
        text: "-"
        onClicked: {
            extraFile.deleteThis()
        }
    }

    FileDialog {
        id: extFileDialog
        nameFilters: [ "Invoice (*.pdf *.jpg *.png)", "All files (*)" ]
        onAccepted: {
            console.log(extFileDialog.selectedFile)
            selectedPath = extFileDialog.selectedFile.toString()
            var filename = extFileDialog.selectedFile.toString().replace(/^.*[\\\/]/, '')
            if (filename.length > 15) {
                filename = "..." + filename.substring(filename.length - 15)
            }
            fileText.text = filename
        }
    }
}