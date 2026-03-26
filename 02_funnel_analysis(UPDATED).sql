with base as (
  select
    timestamp_micros(event_timestamp) as event_ts,
    user_pseudo_id,
    (select value.int_value from unnest (event_params) where key = 'ga_session_id') as session_id,
    event_name,
    traffic_source.source as source,
    traffic_source.medium as medium,
    traffic_source.name as campaign
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  where event_name in ('session_start', 'add_to_cart', 'begin_checkout', 'purchase')
),
sessions as (
  select
    date(min(if(event_name = 'session_start', event_ts, null))) as event_date,
    user_pseudo_id,
    session_id,
    max(if(event_name = 'session_start', source, null)) as source,
    max(IF(event_name = 'session_start', medium, null)) as medium,
    max(if(event_name = 'session_start', campaign, null)) as campaign,
    max(if(event_name = 'add_to_cart', 1, 0)) as has_cart,
    max(if(event_name = 'begin_checkout', 1, 0)) as has_checkout,
    max(if(event_name = 'purchase', 1, 0)) as has_purchase
  from base
  where session_id is not null
  group by user_pseudo_id, session_id
),
agg as (
  select
    event_date,
    source,
    medium,
    campaign,
    count(distinct concat(user_pseudo_id, '-', cast(session_id as string))) as user_sessions_count,
    count(distinct if(has_cart = 1, concat(user_pseudo_id, '-', cast(session_id as string)), null)) as sessions_with_cart,
    count(distinct if(has_checkout = 1, concat(user_pseudo_id, '-', cast(session_id as string)), null)) as sessions_with_checkout,
    count(distinct if(has_purchase = 1, concat(user_pseudo_id, '-', cast(session_id as string)), null)) as sessions_with_purchase
  from sessions
  where event_date is not null
  group by event_date, source, medium, campaign
)
select
  event_date,
  source,
  medium,
  campaign,
  user_sessions_count,
  safe_divide(sessions_with_cart, user_sessions_count) as visit_to_cart,
  safe_divide(sessions_with_checkout, user_sessions_count) as visit_to_checkout,
  safe_divide(sessions_with_purchase, user_sessions_count) as visit_to_purchase
from agg
order by event_date, source, medium, campaign;
