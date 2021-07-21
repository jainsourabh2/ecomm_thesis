view: distribution_centers {
  sql_table_name: `ecomm.distribution_centers`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
    link: {
      label: "Escalate to Supply Manager"
      url: "https://emcedev.cloud.looker.com/dashboards/44?Distribution%20Center%20Name={{ filterable_value | url_encode }}"
      icon_url: "http://google.com/favicon.ico"}
  }

  measure: count {
    type: count
    drill_fields: [id, name, products.count]
  }

  dimension: dc_location {
    type: location
    sql_latitude:latitude ;;
    sql_longitude:longitude ;;
  }

}
