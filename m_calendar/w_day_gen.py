from datetime import datetime
from datetime import date
from calendar import monthrange
import json
from PyQt6.QtCore import pyqtSignal, QObject

from m_config.config import conf

day_names = {
    0: "Hétfő",
    1: "Kedd",
    2: "Szerda",
    3: "Csütörtök",
    4: "Péntek",
    5: "Szombat",
    6: "Vasárnap",
}

class WorkingDayGenerator(QObject):

    signal_working_days = pyqtSignal(list)

    def __init__(self) -> None:
        super().__init__(parent=None)
        self.working_days = []
        self.non_working_days = []
        self.wds_days_path = f"{conf.now.year}_wds.json"

    # This function is based on the non working days list
    # so that has to be called before this.
    def create_wds(self) -> list:
        for i in range(conf.num_of_days):
            day = i + 1
            if day not in self.non_working_days:
                name = day_names[datetime(conf.now.year, conf.now.month, day).weekday()]
                self.working_days.append({"idx": day, "name": name})
    
    # Create a list of non working days, it contains only the date index of teh day.
    # Load extra days shoudl be called before this.
    def create_nwds(self):
        self.non_working_days = []
        for i in range(conf.num_of_days):
            day = i + 1
            temp_date = date(conf.now.year, conf.now.month, day)
            weekday = temp_date.weekday()
            # Check if the day is a weekend and not in working saturdays list.
            # Or if the day in theconf holidays.
            if ((weekday == 5 or weekday == 6) and day not in conf.working_saturdays) or day in conf.holidays:
                self.non_working_days.append(day)
    
    def create_days_for_doc(self) -> list:
        res = []
        for nwd in self.non_working_days:
            if nwd in conf.holidays:
                res.append({"idx": nwd, "status": 10})
            else:
                res.append({"idx": nwd, "status": 11})
        return res
    
    def send_working_days(self):
        send_list = []
        for wd in self.working_days:
            send_list.append([wd["idx"], wd["name"]])
        self.signal_working_days.emit(send_list)

    # After the init, call this function, it calls the creation functions in good order
    def setup(self):
        self.create_nwds()
        self.create_wds()

def test():
    wdg = WorkingDayGenerator()
    wdg.setup()
    print(wdg.non_working_days)
    print(conf.holidays)
    for wd in wdg.working_days:
        print(wd)


if __name__ == "__main__":
    test()
