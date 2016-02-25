import requests
from bs4 import BeautifulSoup
url = 'http://dqydj.net/sp-500-return-calculator/'

payload = {'STARTMONTH': '01', 'STARTYEAR': '1984', 'ENDMONTH': '01', 'ENDYEAR': '1985'}

r = requests.post(url=url, data=payload)

r.status_code()

soup = BeautifulSoup(r.content)