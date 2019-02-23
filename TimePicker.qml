import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    height: 60
    width: 400
    property int start_hour: 0
    property int start_minute: 0
    property string start_am_pm: "AM"
    signal start_hourchanged()
    signal start_minutechanged()
    signal start_am_pm_changed()

    Column{
        anchors.fill: parent
        spacing: 10
        Row{
            spacing: 5
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
            ComboBox {
                id : ampm
                model: [ "AM", "PM" ]
                onActivated: {
                    start_am_pm = ampm.currentText
                    start_am_pm_changed()
                }
            }
        }
    }


}
