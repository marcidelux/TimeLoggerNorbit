import json
from datetime import datetime
from calendar import monthrange
from PyQt6.QtCore import QObject
from PyQt6.QtCore import pyqtProperty
from PyQt6.QtCore import pyqtSlot

DATA_RESULTS_PATH = "./data_results"
DATA_SOURCES_PATH = "./data_sources/"
DATA_RESULT_PATH = DATA_RESULTS_PATH + "/{}_{}_{}_{:02d}/"
EXPENSES_SOURCE_PATH = DATA_SOURCES_PATH + "expenses.xlsx"
TIMELOG_SOURCE_PATH = DATA_SOURCES_PATH + "timelog.xlsx"
CONFIG_FILE_PATH = DATA_SOURCES_PATH + "user.json"
NWD_FILE_PATH = DATA_SOURCES_PATH + "{}_wds.json"
EXPENSE_RESULT_PATH = DATA_RESULT_PATH + "declaration_of_costs-{}.xlsx"
TIMELOG_RESULT_PATH = DATA_RESULT_PATH + "Jelenléti-{}_{}_{}.xlsx"
ZIP_NAME_PATH = "./data_results/{}_{}_{}_{:02d}"
LOGO_PATH = DATA_SOURCES_PATH + "logo.png"
LOADING_GIF_PATH = DATA_SOURCES_PATH + "loading2.gif"

class Config(QObject):
    def __init__(self) -> None:
        global NWD_FILE_PATH
        super().__init__(parent=None)
        self.now = datetime.now()
        NWD_FILE_PATH = NWD_FILE_PATH.format(self.now.year)
        self.num_of_days = monthrange(self.now.year, self.now.month)[1]
        self._first_name = ""
        self._last_name = ""
        self._role = ""
        self.holidays = []
        self.working_saturdays = []

    @pyqtProperty(str)
    def logo_path(Self):
        global LOGO_PATH
        return LOGO_PATH

    @pyqtProperty(str)
    def loading_path(Self):
        global LOADING_GIF_PATH
        return LOADING_GIF_PATH


    @pyqtProperty(str)
    def first_name(self):
        return self._first_name

    @first_name.setter
    def first_name(self, value):
        self._first_name = value
        print(self._first_name)

    @pyqtProperty(str)
    def last_name(self):
        return self._last_name

    @last_name.setter
    def last_name(self, value):
        self._last_name = value
        print(self._last_name)

    @pyqtProperty(str)
    def role(self):
        return self._role

    @role.setter
    def role(self, value):
        self._role = value
        print(self._role)

    def get_results_path(self) -> str:
        global DATA_RESULT_PATH
        return DATA_RESULT_PATH.format(
            self._first_name,
            self._last_name,
            self.now.year,
            self.now.month,
        )

    def get_zip_path(self) -> str:
        global ZIP_NAME_PATH
        return ZIP_NAME_PATH.format(
            self._first_name,
            self._last_name,
            self.now.year,
            self.now.month,
        )

    def get_timelog_path(self) -> str:
        global TIMELOG_RESULT_PATH
        return TIMELOG_RESULT_PATH.format(
            self._first_name,
            self._last_name,
            self.now.year,
            self.now.month,
            self.now.strftime("%b").lower(),
            self.now.year,
            self._last_name,
        )

    def get_expense_path(self) -> str:
        global EXPENSE_RESULT_PATH
        return EXPENSE_RESULT_PATH.format(
            self._first_name,
            self._last_name,
            self.now.year,
            self.now.month,
            self.now.strftime("%b_%Y"),
        )

    def load_non_working_days(self):
        with open(NWD_FILE_PATH) as f:
            data = json.load(f)

            for hd in data["Holidays"]:
                temp_date = datetime.strptime(hd, "%Y.%m.%d")
                if temp_date.month == self.now.month:
                    self.holidays.append(temp_date.day)

            for wd in data["Work_on_Saturday"]:
                temp_date = datetime.strptime(wd, "%Y.%m.%d")
                if temp_date.month == self.now.month:
                    self.working_saturdays.append(temp_date.day)

    def load_user_data(self):
        with open(CONFIG_FILE_PATH) as f:
            data = json.load(f)
            self._first_name = data["user"]["first_name"]
            self._last_name = data["user"]["last_name"]
            self._role = data["user"]["role"]

    @pyqtSlot()
    def save_user_data(self):
        print("Save userdata")
        data = None
        with open(CONFIG_FILE_PATH) as f:
            data = json.load(f)

        data["user"]["first_name"] = self._first_name
        data["user"]["last_name"] = self._last_name
        data["user"]["role"] = self._role

        with open(CONFIG_FILE_PATH, "w") as f:
            json.dump(data, f, indent=4, sort_keys=True)
    
    def post_init(self):
        self.load_non_working_days()
        self.load_user_data()

    def post_init(self):
        self.load_non_working_days()
        self.load_user_data()


conf = Config()
conf.post_init()
