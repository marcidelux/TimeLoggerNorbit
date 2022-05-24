import QtQuick 6.0
import QtQuick.Controls 6.0

Item {
    id: days_setter
    width: 400
    height: 400

    function create_days(days) {
        for(var i = 0; i < days.length; i++) {
            lm_days.append(lm_days.create_day(days[i]["idx"], days[i]["name"]));
        } 
    }

    function send_setted_days() {
        var days_list = []
        for(var i = 0; i < lm_days.count; i++) {
            var dict = {
                "idx": lm_days.get(i).m_date_idx,
                "status": lm_days.get(i).m_status
                }
            days_list.push(dict)
        }
        TDG.update_days(days_list)
    }

    ListModel {
        id: lm_days

        function create_day(date_idx, day_name) {
            return {m_date_idx: date_idx, m_day_name: day_name, m_status: 0}
        }
    }

    ListView {
        id: lv_days
        anchors.fill: parent
        model: lm_days
        spacing: 4

        delegate: DaySetter {
            id: ds_del
            date_idx: m_date_idx
            day_name: m_day_name
            status: model.m_status

            Connections {
                target: ds_del
                function onDayStatusChanged(st) {
                    console.log("new status: "+ st)
                    model.m_status = st
                }
            }
        }

    }

    Connections {
        target: WDG
        function onSignal_working_days(wds) {
            var list_of_wd = []
            for(var i = 0; i < wds.length; i++) {
                var dict = {
                    "idx": wds[i][0], 
                    "name": wds[i][1]
                    }
                list_of_wd.push(dict)
            }

            days_setter.create_days(list_of_wd)
        }
    }

}