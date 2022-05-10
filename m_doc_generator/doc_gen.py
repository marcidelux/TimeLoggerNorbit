from openpyxl import load_workbook
from openpyxl import Workbook
from openpyxl.styles import PatternFill 
from openpyxl.styles.colors import Color
from PyQt6 import QtCore
from PyQt6.QtCore import pyqtSlot, QObject
from datetime import datetime
from calendar import monthrange

from m_config.config import conf


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
                 path:str="time_template.xlsx",
                 parent=None) -> None:

        super().__init__(parent=parent)
        self.path = path
        self.wb = Workbook()
        self.ws = None

    def load(self, path:str = None):
        self.path = path or self.path

        try:
            self.wb = load_workbook(self.path)
        except FileNotFoundError as e:
            print("Error: ", e)
            return
        
        self.ws = self.wb['YYYY MM']
        print("Load success")
    
    def delete_extra_days(self):
        print(f"Call extra days delete, num of days: {conf.num_of_days}")
        if conf.num_of_days == 31:
            return
        num_to_del = 31 - conf.num_of_days
        end_of_days_cell = 40-num_to_del
        print(f"Delete rows: {num_to_del}")
        self.ws.delete_rows(41 - num_to_del, num_to_del)
        self.ws[f"E{41-num_to_del}"] = f"=SUM(E10:E{end_of_days_cell})+SUM(F10:F{end_of_days_cell})"
        self.ws[f"E{42-num_to_del}"] = f"=SUM(H10:H{end_of_days_cell})"
        self.ws[f"B{43-num_to_del}"] = f'=SUBSTITUTE(SUBSTITUTE(SUBSTITUTE("Össz.kötelező munkanap: $1 nap, $2 fiz.ü.nap. (telj.munkaidő össz.óra: $3 óra)", "$1", COUNT(C10:C{end_of_days_cell})), "$2", E50), "$3", COUNT(C10:C{end_of_days_cell}) * 8)'
        self.ws[f"E{50-num_to_del}"] = f'=COUNTIF(I10:I{end_of_days_cell}, "Fü")'
        self.ws[f"E{51-num_to_del}"] = f'=COUNTIF(I10:I{end_of_days_cell}, "Fsz")'
        self.ws[f"E{52-num_to_del}"] = f'=COUNTIF(I10:I{end_of_days_cell}, "Figt")'
        self.ws[f"E{53-num_to_del}"] = f'=COUNTIF(K10:K{end_of_days_cell}, "HO")'
        self.ws[f"E{54-num_to_del}"] = f'=COUNTIF(I10:I{end_of_days_cell}, "Áll")'
        self.ws[f"E{55-num_to_del}"] = f'=COUNTIF(I10:I{end_of_days_cell}, "B")'
        self.ws.merge_cells(f"B{43-num_to_del}:N{43-num_to_del}")


    def set_user_data(self):
        self.ws.title = conf.now.strftime("%Y %b") 
        self.ws[NAME_CELL] = f"{conf._last_name} {conf._first_name}"
        self.ws[DATE_CELL] = conf.now.strftime("%d/%m/%Y")
        self.ws[JOB_TYTLE_CELL]= f"{conf._role}"

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
                #print("Color to grey, remove fields, its weekend")
                continue
            if status_idx == 10:
                self.del_data_and_color_row(row)
                #print("Color to grey, remove fields, its a payd holiday")

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

    # Loads the Excel templte, sets the user data.
    def setup(self):
        self.load()
        self.delete_extra_days()
        self.set_user_data() #Todo move this to the end.

    
    @QtCore.pyqtSlot()
    def save(self):
        name = "Jelenléti-{}_{}_{}.xlsx".format(conf.now.strftime("%b").lower(), conf.now.year, conf._last_name)
        self.set_user_data()
        self.wb.save(name)
    
    @QtCore.pyqtSlot(list)
    def update_days(self, days:list):
        for day in days:
            print(day)
        self.set_days(days)


class ExpensesDocGenerator(QObject):
    purpose_cell = "C3"
    name_cell = "C6"
    position_cell = "F6"
    from_cell = "M5"
    to_cell = "M6"


    def __init__(self,
                 path:str="expenses_template.xlsx",
                 parent=None) -> None:

        super().__init__(parent=parent)
        self.path = path
        self.wb = Workbook()
        self.ws = None

    def load(self, path:str = None):
        self.path = path or self.path

        try:
            self.wb = load_workbook(self.path)
        except FileNotFoundError as e:
            print("Error: ", e)
            return
        
        self.ws = self.wb['expense']
        print("Load success")

    def set_user_data(self):
        self.ws[self.name_cell] = f"{conf._first_name} {conf._last_name}"
        self.ws[self.position_cell] = f"{conf._role}"
        self.ws[self.purpose_cell] = "Budapest, {}".format(conf.now.strftime("%B %Y"))
        self.ws[self.from_cell] = datetime(conf.now.year, conf.now.month, 1).strftime("%Y-%m-%d")
        self.ws[self.to_cell] = datetime(conf.now.year, conf.now.month, conf.num_of_days).strftime("%Y-%m-%d")
    
    def save(self):
        name = "declaration_of_costs-{}.xlsx".format(conf.now.strftime("%b_%Y"))
        self.wb.save(name)


def test():
    expenses = ExpensesDocGenerator()
    expenses.load()
    expenses.set_user_data()
    expenses.save()


if __name__ == "__main__":
    test()