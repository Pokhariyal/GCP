# The name of this view in Looker is "Session Faults"
view: faults {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  derived_table: {
    sql: select ChargerID,ConnecterName,ErrorCode,ErrorDescription,FaultOccurredAt,FWVersion,Severity,ShortDescription from ANALYTICS.error_SESSION where FaultOccurredAt>"1970-01-01";;
  }
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Charger ID" in Explore.

  dimension: charger_id {
    type: string
    sql: ${TABLE}.ChargerID ;;
  }

  dimension: connecter_name {
    type: string
    sql: ${TABLE}.ConnecterName ;;
  }

  dimension: error_code {
    type: number
    sql: ${TABLE}.ErrorCode ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_error_code {
    type: sum
    sql: ${error_code} ;;
  }

  measure: average_error_code {
    type: average
    sql: ${error_code} ;;
  }

  dimension: error_description {
    type: string
    sql: ${TABLE}.ErrorDescription ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: fault_occurred {
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
    sql: ${TABLE}.FaultOccurredAt ;;
  }

  dimension: fw_version {
    type: string
    sql: ${TABLE}.FWVersion ;;
  }

  dimension: ShortDescription {
    type: string
    sql:  REPLACE (${TABLE}.ShortDescription,'\"','');;
  }

  dimension: severity {
    type: string
    sql: ${TABLE}.Severity ;;
    order_by_field: severity_sort
  }

  dimension: severity_sort {
    type: number
    sql:
    CASE
    WHEN  ${severity} = 'Non Critical' THEN 2
    WHEN  ${severity}  = 'Semicritical' THEN 1
    WHEN  ${severity}  = 'Undefined' THEN 3
    ELSE 4
    END;;

    hidden: yes
  }



  measure: count {
    type: count
    drill_fields: [connecter_name]
  }
}
