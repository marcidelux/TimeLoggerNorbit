from openpyxl import load_workbook
from openpyxl import Workbook
from openpyxl.styles import PatternFill 
from openpyxl.styles.colors import Color
from PyQt6 import QtCore
from PyQt6.QtCore import pyqtSlot, QObject
from datetime import datetime
from calendar import monthrange

DATE_CELL = "F2"
NAME_CELL = "E4"
JOB_TYTLE_CELL = "M4"
GREY_COLOR = "BB808080"

day_status = {
    0: {"col": "K", "value": "HO"},     # Home Office
    1: "",                              # Irodai munkanap
    2: {"col": "I", "value": "B"},      # Beteg szabadság
    3: {"col": "I", "value": "Fsz"},    # Fizetett szabadság
    4: {"col": "I", "value": "Figt"},   # Fizetett igazolt távollét
    5: {"col": "I", "value": "Áll"},    # Elrendelt fizetett állásidő
    6: {"col": "H", "value": "1"},      # Külföldi munka
    7: {"col": "J", "value": "Fnsz"},   # Nem fizetett szabadság
    8: {"col": "J", "value": "Nigt"},   # Nem fizetett igazolt távollét
    9: {"col": "J", "value": "H"},      # Igazolatlan hiányzás
   10: {"col": "I", "value": "Fü"},     # Fizetett ünnep
   11: {""},                            # Hetvege
}

class TimeDocGenerator(QObject):
    def __init__(self,
                 path:str="Jelenléti_template.xlsx",
                 f_name:str = None,
                 l_name:str = None,
                 job_title:str = None,
                 parent=None) -> None:

        super().__init__(parent=parent)
        self.path = path
        self.f_name = f_name
        self.l_name = l_name
        self.job_title = job_title
        self.wb = Workbook()
        self.ws = None
        self.now = datetime.now()

    def load(self, path:str = None):
        self.path = path or self.path

        try:
            self.wb = load_workbook(self.path)
        except FileNotFoundError as e:
            print("Error: ", e)
            return
        
        self.ws = self.wb['YYYY MM']
        print("Load success")
    
    def set_user_data(self):
        self.ws.title = self.now.strftime("%Y %b") 
        self.ws[NAME_CELL] = f"{self.f_name} {self.l_name}"
        self.ws[DATE_CELL] = self.now.strftime("%d/%m/%Y")
        self.ws[JOB_TYTLE_CELL]= f"{self.job_title}"

    def set_days(self, days:list = None):
        for day in days:
            row = int(day["idx"] + 9)
            status_idx = day["status"]

            #First clear the previusly set data from rows
            for col in range(8,12):
                self.ws.cell(row, col).value = ""

            if status_idx == 1:
                continue
            if status_idx == 11:
                self.del_data_and_color_row(row)
                print("Color to grey, remove fields, its weekend")
                continue
            if status_idx == 10:
                self.del_data_and_color_row(row)
                print("Color to grey, remove fields, its a payd holiday")

            status_cell = day_status[status_idx]["col"] + str(row)
            value = day_status[status_idx]["value"]
            self.ws[status_cell] = value

            if day["idx"] == 2:
                print("Set Day2")

    def del_data_and_color_row(self, row):
        my_gray = Color(rgb='00808080')
        my_fill = PatternFill(patternType='solid', fgColor=my_gray)
        for col in range(3,7):
            self.ws.cell(row, col).value = ""
        for col in range(2,15):
            self.ws.cell(row, col).fill = my_fill

    def save(self, name:str = "test.xlsx"):
        self.wb.save(name)
    
    # Loads the Excel templte, sets the user data.
    def setup(self):
        self.load()
        self.set_user_data() #Todo move this to the end.

    @QtCore.pyqtSlot(list)
    def update_days(self, days:list):
        for day in days:
            print(day)
        self.set_days(days)
        self.save()


def test():
    m_tdg = TimeDocGenerator(f_name="Marton", l_name="Lorinczi", job_title="Programmer")
    m_tdg.load()
    m_tdg.set_user_data() 

    temp_days = [
        {"idx": 8, "state": 0},
        {"idx": 9, "state": 1},
        {"idx": 10, "state": 2},
        {"idx": 11, "state": 3},
        {"idx": 12, "state": 4},
        {"idx": 13, "state": 5},
        {"idx": 14, "state": 6},
        {"idx": 15, "state": 7},
        {"idx": 16, "state": 8},
        {"idx": 17, "state": 5},
        {"idx": 18, "state": 10},
    ]

    m_tdg.set_days(temp_days)
    m_tdg.save()


if __name__ == "__main__":
    test()