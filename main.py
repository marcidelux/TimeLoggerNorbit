import sys

from PyQt6.QtQml import QQmlApplicationEngine
from PyQt6.QtWidgets import QApplication
from PyQt6.QtCore import QUrl

from m_calendar.w_day_gen import WorkingDayGenerator
from m_doc_generator.doc_gen import TimeDocGenerator
from m_config.config import conf

def main():
    print("Starting app")

    wdg = WorkingDayGenerator()
    tdg = TimeDocGenerator(f_name="Marton", l_name="Lorinczi", job_title="Programmer")

    # Loads all necesary information.
    wdg.setup()
    tdg.setup()

    # Set the non working days.
    tdg.set_days(wdg.create_days_for_doc())

    url         = QUrl("MainWindow.qml")
    app         = QApplication(sys.argv)
    engine      = QQmlApplicationEngine()
    engine.quit.connect(app.quit)
    engine.rootContext().setContextProperty("WDG", wdg)
    engine.rootContext().setContextProperty("TDG", tdg)
    engine.rootContext().setContextProperty("CONF", conf)
    engine.load(url)
    
    # Send the working days to QML side.
    wdg.send_working_days()

    app.exec()

if __name__ == '__main__':
    main()
