view: user_360 {
  derived_table: {
    sql: SELECT
          user_id AS userID
        , SUM(sale_price) AS totalRevenue
        , COUNT(DISTINCT order_id) AS totalOrders
        , MIN(created_at) AS firstOrderPlaced
        , MAX(created_at) AS lastOrderPlaced
      FROM `sourabhjainceanalytics.ecomm.order_items`
      GROUP BY
        user_id
       ;;

      #datagroup_trigger: ecomm_dg
      sql_trigger_value: SELECT EXTRACT(MINUTE FROM CURRENT_TIMESTAMP()) ;;
    }

    dimension: userID {
      primary_key: yes
      type: number
      sql: ${TABLE}.userID ;;
      hidden: yes
    }

#### Date dimensions ####
    dimension_group: firstOrderPlaced {
      description: "First Customer Order"
      type: time
      sql: ${TABLE}.firstOrderPlaced ;;
    }

    dimension_group: lastOrderPlaced {
      description: "Latest Customer Order"
      type: time
      sql: ${TABLE}.lastOrderPlaced ;;
    }

    dimension: daysSinceLastOrder {
      description: "Number of days between first and last order"
      type: duration_day
      sql_start: ${firstOrderPlaced_raw};;
      sql_end: CURRENT_DATE ;;
    }

#### Overall Orders Measures ####

    measure: totalSpend {
      description: "Total Spend by Customers"
      type: sum
      value_format_name: usd
      sql: totalRevenue ;;
      drill_fields: [detail*]
    }

    measure: totalOrdersPlaced {
      description: "Total orders placed by the customer"
      type: sum
      value_format_name: decimal_0
      sql: totalOrders ;;
      drill_fields: [detail*]
    }

#### Drill field set ####
    set: detail {
      fields: [userID, order_items.order_id, order_items.status, order_items.total_revenue, order_items.total_gross_margin, order_items.order_item_count]
    }
}
