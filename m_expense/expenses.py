import requests
from datetime import datetime
from m_config.config import conf


def get_exchange_rate(day:int, cur:str):
    date_str = datetime(year=conf.now.year, month=conf.now.month, day=day).strftime("%Y-%m-%d")
    host = f"https://www.frankfurter.app/{date_str}"
    exParams = {
        "amount": 1,
        "from": cur,
        "to": "HUF"
    }
    r = requests.get(url=host, params=exParams)
    if r.status_code != 200:
        print("Curency api call fail")
    
    data = r.json()
    rate = data["rates"]["HUF"]
    print(rate)

def test():
    get_exchange_rate(10, "NOK")

def main():
    test()

if __name__ == "__main__":
    main()