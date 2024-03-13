/* Please Note that the additional * on each line is
 * <-- not required but helps make it clear that the line is part of a comment.
 * The following line is to separate the questions for clarity. 
 ########################################################################################################################
 */

# A test to verify that the database was imported successfully.
SELECT *							# Show all field/columns
	FROM airtraffic.flights			# Tells the query to use table flights
    LIMIT 1000;						# Only return the first 1000 rows
    
    
# A test to verify that the database was imported successfully.
SELECT *							# Show all field/columns
	FROM airtraffic.airports;		# Tells the query to use table airports

#########################################################################################################################    

# How many flights were there in 2018 and 2019 separately?
SELECT YEAR(airtraffic.flights.FlightDate) AS FlightYear, 			# Show year only from date field and name FlightYear
	COUNT(YEAR(airtraffic.flights.FlightDate)) AS FlightCount 		# Show and count of rows for a field
	FROM airtraffic.flights 										# Tells the query to use table flights
    GROUP BY FlightYear; 											# Tells count how to group the fields
# FlightYear	|	FlightCount
# 2018			|	3218653
# 2019			|	3302708

#########################################################################################################################

# In total, how many flights were cancelled or depared late over both years?
SELECT SUM(IF(airtraffic.flights.DepDelay > 0, 1, 0)) AS DelayedFlights,	# First - if there is a delay mark field as an one. Second - sum all delay fields with an one
	SUM(if(airtraffic.flights.Cancelled > 0, 1, 0)) AS CancelledFlights		# First - if the flight is cancelled mark field as an one. Second - sum all cancellation fields with an one
	FROM airtraffic.flights;												# Tells the query to use table flights
# DelayedFlights 	|	CancelledFlights
# 2542442			|	92363

#########################################################################################################################

# Show the number of flights that were cancelled broken down by the reason for cancellation.
SELECT SUM(IF(airtraffic.flights.CancellationReason = "Carrier", 1, 0)) AS CarrierCancellation, 					# First - if the cancellation reason is string Carrier mark field as an one. Second - sum all cancellation fields with an one
    SUM(IF(airtraffic.flights.CancellationReason = "National Air System", 1, 0)) AS NationalAirSystemCancellation,  # First - if the cancellation reason is string National Air System mark field as an one. Second - sum all National Air System fields with an one
    SUM(IF(airtraffic.flights.CancellationReason = "Security", 1, 0)) AS SecurityCancellation,						# First - if the cancellation reason is string Security mark field as an one. Second - sum all Security fields with an one
    SUM(IF(airtraffic.flights.CancellationReason = "Weather", 1, 0)) AS WeatherCancellation							# First - if the cancellation reason is string Weather mark field as an one. Second - sum all Weather fields with an one
	FROM airtraffic.flights																							# Tells the query to use table flights
    WHERE airtraffic.flights.Cancelled > 0;																			# Filter flights that were cancelled
# CarrierCancellation	|	NationalAirSystemCancellation	|	SecurityCancellation	|	WeatherCancellation
# 34141					|	7962							|	35						|	50225

#########################################################################################################################

/* For each month in 2019, report both the total number of flights and percentage of flights cancelled.
 * Based on your results, what might you say about the cyclic nature oof airline revenue?
 */
SELECT YEAR(airtraffic.flights.FlightDate) AS Year,					# Show year from the FlightDate field
	MONTH(airtraffic.flights.FlightDate) AS Month,					# Show month from the FlightDate field
	COUNT(MONTH(airtraffic.flights.FlightDate)) AS FlightCount,		# Show and counts the Total flights scheduled for by month
    # The next line produces the percentage of cancelled flight by dividing Total monthly flights by total monthly cancellations.
    SUM(IF(airtraffic.flights.Cancelled > 0, 1, 0)) / COUNT(MONTH(airtraffic.flights.FlightDate)) AS CancelledFlightsPercentage
	FROM airtraffic.flights											# Tells the query to use table flights
    WHERE YEAR(airtraffic.flights.FlightDate) = 2019				# Filter Flights from the year of 2019
    GROUP BY Year, Month											# Group the data (count and sum) by the year and month
    ORDER BY Month ASC;												# Sort month in ascending order
