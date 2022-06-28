import sys
import os

from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtWidgets import QApplication
from PyQt6.QtCore import QUrl
from PyQt6.QtGui import QIcon

from m_calendar.w_day_gen import WorkingDayGenerator
from m_doc_generator.doc_gen import TimeDocGenerator, ExpensesDocGenerator, ExtraFilesSaver
from m_expense.expenses import ExpensesHandler
from m_config.config import conf, LOGO_PATH


application_path = (
    sys._MEIPASS
    if getattr(sys, "frozen", False)
    else os.path.dirname(os.path.abspath(__file__))
)


def main():
    print("Starting app")

    wdg = WorkingDayGenerator()
    edg = ExpensesDocGenerator()
    tdg = TimeDocGenerator()
    exph = ExpensesHandler()
    efs = ExtraFilesSaver()

    # Connect slots between python classes
    exph.send_expenses_signal.connect(edg.receive_expense_data_slot)

    # Loads all necesary information.
    wdg.setup()
    tdg.setup(wdg.get_num_of_wds())
    edg.setup()

    # Set the non working days.
    tdg.set_days(wdg.create_days_for_doc())

    os.environ["QT_QUICK_BACKEND"] = "software"

    url = QUrl(os.path.join(application_path, "MainWindow.qml"))
    app = QApplication(sys.argv)
    app.setWindowIcon(QIcon(conf.logo_path));
    engine = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.rootContext().setContextProperty("WDG", wdg)
    engine.rootContext().setContextProperty("TDG", tdg)
    engine.rootContext().setContextProperty("CONF", conf)
    engine.rootContext().setContextProperty("EXP", exph)
    engine.rootContext().setContextProperty("EDG", edg)
    engine.rootContext().setContextProperty("EFS", efs)
    engine.load(url)

    # Send the working days to QML side.
    wdg.send_working_days()

    app.exec()


if __name__ == "__main__":
    main()
