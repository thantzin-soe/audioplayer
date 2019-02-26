import QtQuick 2.5

Item {
    id:root
    property var table:([])
    property bool secondResolution: false
    signal triggered(var index);

    QtObject{
        id:prv
        property var todayTable:([])
        //.................................................private healper function
        function dayFilter(){
            prv.todayTable=[];
            var todayDay=new Date();
            var Today=todayDay.getDay();
            for( var idx in root.table){
                if(root.table[idx]["date"][Today]){ //day
                    prv.todayTable.push({
                                            "INDEX" : idx,  //index
                                            "TIME" :  timeToInt(root.table[idx]["time"])  //time
                                            //,"FILE" : root.table[idx]["F"],  //Filename
                                        }) ;
                }
            }
            console.log("dayFilter",Today);
        }


        function timeToInt(time){
            var AMPM=time.split(" ")[1];
            var Hour=time.split(" ")[0].split(":")[0];
            var Min=time.split(" ")[0].split(":")[1];
            Hour=  AMPM==="PM" ? Number(Hour)+12 : Hour ;
            var timeInt=(Hour*60)+Number(Min);
             console.log("timeToInt ",timeInt);
            return timeInt ;
        }

//        function tableSort(){

//        }
    }

    Timer{
        id: timer
        interval: 1000
        repeat: true
        property int prevHour: -1
        property int prevMinute: -1
        property int prevDay: -1
        onTriggered: {
            var dateTime=new Date();
            var hour=dateTime.getHours()
            var minute=dateTime.getMinutes();

            if(hour!=prevHour){prevHour=hour;
                // Hour Changed
                var Day=dateTime.getDay();
                if(Day!=prevDay){prevDay=Day;
                    //Day Changed
                    prv.dayFilter();
                }
            }


            if(secondResolution){
                //Second Changed
            }else{
                // Minute Changed
                if( prevMinute!=minute){ prevMinute=minute;
                    var timeInt=(hour*60)+minute;
                    for( var idx in  prv.todayTable){
                        if(prv.todayTable[idx]["TIME"]===timeInt){
                            root.triggered(prv.todayTable[idx]["INDEX"]);
                            console.log("Trigger")
                            break;
                        }
                    }
                    console.log("Minute Changed", timeInt)
                }

            }

        }
    }
    onTableChanged: {
        var dateTime=new Date();
        timer.prevDay=dateTime.getDay();
        if(root.table.length>0){
        prv.dayFilter();
        }
    }
    //.......................................................................Method
    function start(){
        timer.start();
    }
}