# Year	|	Month	|	FlightCount	|	CancelledFlightsPercentage
# 2019	|	1		|	262165		|	0.0221
# 2019	|	2		|	237896		|	0.0231
# 2019	|	3		|	283648		|	0.0250
# 2019	|	4		|	274115		|	0.0271
# 2019	|	5		|	285094		|	0.0242
# 2019	|	6		|	282653		|	0.0218
# 2019	|	7		|	291955		|	0.0155
# 2019	|	8		|	290493		|	0.0125
# 2019	|	9		|	268625		|	0.0124
# 2019	|	10		|	283815		|	0.0081
# 2019	|	11		|	266878		|	0.0059
# 2019	|	12		|	275371		|	0.0051

/* The data suggest that flight cancellations increase in the winter months due to weather
 * and that customers take more flights in summer months. This means that winter months
 * have the lowest revenue generation while the summer months have the highest revenue
 * generation. In short, nice weather generates more revenue.
 */
 
#########################################################################################################################
#########################################################################################################################

# Create two new tables, one for each year (2018 and 2019) showing the total miles
# traveled and number of flights broken down by airline.

# Create table and input 2018 data from query
CREATE TABLE airtraffic.FlightCount_and_Distance_by_Airline_in_2018			# Create a new table from query named FlightCount_and_Distance_by_Airline_in_2018
	SELECT airtraffic.flights.Reporting_Airline,							# Pick the Airline
	SUM(if(airtraffic.flights.Cancelled = 0, 1, 0)) AS NumberOfFlights,		# Count all the fights that are not cancelled
    SUM(airtraffic.flights.Distance) AS TotalDistance						# Total all the distance travelled
	FROM airtraffic.flights													# Tells the query to use table flights
    WHERE YEAR(airtraffic.flights.FlightDate) = 2018						# Filter by year 2018 from date field FlightDate
    GROUP BY airtraffic.flights.Reporting_Airline							# Group data by Airline
    ORDER BY airtraffic.flights.Reporting_Airline ASC;						# Sort by Airline
    
    
# Verify new 2018 table	
SELECT *																	# Show all field/columns
	FROM airtraffic.flightcount_and_distance_by_airline_in_2018;			# Tells the query to use table FlightCount_and_Distance_by_Airline_in_2018
  
  
# Create table and input 2019 data from query
CREATE TABLE  airtraffic.FlightCount_and_Distance_by_Airline_in_2019		# Create a new table from query named FlightCount_and_Distance_by_Airline_in_2019
	SELECT airtraffic.flights.Reporting_Airline,							# Show the airline
	SUM(if(airtraffic.flights.Cancelled = 0, 1, 0)) AS NumberOfFlights,		# Show and count all the fights that are not cancelled
	SUM(airtraffic.flights.Distance) AS TotalDistance						# Show and total all the distance travelled
	FROM airtraffic.flights													# Tells the query to use table flights
    WHERE YEAR(airtraffic.flights.FlightDate) = 2019						# Filter by year 2019 from date field FlightDate
    GROUP BY airtraffic.flights.Reporting_Airline							# Group data by Airline
    ORDER BY airtraffic.flights.Reporting_Airline ASC;						# Sort by Airline


# Verify new 2019 table
SELECT *																	# Pick all field/columns
	FROM airtraffic.flightcount_and_distance_by_airline_in_2019;			# Tells the query to use table FlightCount_and_Distance_by_Airline_in_2019
    
    
