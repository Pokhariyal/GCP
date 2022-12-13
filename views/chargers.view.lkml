# The name of this view in Looker is "Charger Information"

view: chargers{
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: ANALYTICS.CHARGER`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Address" in Explore.

  dimension: address {
    type: string
    sql: ${TABLE}.Address ;;
  }

  dimension: charger_condition {
    type: string
    sql: ${TABLE}.ChargerCondition ;;
  }

  dimension: charger_id {
    type: string
    sql: ${TABLE}.ChargerID ;;
    primary_key: yes
  }

  dimension: charger_name {
    type: string
    sql: ${TABLE}.ChargerName ;;
  }

  dimension: charger_status {
    type: string
    sql: ${TABLE}.ChargerStatus ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.City ;;
  }

  dimension: configuration {
    type: string
    sql: ${TABLE}.Configuration ;;
  }

  dimension: contact {
    type: string
    sql: ${TABLE}.ContactInfo ;;
  }

  dimension: Country {
    label: "Country"
    map_layer_name: countries
    drill_fields: [state, city]
    sql: CASE WHEN ${TABLE}.Country = 'UK' THEN 'United Kingdom'
           ELSE ${TABLE}.Country
           END
       ;;
  }

  dimension: cpoid {
    type: string
    sql: ${TABLE}.CPOID ;;
  }

  dimension: fw_version {
    type: string
    sql: ${TABLE}.FWVersion ;;
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: lastupdate {
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
    sql: ${TABLE}.LastUpdate ;;
  }

  dimension: locationid {
    type: string
    sql: ${TABLE}.LocationID ;;
  }

  dimension: lat_long {
    label: "Loaction corrdinate"
    type: location
    sql_latitude: ${TABLE}.Latitude ;;
    sql_longitude: ${TABLE}.Longitude ;;
    }
  dimension: location_cordinate {
    label: "Loaction Details"
    type: location
    sql_latitude: ${TABLE}.Latitude ;;
    sql_longitude: ${TABLE}.Longitude ;;
    html:
    <div style="flex-direction:row;justify-content: space-between;">
    <div  style="border-bottom: 2px solid green;margin-top:1rem;">Location_id : {{chargers.locationid}}</div>
    <div style="margin-top:.2rem;">Address </div>
    <div style="margin-bottom:2rem;">{{chargers.city}}, {{chargers.state}}, {{chargers.Country}}, {{zip_code}}</div>
    <div style="margin-top:.2rem;" >CPO ID  </div>
    <div style="margin-bottom:2rem;">{{chargers.cpoid}}</div>
    <div  style="margin-bottom:2rem;">{{chargers.color_condition}} Active chargers</div>
    <div>Charger State of Active chargers</div>
    <div>{{chargers.charging_count}} Charging</div>
    <div>{{chargers.cable_disconnected_count}} Cable Disconnected</div>
    <div>{{chargers.cable_connected_count}} Cable Connected,Not Charging</div>
    <div style="margin-bottom:2rem;" >{{chargers.unknown_count}} Unknown</div>

  </div>

      ;;
  }
  dimension: online {
    type: yesno
    sql: ${TABLE}.Online ;;
  }

  dimension: present_charger_state {
    type: string
    sql: ${TABLE}.PresentChargerState ;;
  }

  dimension: product_serial_number {
    type: string
    sql: ${TABLE}.ProductSerialNumber ;;
  }

  dimension: product_type {
    type: string
    sql: ${TABLE}.ProductType ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.State ;;
  }

  dimension_group: warranty_end {
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
    sql: ${TABLE}.WarrantyEnd ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: ${TABLE}.ZipCode ;;
  }

  dimension: location_city {
    type: string
    sql: concat(${locationid}," - ",${city}," , ",${state}) ;;

  }

  measure: count {
    type: count
    drill_fields: [charger_name]
  }


## Charger Condition Customize

  dimension: charger_con {
    type: string
    sql: ${TABLE}.ChargerCondition ;;
    order_by_field: charger_con_sort
  }


  dimension: charger_con_sort {
    type: number
    sql:
      CASE
      WHEN  ${charger_con} = 'Pending' THEN 2
      WHEN  ${charger_con}  = 'Active' THEN 1
      WHEN  ${charger_con}  = 'Inactive' THEN 3
      ELSE 4
      END;;

    hidden: yes
  }

  measure: value_color {
  label: "Color"
    sql: CASE
      WHEN  ${charging_count} = ${color_condition} THEN 1
      WHEN  ${charging_count} >0 and ${charging_count} < ${color_condition} THEN 2
      WHEN  ${charging_count} = 0  THEN 3
      ELSE 4
      END;;
    html: {% if value == 1 %} Green
            {% elsif  value == 2 %} Orange
            {% elsif value ==3 %} Red
            {% endif %};;

  }

  measure: count_chargers {
    type: count

  }

  measure: color_condition {
    type: count

    filters: [charger_condition: "Active"]
  }
  measure: cable_disconnected_count {
    type: count
    filters: [present_charger_state: "Cable Disconnected",charger_condition: "Active"]
  }
  measure: charging_count {
    type: count
    filters: [present_charger_state: "Charging",charger_condition: "Active"]
  }
  measure: cable_connected_count {
    type: count
    filters: [present_charger_state: "Cable Connected",charger_condition: "Active"]
  }
  measure: unknown_count {
    type: count
    filters: [present_charger_state: "Unknown",charger_condition: "Active"]
  }

}
