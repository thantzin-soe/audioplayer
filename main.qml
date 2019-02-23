import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import MicrostackQMLExtra  1.0

Window {
    id : app
   // flags: Qt.WindowFullscreenButtonHint | Qt.FramelessWindowHint
    visible: true
    width: Screen.width
    height: Screen.height
    minimumWidth: 1080
    minimumHeight: 600
    title: qsTr("MI Player")
    color: "teal"
    property var audio_file_list: ({})
    property string chosen_file_path: ""
    property var dates : [0,0,0,0,0,0,0]
    property int start_h : 0
    property int start_m: 0
    property string am_pm : "AM"

    FontLoader { id: myFont; source: "qrc:///fontawesome.ttf" }

    JsonFileIO {
        id : jsonFileIo
        filename : "F:/data.json"
        Component.onCompleted: {
            audio_file_list = jsonFileIo.load();
            for(var i in audio_file_list){
                for(var key in audio_file_list[i]){
                    if(key === "date"){
                        let arr = audio_file_list[i][key];
                        delete audio_file_list[i][key];
                        audio_file_list[i]["date"] = arr;
                    }

                }
                myModel.append(audio_file_list[i]);
            }

            console.log("Start " + audio_file_list.length);

        }
        onSaveFinished : {
            myModel.clear()
            audio_file_list = jsonFileIo.load();
            for(var i in audio_file_list){
                myModel.append(audio_file_list);
            }
            console.log("Inserted " + audio_file_list.length);
        }
    }

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
                                font.family: "Zawgyi-One"
                                width : (mainview.width - 100) / 2
                                text: file_path;
                                clip: true
                                wrapMode: Text.WordWrap

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
                                     app.audio_file_list.splice(index,1);
                                     myModel.clear()
                                    for(var i = 0 ; i < app.audio_file_list.length ; i++){
                                        myModel.append(app.audio_file_list[i]);
                                    }
                                     let after_delete = JSON.stringify(app.audio_file_list);
                                     appSetting.audio_list = after_delete;

                                }
                            }
                        }
                    }

                    ScrollBar.vertical: ScrollBar {
                        id : vbar
                        contentItem: Item {
                            implicitWidth: 1
                            implicitHeight: 100
                            visible: myModel.count > 0 ? true : false
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
    }

   Dialog{
        id : addDialog
        title: "Add New MP3"

        contentItem: Rectangle {
            id : mainContent
            color: "lightgrey"
            implicitWidth: 600
            implicitHeight: 350

                Rectangle{
                    id : addDialog_row_one
                    width: mainContent.width
                    height: 50
                    color: "grey"
                    Row{
                        anchors.fill: addDialog_row_one
                        anchors.leftMargin: 10
                        spacing: 10
                        Button{
                            id : fileChoose_Btn
                            anchors.verticalCenter: parent.verticalCenter
                            text : "Choose File"
                            width: 90
                            height: 30
                            font.pixelSize: 13
                            background: Rectangle{
                                color: fileChoose_Btn.down ? "#009490" : "teal"
                                border.width: fileChoose_Btn.down ? 1 : 0
                                border.color: "#00A0A0"
                                radius: 3
                            }

                            contentItem: Text {
                                text: fileChoose_Btn.text
                                font: fileChoose_Btn.font
                                anchors.centerIn: fileChoose_Btn
                                color: "white"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            onClicked: {
                               fileChooser.open()

                            }
                        }

                        Text{
                            id : file_path
                            anchors.verticalCenter: parent.verticalCenter
                            font.family: "Zawgyi-One"
                            font.pixelSize: 14

                            text : "File Path"
                        }

                    }



            }



                Item{
                    id : checkboxgroup
                    width: parent.width
                    height: 100
                    anchors.top: addDialog_row_one.bottom
                    anchors.topMargin: 20
                    anchors.horizontalCenter: mainContent.horizontalCenter

                    Row{
                        spacing: 5
                        anchors.centerIn: parent
                        CheckBox{
                            id : monday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "MON"
                            onCheckedChanged: {
                                if(monday.checked){
                                    dates[0] = true
                                }else{
                                    dates[0] = false
                                }
                            }
                        }
                        CheckBox{
                            id : tuesday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "TUE"
                            onCheckedChanged: {
                                if(tuesday.checked){
                                    dates[1] = true
                                }else{
                                    dates[1] = false
                                }
                            }
                        }
                        CheckBox{
                            id : wednesday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "WED"
                            onCheckedChanged: {
                                if(wednesday.checked){
                                    dates[2] = true
                                }else{
                                    dates[2] = false
                                }
                            }
                        }
                        CheckBox{
                            id : thursday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "THU"
                            onCheckedChanged: {
                                if(thursday.checked){
                                    dates[3] = true
                                }else{
                                    dates[3] = false
                                }
                            }
                        }
                        CheckBox{
                            id : friday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "FRI"
                            onCheckedChanged: {
                                if(friday.checked){
                                    dates[4] = true
                                }else{
                                    dates[4] = false
                                }
                            }
                        }
                        CheckBox{
                            id : saturday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "SAT"
                            onCheckedChanged: {
                                if(saturday.checked){
                                    dates[5] = true
                                }else{
                                    dates[5] = false
                                }
                            }
                        }
                        CheckBox{
                            id : sunday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "SUN"
                            onCheckedChanged: {
                                if(sunday.checked){
                                    dates[6] = true
                                }else{
                                    dates[6] = false
                                }
                            }
                        }
                        CheckBox{
                            id : daily
                            text: "DAILY"
                            contentItem: Text {
                                      text: daily.text
                                      font.bold: true
                                      opacity: enabled ? 1.0 : 0.3
                                      color: daily.down ? "#ff8899" : "#ff8899"
                                      verticalAlignment: Text.AlignVCenter
                                      leftPadding: daily.indicator.width + daily.spacing
                                  }
                            onCheckedChanged: {
                                if(daily.checked){
                                    for(var i in dates){
                                        dates[i] = true
                                    }

                                }else{
                                    for(var j in dates){
                                        dates[j] = false
                                    }

                                }

                            }
                        }
                    }
                }



                    TimePicker{
                        id : time_picker
                        anchors.top: checkboxgroup.bottom
                        anchors.bottomMargin: 20
                        anchors.horizontalCenter: mainContent.horizontalCenter
                        onStart_hourChanged: {
                            start_h = time_picker.start_hour
                        }
                        onStart_minuteChanged: {
                            start_m = time_picker.start_minute
                        }
                        onStart_am_pmChanged: {
                            am_pm = time_picker.start_am_pm
                        }
                    }
                    Button{
                        id : save
                        width: 100
                        height: 30
                        font.family: myFont.name
                        font.pixelSize: 14
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottomMargin: 20

                        text: "Save"
                        background: Rectangle{
                            color: save.down ? "#009490" : "teal"
                            border.width: save.down ? 1 : 0
                            border.color: "#00A0A0"
                            radius: 3
                        }

                        contentItem: Text {
                            text: save.text
                            font: save.font
                            color: "white"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                        onClicked: {
                            chosen_file_path = JSON.stringify(fileChooser.fileUrl)
                            chosen_file_path = chosen_file_path.replace(/\\|\"/g,"");

                            let time = start_h + ":" + start_m + " " + am_pm
                            console.log("Saving ");
                            console.log("File path " + chosen_file_path);
                            console.log("Time " + time);
                            for(var i in dates){
                                console.log(dates[i]);
                            }

                            var newObj = {
                                file_path : app.chosen_file_path,
                                date : app.dates,
                                time : time
                            };

                            app.audio_file_list.push(newObj);
                            jsonFileIo.save(app.audio_file_list);

                            chosen_file_path = "";
                            for(var j in dates){
                                dates[j] = 0
                            }

                            addDialog.close();
                        }
                    }
        }
    }

   FileDialog{
        id : fileChooser
        title: qsTr("MI Player")
        onAccepted:{
            let file = fileUrl
            file = JSON.stringify(file);

            file = file.substring(file.lastIndexOf('/')+1, file.length-1)
            file_path.text = file;
            console.log(file.length);
        }
        onRejected: app.chosen_file_path = ""
   }

    Component.onCompleted: {
//        let data = [
//                    {
//                        name : "One.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Two.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Three.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Four.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Five.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Six.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Seven.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Eight.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Nine.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Teen.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "One.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Eleven.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "One.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Twelve.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Thirteen.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Fourteen.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Fifteen.mp3",
//                        date : "Monday",
//                        time : "9:00 AM"
//                    },
//                    {
//                        name : "Sixteen.mp3",
//                        date : "Tuesday",
//                        time : "9:00 AM"
//                    },
//                ]
//        data = JSON.stringify(data);
//        appSetting.audio_list = data;
    }
}