# Question 2.2 Using your new tables, find the year-over-year percent change in total flights and miles traveled for each airline.
SELECT a2019.Reporting_Airline,
	a2019.NumberOfFlights - a2018.NumberOfFlights AS ChangeInNumOfFlights,					# Gives the difference in the number of total flights from 2018 to 2019
    ROUND(a2019.NumberOfFlights / a2018.NumberOfFlights, 4) AS PercentageChangeInFlights,	# Gives the percentage change in decimal from 2018 to 2019
    a2019.TotalDistance - a2018.TotalDistance AS ChangeInDistance,							# Gives the difference in the total distance travelled from 2018 to 2019
    ROUND(a2019.TotalDistance / a2018.TotalDistance, 4) AS PercentageChangeInDistance		# Gives the percentage change in the total distance travelled from 2018 to 2019
	FROM airtraffic.flightcount_and_distance_by_airline_in_2019 as a2019					# Tells the query to use table FlightCount_and_Distance_by_Airline_in_2019 and name it a2019
    INNER JOIN airtraffic.flightcount_and_distance_by_airline_in_2018 as a2018				# Joins/Links FlightCount_and_Distance_by_Airline_in_2018 with the name a2018
    ON a2018.Reporting_Airline = a2019.Reporting_Airline;									# the link or join is connected by Airline from FlightCount_and_Distance_by_Airline_in_2018 and FlightCount_and_Distance_by_Airline_in_2019
# Reporting_Airline	|	ChangeInNumOfFlights	|	PercentageChangeInFlights	|	ChangeInDistance	|	PercentageChangeInDistance
# AA				|	24752					|	1.0274						|	5234167				|	1.0056
# DL				|	44389					|	1.0469						|	46868365			|	1.0556
# WN				|	-3953					|	0.9970						|	-1263265			|	0.9988

/* If the airline carries have the same average price per flight. It is
 * recommended to invest in airline carrier DL because they had a 4.69%
 * increase in flights and a 5.56% increase in distance year over year.
 * This implies that DL in growing at a higher rate than AA who had a 2.74%
 * increase in flights and a 0.56% increase in distance year over year.
 * WN had shrank year over year with a loss of 0.3% in flights and a loss of
 * 0.12% in distance.
 */

#########################################################################################################################
#########################################################################################################################

# What are the names of the 10 most popular destination airports overall?
# For this question, generate a SQL query that first joins flights and airports then
# does the necessary aggregation.
SELECT a.AirportName,						# Show field name AirportName from airtraffic.airports
	COUNT(F.DestAirportID) AS DestCount		# Count all the flights to each destination and name it DestCount
    FROM airtraffic.flights AS f			# Tells the query to use table airtraffic.flights and name it f
    LEFT JOIN airtraffic.airports AS a		# Joins/Links airports table and names it a
    ON a.AirportID = f.DestAirportID		# The link between the two table are where airport AirportID = flight DestAirportID
    GROUP BY a.AirportName					# group the data by the Airport name from table airports
    ORDER BY DestCount DESC					# Decending order by the count of flights to each destination
    LIMIT 10;								# Only give ten destinations, which will be the top 10 because of the descending order
# Runtime 20.125 seconds.

# AirportName												|	DestCount
# Hartsfield-Jackson Atlanta International					|	595527
# Dallas/Fort Worth International							|	314423
# Phoenix Sky Harbor International							|	253697
# Los Angeles International									|	238092
# Charlotte Douglas International							|	216389
# Harry Reid International									|	200121
# Denver International										|	184935
# Baltimore/Washington International Thurgood Marshall		|	168334
# Minneapolis-St Paul International							|	165367
# Chicago Midway International								|	165007

#########################################################################################################################
#########################################################################################################################

# The same question but using a subquery to aggregate & limit the
# flight data before your join with the airport information, hence optimizing your query runtime.
SELECT a.AirportName,											# Show field name AirportName from airtraffic.airports
	d.DestCount													# Show field name DestCount from subquery named d
	FROM (														# Tells the query to use subquery. The subquery is performed first
		SELECT airtraffic.flights.DestAirportID,				# Pick DestAirportID field from table airtraffic.flights
		COUNT(airtraffic.flights.DestAirportID) AS DestCount	# Count all the flights to each destination and name it DestCount
		FROM airtraffic.flights									# Tells the query to use table airtraffic.flights
		GROUP BY airtraffic.flights.DestAirportID				# group the data by the DestinationID from table flights
		ORDER BY DestCount DESC									# Decending order by the count of flights to each destination
		LIMIT 10												# Only give ten destinations, which will be the top 10 because of the descending order
    ) AS d														# Name the subquery d
    LEFT JOIN airtraffic.airports AS a							# Join/Link with table airtraffic.airports and name a
    ON a.AirportID = d.DestAirportID;							# Join/Link the tables with airports.AirportID = flights.DestAirportID;	
