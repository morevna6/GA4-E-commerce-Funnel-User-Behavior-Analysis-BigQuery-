with base as (
  select
    user_pseudo_id,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    event_name,
    (select value.int_value from unnest(event_params) where key = 'session_engaged') as session_engaged,
    (select value.int_value from unnest(event_params) where key = 'engagement_time_msec') as engagement_time_msec
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
),
sessions as (
  select
    user_pseudo_id,
    session_id,
    max(if(session_engaged = 1, 1, 0)) as is_engaged,
    sum(ifnull(engagement_time_msec, 0)) as total_engagement_time_msec,
    max(if(event_name = 'purchase', 1, 0)) as has_purchase
  from base
  where session_id is not null
  group by user_pseudo_id, session_id
)
select
  corr(cast(is_engaged as float64), cast(has_purchase as float64)) as corr_engaged_vs_purchase,
  corr(cast(total_engagement_time_msec as float64), cast(has_purchase as float64)) as corr_time_vs_purchase
from sessions;
