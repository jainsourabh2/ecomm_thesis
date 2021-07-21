connection: "sourabhjain-thesis"

# include all the views
include: "/views/**/*.view"

##### Configuration #####
datagroup: ecomm_dg {
  sql_trigger: SELECT MAX(created_at) FROM  `sourabhjainceanalytics.ecomm.order_items`;;
  max_cache_age: "1 hours"
  label: "New order dates fetched"
  description: "Data group to pich latest orders"
}

persist_with: ecomm_dg

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: CAST(${products.distribution_center_id} AS INT64) = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  #access_filter: {
  #  field: distribution_centers.name
  #  user_attribute: dcname
  #}
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: CAST(${products.distribution_center_id} AS INT64) = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: user_360 {
    view_label: "User360"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${user_360.userID} ;;
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {}