# Runtime 4.64 seconds
# As a side note the subquery can be stored in a temporary table and then joined. This may make the query easier to read.
/* The runtime on the second query is much faster because the query does not join/link the
 * flights and airport tables until after the top ten are determine by the count of flights to
 * each destination. In other words, the first query links all the destination names by ID and then
 * drops all but the top ten destinations. Where the second query counts the destinations, selects
 * the top ten, and then join/link the name of the airport names by ID, which is a lot less work. 
 */
 
#########################################################################################################################
#########################################################################################################################
 
 /* A flight's tail number is the actual number affixed to the fuselage of an aircraft,
  * much like a car license plate. As such, each plane has a unique tail number and the number of
  * unique tail numbers for each airline should approximate how many planes the airline operates in
  * total. Using this information, determine the number of unique aircrafts each airline operated in
  * total over 2018-2019.
  */
SELECT t.Reporting_Airline,											# Pick field name Reporting Airline from subquery t field
	COUNT(T.Reporting_Airline) AS NumberOfAirplanes					# Count the number of airlines from subquery t field and name NumberOfAirplanes
	FROM (															# Tells the query to use data from the subquery. The subquery is performed first
		SELECT airtraffic.flights.Tail_Number,						# Pick field name Tail Number from airtraffic.airports
		COUNT(airtraffic.flights.Tail_Number) AS TailNumCount,		# Count the number of flights for each tail number and names it TailNumCount
		airtraffic.flights.Reporting_Airline						# Picks the reporting airline from the table airtraffic.flights
		FROM airtraffic.flights										# Tells the query to use the table of flights
		GROUP BY airtraffic.flights.Tail_Number, airtraffic.flights.Reporting_Airline		# Group by tail number first for the count and distant, then group by airline
		ORDER BY airtraffic.flights.Reporting_Airline ASC			# Sort by airline in ascending order
	) AS t															# Name subquery as t
    GROUP BY t.Reporting_Airline;									# Group by airline for final output
# Reporting_Airline		|	NumberOfAirplanes
# AA					|	994
# DL					|	989
# WN					|	755

#########################################################################################################################
    
/* Similarly, the total miles traveled by each airline gives an idea of total fuel costs
 * and the distance traveled per plane gives an approximation of total equipment costs. What is the
 * average distance traveled per aircraft for each of the three airlines?
 */
SELECT t.Reporting_Airline,											# Show field name Reporting Airline from subquery t field
	COUNT(T.Reporting_Airline) AS NumOfTails,						# Show and Count the number of airplane tail numbers
    SUM(T.DistancePerTail) AS TotalDistance,						# Toal of all distance travelled by each tail number and totaled by airline later in the query
	ROUND(SUM(T.DistancePerTail) / COUNT(T.Reporting_Airline), 0) AS AvgDistPerTailNum		# NumOfTails / TotalDistance and round to 0 decimal places
	FROM (															# Tells the query to use data from the subquery. The subquery is performed first
		SELECT airtraffic.flights.Tail_Number,						# Pick field name Tail Number from airtraffic.airports
		COUNT(airtraffic.flights.Tail_Number) AS TailNumCount,		# Count the number of flights for each tail number and names it TailNumCount
        SUM(airtraffic.flights.Distance) AS DistancePerTail,		# Adds the total distance for each tail number and names it DistancePerTail
		airtraffic.flights.Reporting_Airline						# Picks the reporting airline from the table airtraffic.flights
		FROM airtraffic.flights										# Tells the query to use the table of flights
		GROUP BY airtraffic.flights.Tail_Number, airtraffic.flights.Reporting_Airline		# Group by tail number first for the count and distant, then group by airline
		ORDER BY airtraffic.flights.Reporting_Airline ASC			# Sort by airline in ascending order
	) AS t															# Name subquery as t
    GROUP BY t.Reporting_Airline;									# Group by airline for final output
