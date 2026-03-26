# GA4 E-commerce Funnel & User Behavior Analysis (BigQuery)

## Project Overview
This project analyzes user behavior and conversion performance using Google Analytics 4 (GA4) event-level data in BigQuery.

It focuses on funnel analysis, session behavior, engagement metrics, and landing page performance.

---

## Data Source
- Google BigQuery  
- Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

---

## Analysis Tasks

### 1. Event-Level Data Extraction
- Extract session_id using `UNNEST(event_params)`
- Retrieve event-level attributes such as:
  - event_name
  - country
  - device category
  - traffic source

---

### 2. Funnel Analysis
- session_start → add_to_cart → begin_checkout → purchase  
- Calculate conversion rates:
  - visit → cart  
  - visit → checkout  
  - visit → purchase  

(Your funnel query burada 👇)  
:contentReference[oaicite:0]{index=0}

---

### 3. Landing Page Performance
- Extract landing page path using regex  
- Analyze:
  - sessions per page  
  - purchases  
  - conversion rate  

:contentReference[oaicite:1]{index=1}

---

### 4. Engagement & Purchase Correlation
- Analyze relationship between:
  - session engagement  
  - engagement time  
  - purchase behavior  

:contentReference[oaicite:2]{index=2}

---

### 5. Event Dataset Exploration
- Build structured event dataset with:
  - session_id  
  - device  
  - source / medium / campaign  

:contentReference[oaicite:3]{index=3}

---

## SQL Highlights
- `UNNEST(event_params)` for GA4 structure  
- session-level aggregation  
- funnel conversion logic  
- regex extraction for URLs  
- window-independent behavioral analysis  
- correlation analysis  

---

## Tools Used
- Google BigQuery
- SQL

---

## Conclusion
This project demonstrates how GA4 event-level data can be transformed into meaningful insights, including funnel performance, user engagement behavior, and landing page effectiveness.
