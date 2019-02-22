import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import Qt.labs.settings 1.1

Window {
    id : app
    visible: true
    width: Screen.width
    height: Screen.height
    minimumWidth: 1080
    minimumHeight: 600
    title: qsTr("MI Player")
    color: "teal"
    property var audio_file_list: ({})
    Settings{
        id : appSetting
        property string audio_list : ""

        Component.onCompleted: {
            audio_file_list = JSON.parse(appSetting.audio_list)
            for(var i = 0 ; i < audio_file_list.length ; i++){
                myModel.append(audio_file_list[i]);
            }
        }
    }

    FontLoader { id: myFont; source: "qrc:///fontawesome.ttf" }

    Rectangle{
        id : container
        width: 1080
        height: 600
        anchors.centerIn: parent
        color: "lightgrey"
        radius: 2
        clip: true

        ColumnLayout{
            id : column
            spacing: 5
            width: parent.width

            Rectangle {
                id : rowLayout_one
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 70
                color: "lightgrey"
                radius: 3


                Button {
                    id : addBtn
                    width: 100
                    height: 45
                    text: "Add New"
                    font.pixelSize: 13
                    anchors.right: rowLayout_one.right
                    anchors.rightMargin: 50
                    anchors.verticalCenter: rowLayout_one.verticalCenter
                    background: Rectangle{
                        color: addBtn.down ? "#009490" : "teal"
                        border.width: addBtn.down ? 1 : 0
                        border.color: "#00A0A0"
                        radius: 2
                    }

                    contentItem: Text {
                        text: addBtn.text
                        font: addBtn.font
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight

                    }

                    onClicked: {
                        addDialog.open()
                    }

                }
            }


                ListView{
                    id : mainview
                    Layout.preferredHeight: container.height - 70
                    Layout.preferredWidth: container.width / 1.1
                    Layout.alignment: Qt.AlignCenter
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    model : myModel

                    delegate: Rectangle{
                        id : content
                        width: mainview.width
                        height: 50
                        anchors.margins: 5
                        color: "lightgrey"

                        Row{
                            anchors.fill: content
                            anchors.centerIn: content
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 5
                            Text{
                                anchors.verticalCenter: parent.verticalCenter

                                width : (mainview.width - 100) / 2
                                text: title;
                            }
                            Text{
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignLeft
                                width : (mainview.width - 100) / 2
                                text: date + ", " + time
                            }

                            Button{
                                id : editBtn
                                anchors.verticalCenter: parent.verticalCenter
                                width: 30
                                height: 30
                                font.family: myFont.name
                                font.bold: true
                                text: "\uf044"
                                background: Rectangle{
                                    color: editBtn.down ? "#009490" : "teal"
                                    border.width: editBtn.down ? 1 : 0
                                    border.color: "#00A0A0"
                                    radius: 3
                                }

                                contentItem: Text {
                                    text: editBtn.text
                                    font: editBtn.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight
                                }

                            }
                            Button{
                                id : deleteBtn
                                anchors.verticalCenter: parent.verticalCenter
                                width: 30
                                height: 30
                                font.family: myFont.name
                                text: "\uf00d"
                                background: Rectangle{
                                    color: deleteBtn.down ? "#009490" : "teal"
                                    border.width: deleteBtn.down ? 1 : 0
                                    border.color: "#00A0A0"
                                    radius: 3
                                }

                                contentItem: Text {
                                    text: deleteBtn.text
                                    font: deleteBtn.font
                                    color: "white"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    elide: Text.ElideRight

                                }
                                onClicked: {
                                     console.log(app.audio_file_list.length);
                                     app.audio_file_list.splice(index,1);
                                     console.log(app.audio_file_list.length);
                                }
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        id : vbar
                        contentItem: Item {
                            implicitWidth: 1
                            implicitHeight: 100

                            Rectangle {
                                opacity: 0.5
                                anchors { top: parent.top; topMargin: 13; bottom: parent.bottom; bottomMargin: 13; left: parent.left; leftMargin: -2; right: parent.right; rightMargin: -2}
                                color: "#003030"
                            }
                        }
                    }

                }
                ListModel{
                    id : myModel
                }
            }

        Dialog{
            id : addDialog
            title: "Title"
            width: 400
            height: 400

            standardButtons: Dialog.Ok | Dialog.Cancel | Dialog.Close
            onAccepted: console.log("Ok clicked")
            onRejected: console.log("Cancel clicked")
        }
    }

    Component.onCompleted: {
        console.log(container.height - 70)
    }
}