# Reporting_Airline	|	NumOfTails	|	TotalDistance	|	AvgDistPerTailNum
# AA				|	994			|	1871422719		|	1882719
# DL				|	989			|	1731686703		|	1750947
# WN				|	755			|	2024430929		|	2681365

/* WN has the fewest airplanes with 755 while having the highest distance travelled. WN fuel
 * cost should be the highest along with the highest maintenance cost per airplane, however
 * with a higher utilization of each aircraft, it may have the greatest gross margin. AA
 * is in the middle with distance travelled but has the most of airplanes at 994. The fuel cost
 * is likely lower than WN, however AA may have more debt than WN due to the number of
 * airplanes. AA generates less revenue than WN because less distance is travelled and AA
 * airplane utilization is also lower than WN. DL comes in third with the lowest distance
 * travelled and in the middle of number of airplanes with 989.  DL is likely to have less
 * revenue than both WN and AA. In conclusion, WN likely has the best financial health when
 * compared with AA and DL. AA and DL financial health is about the same.
 * When comparing the estimation of financial health to the growth from question 3,
 * it reinforces the recommendation to purchase DL shares. WN shows that higher
 * aircraft utilization is possible, and DL can implement strategies increase their aircraft
 * utilization and will not require purchasing new equipment during their current growth
 * phase. While the reason for WN negative growth from 2018 to 2019 is unknown, it
 * can be from the maturity of the company or being more sensitive to equipment breaks
 * or some other reason. Regardless of the reason, growth for WN will be more difficult
 * without purchasing more equipment and the profitability of the company will already
 * be reflected in the current stock price. AA is in a similar situation to DL however its
 * growth is slower.
 */
 
#########################################################################################################################
#########################################################################################################################
 
/* Next, we will look into on-time performance more granularly in relation
 * to the time of departure. We can break up the departure times into three categories as follows:
 * CASE
 *   WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
 *   WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
 *   WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
 *   ELSE "4-night"
 * END AS "time_of_day"
 * Find the average departure delay for each time-of-day across the whole data set. Can you explain the pattern you see?
 */
 
# Gives departure time of all flights and adds field/column string time_of_day
SELECT airtraffic.flights.CRSDepTime AS DepTime,					# Show Departure time from flights table and name as DepTime
	CASE															# Start of logic that creates a new field/column, order matters
		WHEN HOUR(DepTime) BETWEEN 7 AND 11 THEN "1-morning"		# If time between 7:00am and 11:59am set field to string 1-morning
		WHEN HOUR(DepTime) BETWEEN 12 AND 16 THEN "2-afternoon"		# If time between 12:00pm and 4:59pm set field to string 2-afternoon
		WHEN HOUR(DepTime) BETWEEN 17 AND 21 THEN "3-evening"		# If time between 5:00pm and 21:59pm set field to string 3-evening
		ELSE "4-night"												# All other times will be set to string 4-night
	END AS time_of_day												# Set field/column as time_of_day
	FROM airtraffic.flights;										# Tells the query to use data from flights
    
    
# Gives the average delay by string time_of_day
SELECT AVG(airtraffic.flights.DepDelay) AS AvgDelay,				# Calculates avg of Departure Delay from table flights and names it AvgDelay
	CASE															# Start of logic that creates a new field/column, order matters
		WHEN HOUR(DepTime) BETWEEN 7 AND 11 THEN "1-morning"		# If time between 7:00am and 11:59am set field to string 1-morning
		WHEN HOUR(DepTime) BETWEEN 12 AND 16 THEN "2-afternoon"		# If time between 12:00pm and 4:59pm set field to string 2-afternoon
		WHEN HOUR(DepTime) BETWEEN 17 AND 21 THEN "3-evening"		# If time between 5:00pm and 21:59pm set field to string 3-evening
		ELSE "4-night"												# All other times will be set to string 4-night
	END AS time_of_day												# Set field/column as time_of_day
	FROM airtraffic.flights											# Tells the query to use data from flights
    GROUP BY time_of_day											# Group by new logic column time_of_day
    ORDER BY time_of_day ASC;										# Sort by time_of_day ascending	
