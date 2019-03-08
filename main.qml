import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import Qt.labs.settings 1.1
import QtQuick.Dialogs 1.3
import MicrostackQMLExtra  1.0
import QtMultimedia 5.8

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
    property string start_m: "0"
    property string am_pm : "PM"
    property int edit_id: 0
    FontLoader { id: myFont; source: "qrc:///fontawesome.ttf" }

    Audio {
           id: player
           autoPlay: true
           source : ""

       }

    JsonFileIO {
        id : jsonFileIo
        filename : "D:/data.json"
        Component.onCompleted: {
            audio_file_list = jsonFileIo.load();
            for(var idx in audio_file_list){
                var obj = audio_file_list[idx];
                var filename = obj['file_path'];
                //filename = filename.substring(filename.lastIndexOf('/') + 1,filename.length);
                var date = obj['date'];
                var time = obj['time'];
                myModel.append({'file_path' : filename , 'date' : JSON.stringify(date) , 'time' : time});
            }

        }
        onSaveFinished : {
            console.log("Cleared");
            myModel.clear()
            audio_file_list = jsonFileIo.load();
            for(var idx in audio_file_list){
                var obj = audio_file_list[idx];
                var filename = obj['file_path'];
                //filename = filename.substring(filename.lastIndexOf('/') + 1,filename.length);
                var date = obj['date'];
                var time = obj['time'];
                myModel.append({'file_path' : filename , 'date' : JSON.stringify(date) , 'time' : time});
            }
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
                        time_picker.resetPickers();
                        addDialog.editMode = false;
                        addDialog.open()
                    }

                }
            }


                ListView{
                    id : mainview
                    spacing: 5
                    Layout.preferredHeight: container.height - 70
                    Layout.preferredWidth: container.width / 1.1
                    Layout.alignment: Qt.AlignCenter
                    clip: true
                    flickableDirection: Flickable.VerticalFlick
                    boundsBehavior: Flickable.StopAtBounds
                    model : myModel
                    currentIndex: -1

                    delegate: Rectangle{
                        id : content
                        property bool isCurrentItem: mainview.currentIndex === index ? true : false
                        width: mainview.width
                        height: 45
                        anchors.margins: 5
                        color: isCurrentItem ? "black" : "grey"
                        //color : "grey"

                        Row{
                            anchors.fill: content
                            anchors.centerIn: content
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 5
                            Text{
                                id : file_path_row
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "Zawgyi-One"
                                width : (mainview.width - 100) / 3
                                text: file_path.substring(file_path.lastIndexOf('/') + 1,file_path.length)


                                clip: true
                                wrapMode: Text.WordWrap
                                font.weight: Font.DemiBold
                                font.bold: content.isCurrentItem
                                color: content.isCurrentItem ? "#33D095" : "white"
                                //color : "white"
                            }
                            Row{
                                id : day_row
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 4

                                property var daylist: JSON.parse(date)
                                Repeater{
                                    model: ["SUN","MON","TUE","WED","THU","FRI","SAT"];
                                    Rectangle{
                                        width: 35
                                        height: 35
                                        radius: 5
                                        color : "#33D095"
                                        Text {
                                            anchors.fill: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: modelData
                                            color : "white"
                                        }
                                        opacity: day_row.daylist[index] === 1 ? 1 : 0.3
                                    }
                                }
                            }

                            Text{ 
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignHCenter
                                width : (mainview.width - 100) / 3
                                text: time
                                font.bold: content.isCurrentItem
                                color: content.isCurrentItem ? "#33D095" : "white"
                                //color: "white"

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

                                onClicked: {

                                    chosen_file_path = file_path;
                                    filepath.text = file_path.substring(file_path.lastIndexOf('/') + 1,file_path.length);
                                    let timestamp = time;
                                    let hm_ampm = timestamp.split(" ");
                                    let hour_minute = hm_ampm[0];
                                    am_pm = hm_ampm[1];
                                    start_h = hour_minute.split(":")[0];
                                    start_m = parseInt(hour_minute.split(":")[1]);
                                    edit_id = index;

                                    time_picker.setPickers(start_h,start_m,am_pm);

                                    let date_list = JSON.parse(date);
                                    for(var idx in date_list){
                                        if(idx === "0" && date_list[idx] === 1){
                                            sunday.checked =  true;
                                        }else if(idx === "1" && date_list[idx] === 1){
                                            monday.checked = true;
                                        }else if(idx === "2" && date_list[idx] === 1){
                                            tuesday.checked = true;
                                        }else if(idx === "3" && date_list[idx] === 1){
                                            wednesday.checked = true;
                                        }else if(idx === "4" && date_list[idx] === 1){
                                            thursday.checked = true;
                                        }else if(idx === "5" && date_list[idx] === 1){
                                            friday.checked = true;
                                        }else if(idx === "6" && date_list[idx] === 1){
                                            saturday.checked = true;
                                        }
                                    }
                                    if(sunday.checked && monday.checked && tuesday.checked && wednesday.checked && thursday.checked && friday.checked &&                                  saturday.checked){
                                        daily.checked = true;
                                    }
                                    addDialog.title = "Edit MP3";
                                    addDialog.editMode = true;
                                    addDialog.open();
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
                                     let currentIndex = mainview.currentIndex
                                     app.audio_file_list.splice(index,1);
                                     jsonFileIo.save(app.audio_file_list);
                                     mainview.currentIndex = currentIndex;
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
        property bool editMode: false
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
                            id : filepath
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
                            id : sunday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "SUN"
                            onCheckedChanged: {
                                if(sunday.checked){
                                    dates[0] = 1
                                }else{
                                    dates[0] = 0
                                }
                            }
                        }
                        CheckBox{
                            id : monday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "MON"
                            onCheckedChanged: {
                                if(monday.checked){
                                    dates[1] = 1
                                }else{
                                    dates[1] = 0
                                }
                            }
                        }
                        CheckBox{
                            id : tuesday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "TUE"
                            onCheckedChanged: {
                                if(tuesday.checked){
                                    dates[2] = 1
                                }else{
                                    dates[2] = 0
                                }
                            }
                        }
                        CheckBox{
                            id : wednesday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "WED"
                            onCheckedChanged: {
                                if(wednesday.checked){
                                    dates[3] = 1
                                }else{
                                    dates[3] = 0
                                }
                            }
                        }
                        CheckBox{
                            id : thursday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "THU"
                            onCheckedChanged: {
                                if(thursday.checked){
                                    dates[4] = 1
                                }else{
                                    dates[4] = 0
                                }
                            }
                        }
                        CheckBox{
                            id : friday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "FRI"
                            onCheckedChanged: {
                                if(friday.checked){
                                    dates[5] = 1
                                }else{
                                    dates[5] = 0
                                }
                            }
                        }
                        CheckBox{
                            id : saturday
                            checked : daily.checkState === Qt.Checked ? true : false
                            text: "SAT"
                            onCheckedChanged: {
                                if(saturday.checked){
                                    dates[6] = 1
                                }else{
                                    dates[6] = 0
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
                                        dates[i] = 1
                                    }
                                    monday.checked = true;
                                    tuesday.checked = true;
                                    wednesday.checked = true;
                                    thursday.checked = true;
                                    friday.checked = true;
                                    saturday.checked = true;
                                    sunday.checked = true;
                                }else{
                                    for(var j in dates){
                                        dates[j] = 0
                                    }
                                    monday.checked = false;
                                    tuesday.checked = false;
                                    wednesday.checked = false;
                                    thursday.checked = false;
                                    friday.checked = false;
                                    saturday.checked = false;
                                    sunday.checked = false;
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
                            app.am_pm = time_picker.start_am_pm
                            console.log("handler ",app.am_pm);
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
                            let currentIndex = mainview.currentIndex;

                            if(addDialog.editMode){

                                if(parseInt(start_m) < 10){
                                    start_m =  "0" + start_m.toString();
                                }
                                start_h = start_h < 1 ? 1 : start_h;
                                let edit_time = start_h + ":" + start_m + " " + app.am_pm
                                console.log("Edit Saving " , edit_id);
                                console.log("Edit File path " + chosen_file_path);
                                console.log("Edit Time " + edit_time);
                                for(var ii in dates){
                                    console.log(dates[ii]);
                                }


                                audio_file_list[edit_id]['file_path'] = chosen_file_path.replace(/\\|\"/g,"");
                                audio_file_list[edit_id]['date'] = dates;
                                audio_file_list[edit_id]['time'] = edit_time;

                                jsonFileIo.save(audio_file_list);


                            }else{

                                chosen_file_path = chosen_file_path.replace(/\\|\"/g,"");
                                if(parseInt(start_m) < 10){
                                    start_m =  "0" + start_m.toString();
                                }

                                start_h = start_h < 1 ? 1 : start_h;
                                let time = start_h + ":" + start_m + " " + app.am_pm
                                console.log("Saving ");
                                console.log("File path " + chosen_file_path);
                                console.log("Time " + time);
                                for(var i in dates){
                                    console.log(dates[i]);
                                }

                                var newObj = {
                                    file_path : chosen_file_path,
                                    date : app.dates,
                                    time : time
                                };

                                app.audio_file_list.push(newObj);
                                jsonFileIo.save(app.audio_file_list);
                            }

                            mainview.currentIndex = currentIndex;

                            chosen_file_path = "";
                            for(var j in dates){
                                dates[j] = 0
                            }
                            start_h = 0;
                            start_m = "0";
                            am_pm = "PM";
                            fileChooser.clearSelection();
                            chosen_file_path = "";
                            filepath.text = "";
                            monday.checked = false;
                            tuesday.checked = false
                            wednesday.checked = false;
                            thursday.checked = false;
                            friday.checked  = false;
                            saturday.checked = false;
                            sunday.checked = false;
                            daily.checked = false;
                            time_picker.resetPickers();
                            addDialog.editMode = false;
                            addDialog.close();
                        }
                    }
        }

        onVisibleChanged: {
            if(addDialog.visible){

            }else{
                filepath.text = "";
                monday.checked = false;
                tuesday.checked = false
                wednesday.checked = false;
                thursday.checked = false;
                friday.checked  = false;
                saturday.checked = false;
                sunday.checked = false;
                daily.checked = false;
                time_picker.resetPickers();
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
            filepath.text = file;
            chosen_file_path = JSON.stringify(fileChooser.fileUrl)
        }
        onRejected: app.chosen_file_path = ""
   }

   SCHEDULE{
       id : schedule
       table: app.audio_file_list
       onTriggered: {
           scheduleTrigger(index)
       }
   }


    function scheduleTrigger(index){
        mainview.currentIndex = index;
        let filename = audio_file_list[index]['file_path'];
        if(player.playbackState === Audio.PlayingState){
            player.stop();
        }
        player.source = filename.toString();
        player.play();

    }

    Component.onCompleted: {
        schedule.start();
    }
}
