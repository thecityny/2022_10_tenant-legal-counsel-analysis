# NYC Evictions and Right to Counsel Analysis
A repository of SQL queries analyzing legal representation rate in housing court for tenants facing eviction

## About

The NYC eviction case data came from the NYS Office of Court Administration via the Housing Data Coalition. The Association for Neighborhood and Housing Development (ANHD) analyzed the data in collaboration with the Right to Counsel Coalition. THE CITY verified the analyses and made modifications to match the editorial needs of this article. 

Eviction case data referenced in the article represents residential Holdover and Non-Payment cases filed at any New York City-based court. Cases where defendants did not appear in court, or appeared less than a week before this article was published, were excluded from the analyses. Cases with partial representation—where any named defendant had counsel—were counted as a case receiving legal counsel. Due to reporting lags, cases filed within the last four weeks since this article was published were also excluded from the analyses.

Note that the raw data on eviction case filings *updates weekly*—this project gathered this data during the week of October 24th, 2022.

## Accesing the Raw Data

### Option 1: Creating a local copy of the [nycdb database](https://github.com/nycdb/nycdb). 

[nycdb](https://github.com/nycdb/nycdb) is a community-maintained PostgreSQL database of NYC housing data, which includes legal case filings data from the Office of Court Administration (OCA). 

For instructions on how to set up a local copy of this database, see [the nycdb README](https://github.com/nycdb/nycdb/blob/main/src/README.md). 

For instructions on how to load OCA data into your local database, see [this explainer](https://github.com/housing-data-coalition/oca). This page also includes data documentation.

Note that all nycdb's database files are licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode), and that the OCA data specifically has [additional attribution requirements](https://github.com/housing-data-coalition/oca/blob/master/README.md).

### Option 2: Downloading the OCA data manually

See [this Github repository](https://github.com/housing-data-coalition/oca) to download NYC Housing Court Filings data manually as CSVs. You will need to host this data in your own PostgreSQL database to run the SQL queries in this repository.

## Running the SQL queries

The queries in this repository rely on three tables provided by OCA: `oca_appearances`, `oca_index`, and `oca_parties`. 

-  [cases_by_week.sql](https://github.com/thecityny/2022_10_tenant-legal-counsel-analysis/blob/main/cases_by_week.sql) refers to the data for the [weekly case representation visualization](https://datawrapper.dwcdn.net/vZPhu/2/).

-  [cases_by_zipcode.sql](https://github.com/thecityny/2022_10_tenant-legal-counsel-analysis/blob/main/cases_by_zipcode.sql) refers to the data for the [map of legal representation](https://datawrapper.dwcdn.net/e734v/5/).

-  [all_eviction_cases_since_2020.sql](https://github.com/thecityny/2022_10_tenant-legal-counsel-analysis/blob/main/all_eviction_cases_since_2020.sql) refers to the data for the [cumulative chart of case filings](https://datawrapper.dwcdn.net/EPbHT/1/). 

If you have a local copy of nycdb set up on your computer, you can run each sql query in this repository right inside your nycdb query shell. Otherwise, you will have to run it in whatever custom PostgreSQL configuration you've set up, making sure that the table names are consistent with the three listed above. 

