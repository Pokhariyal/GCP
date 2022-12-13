# The name of this view in Looker is "Session Information"

view: sessions {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  # sql_table_name: `ANALYTICS.SESSION`
  #   ;;
  derived_table: {
    sql: select BatteryEndPercentage,BatteryStartPercentage,ChargerID,ChargerName,
          ChargingEnergy,ChargingMode,StartTime,EndTime,Duration,EVID,OutputCurrent,OutputVoltage,
          SessionID,SessionStatus,SessionType,UserIDTag
          from `us-gcp-ame-con-3f1aa-npd-1.BW_EV_ANALYTICS.SESSION_INFORMATION` where ENDTIME>"1970-01-01";;
  }
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Battery End Percentage" in Explore.

  dimension: battery_end_percentage {
    type: number
    sql: ${TABLE}.BatteryEndPercentage ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_battery_end_percentage {
    type: sum
    sql: ${battery_end_percentage} ;;
  }

  measure: average_battery_end_percentage {
    type: average
    sql: ${battery_end_percentage} ;;
  }

  dimension: battery_start_percentage {
    type: number
    sql: ${TABLE}.BatteryStartPercentage ;;
  }

  dimension: charger_id {
    type: string
    sql: ${TABLE}.ChargerID ;;
  }

  dimension: charger_name {
    type: string
    sql: ${TABLE}.ChargerName ;;
  }

  dimension: charging_energy {
    type: number
    sql: ${TABLE}.ChargingEnergy ;;
  }

  dimension: charging_mode {
    type: string
    sql: ${TABLE}.ChargingMode ;;
  }

  # dimension: duration {
  #   type: string
  #   sql: ${TABLE}.Duration ;;
  # }

  dimension_group: duration {
    type: duration
    intervals: [hour,minute,second]
    sql_start: ${TABLE}.StartTime;;
    sql_end: ${TABLE}.EndTime ;;
    # sql: ${TABLE}.durationofcharging_hhmmss_ ;;
  }

  dimension: hh_mm_duration {
    type: number
    sql:  ${seconds_duration} / 86400.0;;
    value_format: "hh:mm"
  }

  dimension_group: StartTime{
    type: time

    timeframes: [raw,time,hour,hour_of_day,hour3,day_of_week,day_of_week_index,date,week_of_year,month_name,year,month_num,month,week,quarter]

    sql: ${TABLE}.StartTime;;
  }
  parameter: date_granularity {
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Day_of_Week"}
    allowed_value: { value: "Week"}
    allowed_value: { value: "Month"}
    allowed_value: { value: "Year"}
  }

  dimension: week_num {
    type: string
    hidden: yes
    sql: concat("W",CAST(DIV(EXTRACT(DAY FROM ${StartTime_date}), 7) + 1 AS STRING));;
  }

  dimension: date {
    sql:
          {% if date_granularity._parameter_value == 'Day' %}
            ${StartTime_date}
          {% elsif date_granularity._parameter_value == 'Month' %}
            ${StartTime_month_name}
          {% elsif date_granularity._parameter_value == 'Week' %}
            ${StartTime_week}
          {% elsif date_granularity._parameter_value == 'Day_of_Week' %}
            ${StartTime_day_of_week}
          {% else %}
            ${StartTime_year}
          {% endif %} ;;
    html:
          {% if rendered_value == 'Monday' %}
            <span>Mon</span>
        {% elsif rendered_value == 'Tuesday' %}
            <span>Tue</span>
        {% elsif rendered_value == 'Wednesday' %}
            <span>Wed</span>
        {% elsif rendered_value == 'Thursday' %}
            <span>Thu</span>
        {% elsif rendered_value == 'Friday' %}
            <span>Fri</span>
        {% elsif rendered_value == 'Saturday' %}
            <span>Sat</span>
        {% elsif rendered_value == 'Sunday' %}
            <span>Sun</span>
        {% elsif date_granularity._parameter_value == 'Day' or date_granularity._parameter_value == 'Week'%}
          <span>{{rendered_value |  date: "%Y-%m-%d" }}</span>
        {% else %}
          <span>{{rendered_value }}</span>
        {% endif %}  ;;

    order_by_field: date_sort

    alpha_sort: no
  }

  dimension: date_sort {
    type: number
    sql:
    {% if date_granularity._parameter_value == 'Day_of_Week' or date_granularity._parameter_value == 'Month' %}
      CASE
        WHEN  ${date} = 'January' THEN 1
        WHEN  ${date}  = 'February' THEN 2
        WHEN  ${date}  = 'March' THEN 3
        WHEN  ${date} = 'April' THEN 4
        WHEN  ${date}  = 'May' THEN 5
        WHEN  ${date}  = 'June' THEN 6
        WHEN  ${date} = 'July' THEN 7
        WHEN  ${date}  = 'August' THEN 8
        WHEN  ${date}  = 'September' THEN 9
        WHEN  ${date}  = 'October' THEN 10
        WHEN  ${date}  = 'November' THEN 11
        WHEN  ${date}  = 'December' THEN 12
        WHEN  ${date}  = 'Monday' THEN 13
        WHEN  ${date}  = 'Tuesday' THEN 14
        WHEN  ${date}  = 'Wednesday' THEN 15
        WHEN  ${date}  = 'Thursday' THEN 16
        WHEN  ${date}  = 'Friday' THEN 17
        WHEN  ${date}  = 'Saturday' THEN 18
        WHEN  ${date}  = 'Sunday' THEN 19
        ELSE 20
      END
    {%elsif date_granularity._parameter_value == 'Day'%}
      ${StartTime_date}
    {%elsif date_granularity._parameter_value == 'Week'%}
      ${StartTime_week}
    {% else %}
      ${StartTime_year}
    {%endif%};;
    hidden: yes
    description: "This dimension is used to force sort the subject dimension."
  }

  dimension: 3_Hour_wise {

    sql: (FORMAT_TIMESTAMP('%H', TIMESTAMP_TRUNC(TIMESTAMP_ADD( ${TABLE}.EndTime  , INTERVAL MOD(-1 * EXTRACT(HOUR FROM  ${TABLE}.EndTime   AT TIME ZONE "UTC"), 3) HOUR), HOUR, "UTC"), "UTC"))  ;;
  }


  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: EndTime{
    type: time
    timeframes: [raw,time,hour,hour_of_day,date,week_of_year,month_name,year,month_num]
    sql: ${TABLE}.EndTime ;;
  }

  dimension: evid {
    type: string
    sql: ${TABLE}.EVID ;;
  }

  dimension: output_current {
    type: number
    sql: ${TABLE}.OutputCurrent ;;
  }

  dimension: output_voltage {
    type: number
    sql: ${TABLE}.OutputVoltage ;;
  }

  dimension: session_id {
    type: number
    sql: ${TABLE}.SessionID ;;
  }

  dimension: session_status {
    type: string
    sql: ${TABLE}.SessionStatus ;;
  }

  dimension: session_type {
    type: string
    sql: ${TABLE}.SessionType ;;
  }

  # dimension_group: start {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}.StartTime ;;
  # }

  dimension: user_idtag {
    type: string
    sql: ${TABLE}.UserIDTag ;;
  }

  measure: count {
    type: count
    drill_fields: [charger_name]
  }

# ==========================================  Measures  ================================================ #


  measure:  Total_Energy_Dispensed{
    type: running_total
    sql: ${Energy_total};;
  }

  measure: Energy_total {
    type: sum
    sql: ${TABLE}.ChargingEnergy;;
    value_format: "#.00;($#.00)"
  }
  measure: Energy_average {
    type: average
    sql: ${TABLE}.ChargingEnergy;;
    value_format: "#.00;($#.00)"
  }

  measure: Energy_Usage {
    type: sum
    sql: ${TABLE}.ChargingEnergy;;
    value_format: "0"
  }

  measure: Duration_sum_hours {
    type: sum
    sql: ${hours_duration} ;;
  }


  measure: sum_duration {
    type: sum
    sql: ${seconds_duration} ;;
  }

  measure: per_duration {
    type: number
    # sql: round((${sum_duration}/(24*7*60*60))*100,2);;
    sql:
          {% if date_granularity._parameter_value == 'Day' or date_granularity._parameter_value == 'Day_of_Week' %}
                  round(((${Average_Duration}/(24*60*60))*100),4)
                {% elsif date_granularity._parameter_value == 'Month' %}
                   round( ((${Average_Duration}/(24*30*60*60))*100),4)
                {% elsif date_granularity._parameter_value == 'Week' %}
                  round(((${Average_Duration}/(24*7*60*60))*100),4)
                {% else %}
                  round((${Average_Duration}/(365*24*60*60))*100,4)
                {% endif %}
                ;;
  }
  measure: Average_Duration{
    type: average
    sql: abs(${seconds_duration});;
    value_format: "#.00;($#.00)"

  }
  measure: Average_Duration_hour{
    type: average
    sql: ${hours_duration};;
    value_format: "#.00;($#.00)"

  }


}
