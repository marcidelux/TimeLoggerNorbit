import requests
from datetime import datetime
from m_config.config import conf

from PyQt6.QtCore import pyqtSlot, QObject, pyqtSignal


class ExpensesHandler(QObject):

    send_expenses_signal = pyqtSignal(list)

    def __init__(self, parent=None) -> None:
        super().__init__(parent=parent)

    @pyqtSlot(list)
    def get_expenses_slot(self, expenses: list):
        for expense in expenses:
            if expense[3] == "HUF":
                expense[5] = ""
            elif expense[5] == 0:
                expense[5] = get_exchange_rate(int((expense[0])), expense[3])

        self.send_expenses_signal.emit(expenses)


def get_exchange_rate(day: int, cur: str) -> float:
    date_str = datetime(year=conf.now.year, month=conf.now.month, day=day).strftime(
        "%Y-%m-%d"
    )
    host = f"https://www.frankfurter.app/{date_str}"
    exParams = {"amount": 1, "from": cur, "to": "HUF"}
    try:
        r = requests.get(url=host, params=exParams)
        if r.status_code != 200:
            print("Curency api call fail")

        data = r.json()
        rate = data["rates"]["HUF"]
        return str(rate)
    except Exception as e:
        print("No internet, fill it yourself: ", e)
        return str("NODATA")


def test():
    get_exchange_rate(10, "NOK")


def main():
    test()


if __name__ == "__main__":
    main()
