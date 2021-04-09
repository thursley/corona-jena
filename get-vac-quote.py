import requests
import pandas

# estimated from rki data
population_th = 2133378
key_th = "DE-TH"

vac_dashboard_url =" https://impfdashboard.de/static/data/germany_vaccinations_by_state.tsv"
vac_count_path = "vac.tsv"

response = requests.get(vac_dashboard_url)
if not response.ok:
    print(f"could not get file at url '{rki_quote_url}'. abort.")
    exit(1)

with open(vac_count_path, 'wb') as f:
    f.write(response.content)

data = pandas.read_csv(vac_count_path, sep='\t')
for index, row in data.iterrows():
    if row[0] == key_th:
        index_th = index
        break

vac_count = data["peopleFirstTotal"].values[index_th] / population_th

print(f"quote for Thüringen: {vac_count}")
