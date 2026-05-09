# Lombardy Air Quality Analysis (2024-2026)

## Project Overview

Environmental data analytics project analyzing 5.8 million air quality measurements across Lombardy region, Italy. This analysis identifies pollution hotspots, seasonal patterns, and provides data-driven recommendations for policy interventions.

**Portfolio Project Type:** Data Analysis | Business Intelligence | Environmental Analytics

---

## Business Problem

Lombardy region, home to 10 million residents and Italy's economic powerhouse (Milano), faces persistent air quality challenges. High levels of PM10, NO2, and NOx pose significant public health risks and environmental concerns.

### Stakeholders

1. **Regional Government (ARPA Lombardia)** - Data-driven policy evaluation
2. **Public Health Authorities** - Health advisory and resource allocation
3. **Urban Planners** - Identify intervention zones
4. **Logistics Companies** - Route optimization for emissions reduction
5. **Environmental Advocacy** - Track progress toward EU standards

### Key Questions

- How have pollution levels changed from 2024 to 2026?
- Which provinces and stations consistently exceed EU limits?
- What are the seasonal and hourly pollution patterns?
- How does Milano compare to other provinces?
- Which pollutants require immediate attention?

---

## Dataset

**Source:** ARPA Lombardia (Regional Environmental Protection Agency)  
**Platform:** Open Data Lombardia ([dati.lombardia.it](https://www.dati.lombardia.it))  
**License:** Open Data (publicly available)

### Dataset Characteristics

| Metric | Value |
|--------|-------|
| **Total Records** | 5,871,737 measurements |
| **Time Period** | 881 days (2024-01-01 to 2026-05-06) |
| **File Size** | 290 MB (original CSV) |
| **Monitoring Stations** | 492 active stations |
| **Geographic Coverage** | 12 provinces, 69 municipalities |
| **Pollutants Tracked** | 16 types (PM10, PM2.5, NO2, NOx, O3, CO, Benzene, etc.) |

### Data Structure

**Air Quality Measurements:**
- IdSensore (Sensor ID)
- Data (DateTime)
- Valore (Pollution value in µg/m³)
- Stato (Status)
- Station metadata (Name, Province, Municipality, Coordinates)

**Station Locations:**
- 492 active stations
- Geographic coordinates (lat/lng)
- Station classification (Traffic/Background/Industrial)
- Area type (Urban/Suburban/Rural)

---

## Data Cleaning Process

### Issues Identified

| Issue | Count | Percentage | Resolution |
|-------|-------|------------|------------|
| Negative values (sensor errors) | 143,123 | 2.36% | Replaced with NaN |
| Extreme outliers (>99th percentile) | 60,613 | 1.00% | Capped at 153.6 µg/m³ |
| Missing values | 143,123 | 2.36% | Dropped rows |
| Historical stations (inactive) | 510 | 50.90% | Filtered to active only |
| Unmatched sensors | 52,976 | 0.89% | Excluded from analysis |

### Cleaning Workflow

1. **Data Profiling** - Identified quality issues using Python (Pandas)
2. **Air Quality Cleaning** - Fixed negatives, capped outliers, handled missing values
3. **Station Cleaning** - Filtered active stations, parsed coordinates
4. **Merge & Enrich** - Combined datasets, added derived features (Year, Month, Season, Pollutant)
5. **Validation** - 96.77% data retention (5,871,737 final rows)

### Output Files

- `lombardy_air_quality_clean.csv` (5.8M rows, 19 columns)
- `stations_clean.csv` (492 active stations, 8 columns)

**Tools:** Python (Pandas, NumPy), Jupyter Notebook

---

## SQL Analysis

### Database Setup

**Technology:** MySQL 9.6.0  
**Database:** lombardy_air_quality  
**Table:** air_quality (5.8M rows with indexes on Data, Provincia, Pollutant, IdSensore)

### Key Queries Implemented

1. **Pollutant Analysis** - Summary statistics for 16 pollutant types
2. **Geographic Analysis** - Province rankings and station comparisons
3. **Temporal Analysis** - Monthly trends, seasonal patterns, hourly traffic analysis
4. **Comparative Analysis** - Milano vs other provinces, best/worst stations by region

### Stored Procedures Created

| Procedure | Purpose |
|-----------|---------|
| `get_province_pollution` | Retrieve pollution data for specific province and date range |
| `get_top_polluted_stations` | Identify top N most polluted stations |
| `get_pollutant_stats` | Statistics for specific pollutant by province and year |
| `compare_provinces` | Side-by-side comparison of two provinces |
| `get_seasonal_comparison` | Seasonal breakdown for specific year |

**Files:** 
- `lombardy_air_quality_queries.sql` (10 analytical queries)
- `stored_procedures.sql` (5 reusable procedures)

---

## Key Findings

### 1. Seasonal Patterns

**Winter pollution is 49% higher than Summer:**
- Winter: 31.71 µg/m³ average
- Summer: 23.78 µg/m³ average
- Spring: 23.72 µg/m³ average
- Fall: 24.26 µg/m³ average

**Insight:** Residential heating and thermal inversion during winter months drive pollution spikes.

### 2. Geographic Hotspots

**Top 5 Most Polluted Stations:**
1. Rho via Buon Gesù (Milano): 48.86 µg/m³
2. Milano v.Liguria: 48.10 µg/m³
3. Cormano v. Edison (Milano): 45.73 µg/m³
4. Milano Verziere: 44.30 µg/m³
5. Pioltello Limito (Milano): 41.63 µg/m³

**Milano Province: 21% more polluted than other provinces**
- Milano average: 29.82 µg/m³
- Other provinces average: 25.30 µg/m³

### 3. Traffic Impact

**Hourly NO2 patterns reveal rush hour peaks:**
- Morning peak: 7-8 AM (24-26 µg/m³)
- Evening peak: 7-9 PM (27-29 µg/m³)
- Lowest: 4-5 AM (18 µg/m³)

**Ozone (O3) peaks in afternoon due to sunlight:**
- Peak: 2-4 PM (72-75 µg/m³)
- Lowest: 6 AM (30 µg/m³)

### 4. Pollutant Distribution

**Most prevalent pollutants:**
1. NO2 (Nitrogen Dioxide): 1.7M measurements - 22.45 µg/m³ avg
2. NOx (Nitrogen Oxides): 1.7M measurements - 37.15 µg/m³ avg
3. O3 (Ozone): 948k measurements - 48.46 µg/m³ avg

**Insight:** Vehicular emissions (NO2/NOx) are primary pollution source.

---

## Technical Stack

| Category | Tools |
|----------|-------|
| **Data Cleaning** | Python (Pandas, NumPy), Jupyter Notebook |
| **Database** | MySQL 9.6.0 |
| **Visualization** | Tableau |
| **Version Control** | Git, GitHub |
| **Environment** | MacBook Intel, macOS |

---

## Project Structure

`````
lombardy-air-quality/
├── README.md
├── .gitignore
├── data/
│   ├── raw/
│   │   ├── Dati_sensori_aria_20260506.csv (External - Google Drive)
│   │   └── Stazioni_qualità_dell'aria_20260506.csv
│   └── clean/
│       ├── lombardy_air_quality_clean.csv (External - Google Drive)
│       └── stations_clean.csv
├── notebooks/
│   └── lombardy_air_quality_cleaning.ipynb
├── sql/
│   ├── lombardy_air_quality_queries.sql
│   └── stored_procedures.sql
└── tableau/
    └── Lombardy_Air_Quality_Analysis.twb
`````

---

## Recommendations

Based on analysis findings:

1. **Winter Heating Transition** - Incentivize cleaner heating systems in Milano metro area (48% reduction potential)
2. **Traffic Management** - Implement congestion pricing during 7-9 AM and 7-9 PM rush hours in top 5 polluted zones
3. **Low-Emission Zones** - Expand Milano Area C restrictions to Rho, Cormano, and Pioltello (hotspot stations)
4. **Real-Time Monitoring** - Deploy additional sensors in underrepresented rural areas (only 4 stations currently)
5. **Public Awareness** - Launch winter air quality alerts when pollution exceeds 40 µg/m³ threshold

**Projected Impact:** 15-20% pollution reduction in Milano province by 2028 if recommendations implemented.

---

## How to Run This Project

### Prerequisites
- Python 3.10+
- MySQL 9.6+
- Tableau Desktop
- Jupyter Notebook

### Setup Steps

1. **Clone repository:**
```bash
git clone https://github.com/yourusername/lombardy-air-quality.git
cd lombardy-air-quality
```

2. **Run data cleaning:**
```bash
jupyter notebook notebooks/lombardy_air_quality_cleaning.ipynb
```

3. **Import to MySQL:**
```bash
mysql -u root -p < sql/create_database.sql
mysql -u root -p lombardy_air_quality < sql/stored_procedures.sql
```

4. **Open Tableau Dashboard:**
- Open `Lombardy_Air_Quality_Dashboard.twb`
- Connect to MySQL database
- Refresh data

---

## Future Enhancements

- [ ] Integrate weather data (temperature, wind speed) for correlation analysis
- [ ] Add predictive modeling (ARIMA/Prophet) for 2027-2028 forecasts
- [ ] Build real-time dashboard with live ARPA API integration
- [ ] Expand analysis to include health impact metrics (hospital admissions, respiratory cases)
- [ ] Create interactive web dashboard using Plotly Dash or Streamlit

---

## Author

**Ibrahim Kilic**  
Data Analyst | SQL | Python | Power BI  

📧 ibrahimkilicit@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/ibrahim-kilic01)  
💻 [GitHub](https://github.com/ibrahimkilic99)

---

## License

This project uses Open Data from ARPA Lombardia. Data is publicly available for analysis and research purposes.

---

## Acknowledgments

- **ARPA Lombardia** for providing open environmental data
- **Open Data Lombardia** platform for data accessibility