# AvgDelay	|	time_of_day
# 4.1638	|	1-morning
# 9.8920	|	2-afternoon
# 16.6702	|	3-evening
# 10.1396	|	4-night
/* The delays increase as the day progresses showing that later departures are
 * affected by departure delays earlier in the day. Mornings have the lowest amount
 * of delays followed by longer afternoon delays, then evenings having the longest delay
 * times. Nights likely has lower delay times than evenings due to fewer flights allowing
 * delay times to decrease.
 */
 
#########################################################################################################################

# Now, find the average departure delay for each airport and time-of-day combination.
SELECT a.AirportName,													# Show Airport name from airport table
	d.AvgDelay,															# Show AvgDelay from subquery
    d.time_of_day														# Show time_of_day from subquery
	FROM (																# Tells the query to use data from the subquery. The subquery is performed first
		SELECT AVG(f.DepDelay) AS AvgDelay,								# Pick average of Depature Delay from flights table and name AvgDelay
			f.OriginAirportID,											# Pick Origin Airport ID from flight table
			CASE														# Start of logic that creates a new field/column, order matters
				WHEN HOUR(DepTime) BETWEEN 7 AND 11 THEN "1-morning"	# If time between 7:00am and 11:59am set field to string 1-morning
				WHEN HOUR(DepTime) BETWEEN 12 AND 16 THEN "2-afternoon"	# If time between 12:00pm and 4:59pm set field to string 2-afternoon
				WHEN HOUR(DepTime) BETWEEN 17 AND 21 THEN "3-evening"	# If time between 5:00pm and 21:59pm set field to string 3-evening
				ELSE "4-night"											# All other times will be set to string 4-night
			END AS time_of_day											# Set field/column as time_of_day
			FROM airtraffic.flights as f								# Tells the query to use data from flights and name as f
			GROUP BY time_of_day, f.OriginAirportID						# Group by time_of_day from logic first then by OriginAirportID
    ) AS d																# Name subquery as d
    LEFT JOIN airtraffic.airports as a									# Join/Link with table airtraffic.airports and name a
    ON a.AirportID = d.OriginAirportID;									# Join/Link the tables with airports.AirportID = flights.OriginAirportID;	
    
#########################################################################################################################
    
# Next, limit your average departure delay analysis to morning delays and airports with at least 10,000 flights. 
SELECT a.AirportName, AvgDelay, FlightCount, ab.time_of_day		# Show Airport name from airport table, AvgDelay from subquery, FlightCount from subquery, and time_of_day from subquery
	FROM (														# Tells the query to use data from the subquery. The subquery is performed first
		SELECT f.OriginAirportID,								# Pick Origin Airport ID from flight table
			AVG(f.DepDelay) AS AvgDelay,						# Pick average of Depature Delay from flights table and name AvgDelay
			COUNT(f.DepDelay) AS FlightCount,					# Pick count of Departure Delay from flight table and name FlightCount
			CASE												# Start of logic that creates a new field/column, order matters
				WHEN HOUR(DepTime) BETWEEN 7 AND 11 THEN "1-morning"		# If time between 7:00am and 11:59am set field to string 1-morning
				WHEN HOUR(DepTime) BETWEEN 12 AND 16 THEN "2-afternoon"		# If time between 12:00pm and 4:59pm set field to string 2-afternoon
				WHEN HOUR(DepTime) BETWEEN 17 AND 21 THEN "3-evening"		# If time between 5:00pm and 21:59pm set field to string 3-evening
				ELSE "4-night"									# All other times will be set to string 4-night
			END AS time_of_day									# Set field/column as time_of_day
			FROM airtraffic.flights as f						# Tells the query to use data from flights and name as f
			GROUP BY time_of_day, f.OriginAirportID				# Group by time_of_day from logic first then by OriginAirportID
    ) AS ab														# Name subquery as ab
    LEFT JOIN airtraffic.airports AS a							# Join/Link with table airtraffic.airports and name a
    ON a.AirportID = ab.OriginAirportID							# Join/Link the tables with airports.AirportID = flights.OriginAirportID;
    WHERE FlightCount > 10000									# Filter FlightCount 10000 or more
    AND ab.time_of_day = "1-morning"							# And filter for subquery time_of_day string = "1-morning" 
    ORDER BY FlightCount ASC;									# Order by FlightCount ascending
