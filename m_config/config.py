import os
import json
from datetime import datetime
from PyQt6.QtCore import QObject
from PyQt6.QtCore import pyqtProperty

CONFIG_FILE_NAME_PATH = "./m_config/user.json"
NWD_FILE_NAME_PATH = "./m_config/{}_wds.json"

class Config(QObject):
    _init_done = False

    def __init__(self) -> None:
        if Config._init_done:
            return
        super().__init__(parent=None)
        self.now = datetime.now()
        self._first_name = ""
        self._last_name = ""
        self._role = ""
        self._mail = {
            "user_email": "",
            "user_pass": "",
            "to_email": ""
        }
        self.holidays = []
        self.working_saturdays = []
        self.load_non_working_days()
        self.load_user_data()
        Config._init_done = True

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

    def __new__(cls):
        if not hasattr(cls, '_instance'):
            cls._instance = super(Config, cls).__new__(cls)
        return cls._instance

    def load_non_working_days(self):
        with open(NWD_FILE_NAME_PATH.format(self.now.year)) as f:
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
        with open(CONFIG_FILE_NAME_PATH) as f:
            data = json.load(f)
            self._first_name = data["user"]["first_name"]
            self._last_name = data["user"]["last_name"]
            self._role = data["user"]["role"]
            self.mail = data["mail"]

conf = Config()