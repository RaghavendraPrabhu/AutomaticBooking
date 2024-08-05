#!/bin/bash

DB_USER="postgres"
DB_PASS="pass123"
DB_NAME="postgres"
CONTAINER_NAME="bmd-db"

if ! docker ps --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
    echo "Error: Container $CONTAINER_NAME is not running."
    exit 1
fi

NEXT_MON=$(date -d 'next Monday' +%Y-%m-%d)
NEXT_TUE=$(date -d "$NEXT_MON + 1 day" +%Y-%m-%d)
NEXT_WED=$(date -d "$NEXT_MON + 2 days" +%Y-%m-%d)

generate_sql_query() {
  local booking_date=$1
  cat <<EOF
WITH last_user AS (
    SELECT COALESCE(MAX(user_id), 0) AS last_user_id FROM booking
)
INSERT INTO booking (user_id, seat_name, username, floor_number, booking_start_date, booking_end_date, booked_at)
SELECT last_user_id + 1, 'RT2-3', 'Raghavendra Prabhu', 1, '$booking_date', '$booking_date', NOW()
FROM last_user
WHERE NOT EXISTS (
    SELECT 1 FROM booking
    WHERE booking_start_date = '$booking_date'
    AND booking_end_date = '$booking_date'
    AND floor_number = 1
    AND seat_name = 'RT2-3'
);
EOF
}

SQL_QUERY_1=$(generate_sql_query $NEXT_MON)
SQL_QUERY_2=$(generate_sql_query $NEXT_TUE)
SQL_QUERY_3=$(generate_sql_query $NEXT_WED)

echo "Generated SQL Query for Monday: $SQL_QUERY_1"
echo "Generated SQL Query for Tuesday: $SQL_QUERY_2"
echo "Generated SQL Query for Wednesday: $SQL_QUERY_3"

docker exec -i "$CONTAINER_NAME" psql -U $DB_USER -d $DB_NAME <<EOF
$SQL_QUERY_1
$SQL_QUERY_2
$SQL_QUERY_3
EOF

docker exec -i "$CONTAINER_NAME" psql -U $DB_USER -d $DB_NAME -c "ALTER DATABASE $DB_NAME REFRESH COLLATION VERSION;"

echo "Raghavendra Booking and collation tasks completed."



generate_sql_query1() {
  local booking_date=$1
  cat <<EOF
WITH last_user AS (
    SELECT COALESCE(MAX(user_id), 0) AS last_user_id FROM booking
)
INSERT INTO booking (user_id, seat_name, username, floor_number, booking_start_date, booking_end_date, booked_at)
SELECT last_user_id + 1, 'RT2-2', 'Ankita Lembhe', 1, '$booking_date', '$booking_date', NOW()
FROM last_user
WHERE NOT EXISTS (
    SELECT 1 FROM booking
    WHERE booking_start_date = '$booking_date'
    AND booking_end_date = '$booking_date'
    AND floor_number = 1
    AND seat_name = 'RT2-2'
);
EOF
}

SQL_QUERY_4=$(generate_sql_query1 $NEXT_MON)
SQL_QUERY_5=$(generate_sql_query1 $NEXT_TUE)
SQL_QUERY_6=$(generate_sql_query1 $NEXT_WED)

echo "Generated SQL Query for Monday: $SQL_QUERY_4"
echo "Generated SQL Query for Tuesday: $SQL_QUERY_5"
echo "Generated SQL Query for Wednesday: $SQL_QUERY_6"

docker exec -i "$CONTAINER_NAME" psql -U $DB_USER -d $DB_NAME <<EOF
$SQL_QUERY_4
$SQL_QUERY_5
$SQL_QUERY_6
EOF

docker exec -i "$CONTAINER_NAME" psql -U $DB_USER -d $DB_NAME -c "ALTER DATABASE $DB_NAME REFRESH COLLATION VERSION;"

echo "Raghavendra Booking and collation tasks completed."