# 46 rows returned
# AirportName							|	AvgDelay	|	FlightCount	|	time_of_day
# Newark Liberty International			|	3.8447		|	10316		|	1-morning
# General Mitchell International		|	3.3248		|	10640		|	1-morning
# John Glenn Columbus International		|	3.9337		|	10654		|	1-morning
# Southwest Florida International		|	1.8774		|	10884		|	1-morning
# Pittsburgh International				|	2.1260		|	12056		|	1-morning
# Indianapolis International			|	3.7390		|	12850		|	1-morning
# Portland International				|	2.6511		|	13922		|	1-morning
# Bob Hope								|	2.3753		|	15303		|	1-morning
# San Antonio International				|	3.6343		|	16144		|	1-morning

#########################################################################################################################
  
# By extending the query from the previous question, name the top-10 airports (with >10000 flights) with
# the highest average morning delay. In what cities are these airports located?
SELECT a.AirportName,											# Show Airport name from airport table
	SUBSTRING_INDEX(a.City, ",", 1) AS City,					# Show the city of the airport, substring_index removes the state and name City
    AvgDelay,													# Show AvgDelay from subquery
    FlightCount,												# FlightCount from subquery
    ab.time_of_day												# Show time_of_day from subquery
	FROM (														# Tells the query to use data from the subquery. The subquery is performed first
		SELECT f.OriginAirportID,								# Pick Origin Airport ID from flight table
			AVG(f.DepDelay) AS AvgDelay,						# Pick average of Depature Delay from flights table and name AvgDelay
			COUNT(f.DepDelay) AS FlightCount,					# Pick count of Departure Delay from flight table and name FlightCount
			CASE												# Start of logic that creates a new field/column, order matters
				WHEN HOUR(DepTime) BETWEEN 7 AND 11 THEN "1-morning"		# If time between 7:00am and 11:59am set field to string 1-morning
				WHEN HOUR(DepTime) BETWEEN 12 AND 16 THEN "2-afternoon"		# If time between 12:00pm and 4:59pm set field to string 2-afternoon
				WHEN HOUR(DepTime) BETWEEN 17 AND 21 THEN "3-evening"		# If time between 5:00pm and 21:59pm set field to string 3-evening
				ELSE "4-night"									# All other times will be set to string 4-night
			END AS time_of_day									# Set field/column as time_of_day
			FROM airtraffic.flights as f						# Tells the query to use data from flights and name as f
			GROUP BY time_of_day, f.OriginAirportID				# Group by time_of_day from logic first then by OriginAirportID
    ) AS ab														# Name subquery as ab
    LEFT JOIN airtraffic.airports AS a							# Join/Link with table airtraffic.airports and name a
    ON a.AirportID = ab.OriginAirportID							# Join/Link the tables with airports.AirportID = flights.OriginAirportID;
    WHERE FlightCount > 10000									# Filter FlightCount 10000 or more
    AND ab.time_of_day = "1-morning"							# And filter for subquery time_of_day string = "1-morning" 
    ORDER BY AvgDelay DESC										# Order by AvgDely in descending order
    LIMIT 10;													# Show 10 rows witch are the top 10
/* The top cities with the longest time delays in departures with over
 * 10,000 departures per day are as follows:
 * 1. Chicago - 2 Airports
 * 2. Dallas and Fort Worth - 2 Airports
 * 3. Los Angeles
 * 4. Miami
 * 5. San Francisco
 * 6. Denver
 * 7. Las Vegas
 * 8. Boston
 */