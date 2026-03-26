# GA4 E-commerce Funnel & User Behavior Analysis (BigQuery)

## Project Overview

This project analyzes user behavior and conversion performance using Google Analytics 4 (GA4) event-level data in BigQuery.

It focuses on funnel analysis, session behavior, engagement metrics, and landing page performance to understand how users move through the product and what drives conversions.

---

## Data Source

* Google BigQuery
* Dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`

---

## Analysis Tasks

### 1. Event-Level Data Extraction

Extract key fields from GA4 event data:

* session_id (via `UNNEST(event_params)`)
* user_pseudo_id
* event_name
* device, country, traffic source

File: `01_event_extraction.sql`

---

### 2. Funnel Analysis

Build a session-level funnel:

* session_start → add_to_cart → begin_checkout → purchase

Calculate conversion rates:

* visit → cart
* visit → checkout
* visit → purchase

File: `02_funnel_analysis.sql`

---

### 3. Landing Page Analysis

Analyze landing page performance:

* extract landing page path using regex
* calculate:

  * number of sessions
  * number of purchases
  * conversion rate

File: `03_landing_page_analysis.sql`

---

### 4. Engagement & Purchase Correlation

Evaluate relationship between engagement and conversion:

* session_engaged vs purchase
* engagement_time vs purchase

Uses correlation analysis to measure impact.

File: `04_engagement_correlation.sql`

---

## SQL Highlights

* `UNNEST(event_params)` for GA4 nested data
* session-level aggregation
* funnel conversion logic
* regex extraction for URLs
* `SAFE_DIVIDE` for safe calculations
* `CORR()` for statistical analysis

---

## Tools Used

* Google BigQuery
* SQL

---

## Key Insights

* Not all sessions lead to meaningful engagement, and engagement level impacts conversion likelihood
* Funnel drop-offs highlight critical stages where users abandon the process
* Landing page performance varies significantly, affecting overall conversion rates

---

## Conclusion

This project demonstrates how GA4 event-level data can be transformed into meaningful insights using BigQuery, enabling product and marketing teams to understand user behavior, optimize funnels, and improve conversion performance.

## Improvements (Assignment Changes)

- Improved session counting using DISTINCT logic  
- Fixed data type issues using explicit casting  
- Enhanced attribution accuracy using session-level joins  
- Expanded analysis across multiple dates using wildcard tables  
