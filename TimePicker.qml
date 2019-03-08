import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id : root
    height: 60
    width: 400
    property int start_hour: 0
    property int start_minute: 0
    property int start_second : 0
    property string start_am_pm: "PM"
    signal start_hourchanged()
    signal start_minutechanged()
    signal start_am_pm_changed()
    signal start_secondchanged()

    Column{
        anchors.fill: parent
        spacing: 10
        Row{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                width: hour.width
                text: qsTr("Hour")
            }

            Text {
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                width: minute.width
                text: qsTr("Minute")
            }

            Text {
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                width: second.width
                text: qsTr("Second")
            }

            Text {
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                width: ampm.width
                text: qsTr("AM/PM")
            }
        }

        Row{
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter

            SpinBox {
                id: hour
                value: 1
                from : 1
                to : 12
                onValueChanged: {
                    start_hour = hour.value
                    start_hourchanged()
                }

            }
            SpinBox {
                id: minute
                value : 0
                from : 0
                to : 59
                onValueChanged: {
                    start_minute = minute.value
                    start_minutechanged()
                }
            }
            SpinBox {
                id: second
                value : 0
                from : 0
                to : 59
                stepSize: 5
                onValueChanged: {
                    start_second = second.value
                    start_secondchanged()
                }
            }
            ComboBox {
                id : ampm
                model: [ "AM", "PM" ]
                currentIndex: 1
                onActivated: {
                    root.start_am_pm = ampm.currentText
                    console.log("emitted onactivated",root.start_am_pm);
                    root.start_am_pm_changed()
                }
                onCurrentIndexChanged: {
                    root.start_am_pm = ampm.currentText
                    console.log("emitted oncurrentIndex ",root.start_am_pm);
                    root.start_am_pm_changed()
                }
            }
        }
    }

    function resetPickers(){
        hour.value = 1;
        minute.value = 0;
        second.value = 0;
        ampm.currentIndex = 1;
    }

    function setPickers(start_h,start_m,am_pm){
        hour.value = start_h;
        minute.value = start_m;
        if(am_pm.toString() === "AM"){
            ampm.currentIndex = 0;
        }else{
            ampm.currentIndex = 1;
        }
    }
}
