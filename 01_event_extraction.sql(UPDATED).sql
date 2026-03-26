with base as (
  select
    timestamp_micros(event_timestamp) as event_timestamp,
    user_pseudo_id,
    cast(
      (select ep.value.int_value
       from unnest(event_params) ep
       where ep.key = 'ga_session_id')
      as string
    ) as session_id,
    event_name,
    geo.country as country,
    device.category as device_category,
    traffic_source.source as raw_source,
    traffic_source.medium as raw_medium,
    traffic_source.name as raw_campaign
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  where event_name in (
    'session_start',
    'view_item',
    'add_to_cart',
    'begin_checkout',
    'add_shipping_info',
    'add_payment_info',
    'purchase'
  )
),
session_channel as (
  select
    user_pseudo_id,
    session_id,
    max(if(event_name = 'session_start', raw_source, null)) as source,
    max(if(event_name = 'session_start', raw_medium, null)) as medium,
    max(if(event_name = 'session_start', raw_campaign, null)) as campaign
  from base
  group by 1,2
)
select
  b.event_timestamp,
  b.user_pseudo_id,
  b.session_id,
  b.event_name,
  b.country,
  b.device_category,
  sc.source,
  sc.medium,
  sc.campaign
from base b
left join session_channel sc
  using (user_pseudo_id, session_id)
limit 1000;
