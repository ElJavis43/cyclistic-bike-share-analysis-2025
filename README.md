# Cyclistic 2025 | Bike-Share Rider Behavior Analysis

**Google Data Analytics Capstone Case Study | SQL · BigQuery · Tableau · Data Quality**

## 1. Project Overview

This project analyzes **5,545,493 validated bike-share trips** recorded during 2025 in the Divvy dataset, using the fictional Cyclistic business scenario from the Google Data Analytics case study. The objective is to understand how annual members and casual riders use bikes differently and translate the findings into **testable marketing recommendations**.

The analysis covers the complete 2025 calendar year, with trip times interpreted in the `America/Chicago` time zone. It is a trip-level analysis, **not** an analysis of distinct customers.

## 2. Business Problem

**Primary business question:**

> How do annual members and casual riders use Cyclistic bikes differently?

**Business context:** The marketing team wants to identify opportunities to encourage casual riders to purchase annual memberships. Before designing campaigns, it needs evidence about the differences in riding behavior between the two groups.

**Analytical objective:** Compare trip volume, duration, weekday versus weekend behavior, seasonality, hourly activity, and bicycle preferences, then recommend initiatives that can be evaluated through controlled marketing tests.

## 3. Tools and Skills

- **Google Cloud Storage:** Storage of the 12 original monthly CSV files before ingestion.
- **Google BigQuery / Standard SQL:** Data preparation, validation, time-zone handling, feature engineering, aggregation, and exploratory analysis.
- **Tableau Public:** Interactive visualization of rider behavior.
- **Excel:** Data-quality report documenting the cleaning process and validation outcomes.
- **GitHub:** Reproducible SQL scripts, documentation, and project presentation.

## 4. Data Source and Scope

- **Dataset:** Divvy bike-share trip records, January–December 2025, analyzed under the Cyclistic case-study framework.
- **Input:** 12 monthly CSV files loaded into `cyclistic_2025.trips_raw` in BigQuery.
- **Raw observations:** 5,552,994 trips.
- **Final analytical dataset:** `cyclistic_2025.trips_portfolio_clean`, containing 5,545,493 trips.
- **Unit of analysis:** Individual recorded trip (`ride_id`), not unique rider.

The source CSV files are **not included** in this repository because of their size. To reproduce the project, obtain the relevant original monthly Divvy trip files and load them into the expected raw table.

## 5. Data Cleaning and Validation

The cleaning process was implemented in SQL directly from the raw data, rather than relying on manually edited spreadsheets.

### Cleaning methodology

1. Parse the original trip start and end strings as local `DATETIME` values.
2. Convert these values to timestamps using `America/Chicago`.
3. Calculate trip duration in minutes from the converted timestamps.
4. Exclude trips shorter than **one second** or longer than **24 hours**.
5. Retain only trips starting within the **2025 Chicago local calendar year**.
6. Create analysis variables: hour of day, day of week, day name, month, year, and weekday/weekend classification.
7. Validate record counts, unique trip IDs, durations, and derived time variables.

### Data quality summary

| Metric | Result |
|---|---:|
| Original records | 5,552,994 |
| Validated records | 5,545,493 |
| Excluded records | 7,501 |
| Retention rate | 99.865% |
| Unique trip IDs in final dataset | 5,545,493 |
| Duplicate trip IDs in final dataset | 0 |
| Average trip duration in final dataset | 14.53 minutes |
| Invalid original start/end date strings | 0 |

The raw-data audit identified **1,837 trips shorter than one second**, **5,611 trips longer than 24 hours**, and **53 trips starting outside the 2025 local calendar year**. These are audit counts by condition; the definitive number excluded is calculated as the difference between the raw and final dataset sizes.

The final table was independently compared with the previously developed `trips_final_corrected` table. The checks found **no differences** in the set of `ride_id` values or in trip duration, ride hour, day of week, month, and weekday/weekend classification.

A separate workbook, [`data/data_quality_report.xlsx`](data/data_quality_report.xlsx), presents the cleaning summary, validation checks, and methodology in an accessible format.

