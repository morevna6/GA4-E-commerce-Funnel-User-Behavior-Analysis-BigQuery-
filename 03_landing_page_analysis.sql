with base as (
  select
    timestamp_micros(event_timestamp) as event_ts,
    user_pseudo_id,
    (select value.int_value
     from unnest(event_params)
     where key = 'ga_session_id') as session_id,
    event_name,
    (select value.string_value
     from unnest(event_params)
     where key = 'page_location') as page_location
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201231`
  where event_name in ('session_start', 'purchase')
),
sessions as (
  select
    user_pseudo_id,
    session_id,
    any_value(
      if(
        event_name = 'session_start',
        regexp_extract(page_location, r'https?://[^/]+(/[^?]*)'),
        null
      )
    ) as landing_page_path,
    max(if(event_name = 'purchase', 1, 0)) as has_purchase
  from base
  group by user_pseudo_id, session_id
)
select
  landing_page_path,
  count(*) as user_sessions_count,
  sum(has_purchase) as purchases,
  safe_divide(sum(has_purchase), count(*)) as visit_to_purchase
from sessions
where landing_page_path is not null
group by landing_page_path
order by user_sessions_count desc;
