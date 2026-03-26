with base as (
  select
    user_pseudo_id,
    (select ep.value.int_value
     from unnest(event_params) ep
     where ep.key = 'ga_session_id') as session_id,
    event_name,
    (select ep.value.string_value
     from unnest(event_params) ep
     where ep.key = 'page_location') as page_location
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where
    _TABLE_SUFFIX between '20200101' and '20201231'
    and event_name in ('session_start', 'purchase')
),
sessions as (
  select
    user_pseudo_id,
    session_id,
    max(
      if(
        event_name = 'session_start',
        regexp_extract(page_location, r'https?://[^/]+(/[^?]*)'),
        null
      )
    ) as landing_page_path,
    max(if(event_name = 'purchase', 1, 0)) as has_purchase
  from base
  where session_id is not null
  group by user_pseudo_id, session_id
)
select
  landing_page_path,
  count(
    distinct concat(user_pseudo_id, '-', cast(session_id as string))
  ) as user_sessions_count,
  count(
    distinct if(
      has_purchase = 1,
      concat(user_pseudo_id, '-', cast(session_id as string)),
      NULL
    )
  ) as purchases,
  safe_divide(
    count(
      distinct if(
        has_purchase = 1,
        concat(user_pseudo_id, '-', cast(session_id as string)),
        null
      )
    ),
    count(
      distinct concat(user_pseudo_id, '-', cast(session_id as string))
    )
  ) AS visit_to_purchase
from sessions
where landing_page_path is not null
group by landing_page_path
order by user_sessions_count DESC;