## 6. Exploratory Data Analysis

### Member versus casual trips

| Indicator | Casual riders | Annual members |
|---|---:|---:|
| Recorded trips | 1,993,959 | 3,551,534 |
| Share of total trips | 35.96% | 64.04% |
| Average trip duration | 19.12 min | 11.95 min |
| Median trip duration | 11.38 min | 8.58 min |
| Weekday trips | 1,250,263 | 2,719,553 |
| Weekend trips | 743,696 | 831,981 |
| Weekend share within group | 37.30% | 23.43% |

**Trip frequency:** Annual members account for the majority of recorded rides (64.04%). This measures the share of trips, not the share of unique customers.

**Trip duration:** Casual rides average **19.12 minutes**, compared with **11.95 minutes** for member rides. Casual trips are therefore approximately **60% longer on average**.

**Weekly patterns:** Weekend rides represent **37.30%** of casual trips but only **23.43%** of member trips. Member rides are more concentrated on weekdays.

**Seasonality:** Casual riding is especially prominent during summer, particularly **June through August**. This pattern suggests that seasonality should be considered when timing marketing experiments.

**Bike preferences:** Both groups use classic and electric bikes. The aggregate analysis also includes bike-type comparisons; these counts are available through `sql/04_tableau_exports.sql` and the Tableau dashboard.

**Hourly patterns:** The dashboard contains a heatmap comparing trip activity by hour, user type, and weekday/weekend classification, supporting further investigation of different usage windows.

## 7. Answer to the Business Question

> **How do annual members and casual riders use Cyclistic bikes differently?**

Annual members generate more rides overall and show a stronger weekday-oriented pattern. They account for **64.04% of trips**, with an average trip duration of **11.95 minutes**. In contrast, casual riders account for **35.96% of trips**, take longer rides (**19.12 minutes on average**), and have a substantially larger share of weekend activity (**37.30% versus 23.43% for members**). Casual activity also becomes more prominent during the summer months.

**Business interpretation:** These differences are consistent with members using bikes more regularly during the workweek and casual riders showing more seasonal and weekend-oriented behavior. However, the dataset does **not** identify the purpose of a trip. Commuting, tourism, and recreation are plausible explanations, **not verified conclusions**.

**Business opportunity:** Cyclistic could test membership messaging among casual riders during high-activity seasons and weekends. The goal would be to learn whether campaigns can convert interested casual riders into annual members, rather than assume that trip patterns alone prove conversion potential.

## 8. Business Recommendations

The following recommendations are **hypotheses to test**, not causal conclusions from the observational trip data.

### Recommendation 1 — Seasonal membership campaigns

Pilot targeted annual-membership messaging before and during the peak casual-riding season, particularly late spring and summer. Test whether messaging about membership convenience and potential value performs better than a control campaign.

### Recommendation 2 — Weekend-focused outreach

Experiment with campaigns delivered through appropriate customer touchpoints during periods of high casual weekend activity. Tailor the message to riders who may benefit from more frequent use, without assuming every weekend rider is a prospective member.

### Recommendation 3 — Measure conversion and business impact

Evaluate pilots using customer-level data and clearly defined metrics, including:

- **Membership conversion rate:** Eligible casual riders who purchase an annual membership.
- **Incremental memberships:** Conversions attributable to the campaign compared with a control group.
- **Customer acquisition cost:** Campaign spending divided by incremental new members.
- **Retention and repeat usage:** Whether newly converted members continue using the service.
- **Incremental revenue and profitability:** Whether the campaign produces positive financial value.

**Suggested next step:** Obtain anonymized customer-level and campaign data, define eligible audiences, and run a controlled experiment before scaling any initiative.

## 9. Tableau Dashboard

The Tableau Public dashboard presents the core comparisons through five visualizations and three summary KPIs:

1. Monthly trip trends by membership type.
2. Weekly trip patterns by membership type.
3. Average trip duration by membership type.
4. Classic versus electric bike preferences.
5. Hourly activity heatmap, segmented by rider and day type.

