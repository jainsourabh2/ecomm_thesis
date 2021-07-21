view: order_items {
  sql_table_name: `ecomm.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    label: "orderItemsID"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    label: "SalesPrice"
    description: "Sales Price for the order"
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: delivered_at {
    label: "delvered_date"
    type: string
    description: "Date on which the order was delivered"
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: status {
    label: "delivery_status"
    type: string
    description: "Overall Status of the order"
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    description: "User ID of the user"
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
    link: {
      label: "Analyze Trend"
      url: "
      {% assign vis_config = '{
      \"stacking\" : \"\",
      \"show_value_labels\" : false,
      \"label_density\" : 25,
      \"legend_position\" : \"center\",
      \"x_axis_gridlines\" : true,
      \"y_axis_gridlines\" : true,
      \"show_view_names\" : false,
      \"limit_displayed_rows\" : false,
      \"y_axis_combined\" : true,
      \"show_y_axis_labels\" : true,
      \"show_y_axis_ticks\" : true,
      \"y_axis_tick_density\" : \"default\",
      \"y_axis_tick_density_custom\": 5,
      \"show_x_axis_label\" : false,
      \"show_x_axis_ticks\" : true,
      \"x_axis_scale\" : \"auto\",
      \"y_axis_scale_mode\" : \"linear\",
      \"show_null_points\" : true,
      \"point_style\" : \"circle\",
      \"ordering\" : \"none\",
      \"show_null_labels\" : false,
      \"show_totals_labels\" : false,
      \"show_silhouette\" : false,
      \"totals_color\" : \"#808080\",
      \"type\" : \"looker_line\",
      \"interpolation\" : \"linear\",
      \"series_types\" : {},
      \"colors\": [
      \"palette: Santa Cruz\"
      ],
      \"series_colors\" : {},
      \"x_axis_datetime_tick_count\": null,
      \"trend_lines\": [
      {
      \"color\" : \"#000000\",
      \"label_position\" : \"left\",
      \"regression_type\" : \"average\",
      \"series_index\" : 1,
      \"show_label\" : true,
      \"label_type\" : \"string\",
      \"label\" : \"30 day moving average\"
      }
      ]
      }' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000"
    }
  }

  measure: pending_orders {
    type:count
    filters: [delivered_at: "NULL"]
  }

  dimension: pending_orders_X_days {
    type: yesno
    view_label: "Pending Orders Since Last X Days"
    sql: TIMESTAMP_DIFF(${created_date},CURRENT_DATE, DAY) ;;
  }

  dimension: pending_orders_30_days {
    type: yesno
    view_label: "Pending Orders Since Last X Days"
    sql: ${pending_orders_X_days} < -30 ;;
  }

  measure: count_of_pending_orders_30_days {
    type: count
    #sql: ${id} ;;
    view_label: "Pending Orders Since Last X Days"
    filters: [pending_orders_30_days: "Yes",delivered_at : "NULL"]
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.email,
      created_date,
      inventory_items.product_name,
      sale_price
    ]
  }
}