**Live dashboard:*  [ https://public.tableau.com/views/WeeklyRidesbyRiderType/Cyclistic2025Dashboard?:language=es-ES&:sid=&:display_count=n&:origin=viz_share_link ]
## 10. Repository Structure

```text
Cyclistic_2025/
├── README.md
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_data_validation.sql
│   ├── 03_exploratory_analysis.sql
│   └── 04_tableau_exports.sql
├── data/
│   ├── data_quality_report.xlsx
│   └── aggregated_csv/
│       ├── 01_resumen_usuarios.csv          # Add locally
│       ├── 02_analisis_mensual.csv          # Add locally
│       ├── 03_analisis_semanal.csv          # Add locally
│       ├── 04_analisis_horario.csv          # Add locally
│       └── 05_tipos_bicicleta.csv          # Add locally
├── dashboard/
│   ├── dashboard_preview.png               # Add locally
│   └── Cyclistic_2025_Dashboard.twbx       # Add locally, if available
└── original_sql/
    └── ...                                 # Archived development queries
```

The five CSVs and Tableau assets are **not bundled in the starter package**; add your exported files before publishing. The `original_sql` folder is retained for development history; use the numbered scripts in `sql/` for the reproducible workflow.

## 11. Reproducing the Analysis

1. Create a BigQuery dataset named `cyclistic_2025` (or adapt the dataset references in the scripts).
2. Download the 12 original monthly 2025 trip CSV files and ingest them into `cyclistic_2025.trips_raw`. The ingestion process itself is not automated in this repository.
3. Run `sql/01_data_cleaning.sql` to create `trips_portfolio_clean`.
4. Run `sql/02_data_validation.sql` to inspect data quality. The optional comparison against `trips_final_corrected` requires that older table to exist.
5. Run the queries in `sql/03_exploratory_analysis.sql` to reproduce the descriptive findings.
6. Run each query in `sql/04_tableau_exports.sql`, export the results to CSV, and use them as Tableau data sources.
7. Rebuild or inspect the Tableau dashboard and compare the displayed results with the tables above.

**Environment note:** BigQuery references such as `cyclistic_2025.trips_raw` assume an appropriate default Google Cloud project. Update table references if your project or dataset differs. The SQL scripts assume the raw table already contains the expected Divvy columns and date-string formats.

## 12. Limitations

- **Trip-level observations:** A rider may make multiple trips. The data cannot measure distinct customers, individual riding frequency, or actual membership conversion.
- **Unknown travel purpose:** Weekday and weekend patterns do not prove commuting, recreation, or tourism.
- **Missing location information:** Some station fields and end coordinates are missing. The cleaned Tableau-oriented dataset had **134 missing end latitudes and 134 missing end longitudes**; geographic analysis requires additional checks.
- **Daylight-saving ambiguity:** Source date-time strings lack an explicit UTC offset. During Chicago's autumn clock change, repeated local times cannot always be uniquely resolved.
- **Observational analysis:** The patterns describe associations, not the causal effects of membership or marketing campaigns.
- **Case-study framing:** The analysis uses actual Divvy trip records under the fictional Cyclistic scenario; it does not claim to represent independently verified Cyclistic company transactions.
- **Data availability:** Original raw CSV files are not stored in this repository. Reproduction requires obtaining the source data separately.

## 13. Conclusion

The 2025 trip data reveal clear behavioral differences between casual riders and annual members. Members generate more trips and have a stronger weekday-oriented pattern, while casual riders take longer trips and have a higher concentration of weekend activity, especially during summer.

These findings provide a reasonable basis for **testing** seasonal and weekend membership campaigns. To establish whether such campaigns actually increase membership and profitability, Cyclistic would need customer-level data and controlled experimentation.

This case study demonstrates an end-to-end analytical workflow: **data ingestion, SQL cleaning, quality validation, exploratory analysis, dashboarding, and actionable business communication**.
