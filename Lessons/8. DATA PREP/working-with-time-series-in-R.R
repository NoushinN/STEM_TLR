###DEMO for working with extensible time series data in R###
# Lessons are adapted and organized by Noushin Nabavi, PhD.

# xts and zoo objects
# Load xts and zoo library 
library(xts)
library(zoo)

# xts objects are simple. Think of them as a matrix of observations combined with an index of corresponding dates and times.
# Create the object data using 5 random numbers
data <- rnorm(5)
print(data)

# Create dates as a Date class object starting from 2016-01-01
dates <- seq(as.Date("2016-01-01"), length = 5, by = "days")
print(dates)

# Use xts() to create data_dates
# xts = matrix + times 
## xts takes two arguments: x for the data and order.by for the index
data_dates <- xts(x = data, order.by = dates)
print(data_dates)

# Create one_date (1899-05-08) using a POSIXct date class object
one_date <- as.POSIXct("1899-05-08")
print(one_date)

# Create some_dates and add a new attribute called one_date
some_dates <- xts(x = data, order.by = dates, born = one_date)
print(some_dates)


# ------------------------------------------------------------------------

# Deconstructing xts
# Extract the core data of some_dates
some_dates_core <- coredata(some_dates)
print(some_dates_core)

# View the class of some_dates_core
class(some_dates_core)

# Extract the index of some_dates_core
some_dates_core_index <- index(some_dates_core)

# View the class of some_dates_core_index
class(some_dates_core_index)

# ------------------------------------------------------------------------

# Time based indices
# Create dates
dates <- as.Date("2016-01-01") + 0:4

# Create ts_a
ts_a <- xts(x = 1:5, order.by = dates)
head(ts_a)

# Create ts_b
ts_b <- xts(x = 1:5, order.by = as.POSIXct(dates))
head(ts_b)

# Extract the rows of ts_a using the index of ts_b
ts_a[index(ts_b)]

# Extract the rows of ts_b using the index of ts_a
ts_b[index(ts_a)]

# ------------------------------------------------------------------------

# Importing, exporting and converting time series
# It is often necessary to convert between classes when working with time series data in R. 
data(sunspots)
data(austres)

# Convert austres to an xts object called au and inspect
au <- as.xts(austres)
class(au)
print(au)
head(au)

# Then convert your xts object (au) into a matrix am and inspect
am <- as.matrix(au)
class(am)
print(am)
head(am)

# Convert the original austres into a matrix am2
am2 <- as.matrix(austres)
head(am2)


# Create dat by reading tmp_file
temp_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1127/datasets/tmp_file.csv"
dat <- read.csv(temp_url)
head(dat)

# Convert dat into xts
xts(dat, order.by = as.Date(rownames(dat), "%m/%d/%Y"))

# Read tmp_file using read.zoo and as.xts
dat_zoo <- read.zoo(temp_url, index.column = 0, sep = ",", format = "%m/%d/%Y")

# Read tmp_file using read.zoo and as.xts
dat_xts <- as.xts(dat_zoo)
head(dat_xts)

# exporting data
# Convert sunspots to xts using as.xts().
sunspots_xts <- as.xts(sunspots)

# Get the temporary file name
tmp <- tempfile()

# Write the xts object using zoo to tmp 
write.zoo(sunspots_xts, sep = ",", file = tmp)

# Read the tmp file. FUN = as.yearmon converts strings such as Jan 1749 into a proper time class
sun <- read.zoo(tmp, sep = ",", FUN = as.yearmon)
head(sun)

# Convert sun into xts. Save this as sun_xts
sun_xts <- as.xts(sun)
head(sun_xts)

# ------------------------------------------------------------------------

# time based queries
### A["20090825"]       ## Aug 25, 2009
### A["201203/201212"]  ## Mar to Dec 2012
### A["/201601"]        ## Up to and including January 2016
path <- set_here("~/STEM_Education/Data Analysis Lessons/8. DATA PREP")
x <- readxl::read_excel("data_1.xls", sheet = 1)
x[,"DATE"] <- as.Date('Jun-15',format = '%m %Y, %d')
x <- as.xts(x)

# Select all of 2016 from x
x_2016 <- x["2010"]


# Select January 1, 2016 to March 22, 2016
jan_march <- x["2016/2016-03-22"]

# Verify that jan_march contains 82 rows
82 == length(jan_march)

# Extracting recurring intraday intervals
# Intraday times for all days
# NYSE["T09:30/T16:00"] 
# Extract all data between 8AM and 10AM
morn_2010 <- irreg["T08:00/T10:00"]

# Extract the observations for January 13th, 2010
morn_2010["2010-01-13"]


# Row selection with time objects
# Subset x using the vector dates
x[dates]

# Subset x using dates as POSIXct
x[as.POSIXct(dates)]

# Replace the values in x contained in the dates vector with NA
x[dates] <- NA

# Replace all values in x for dates starting June 9, 2016 with 0
x["2016-06-09/"] <- 0

# Verify that the value in x for June 11, 2016 is now indeed 0
x["2016-06-11"]


# ------------------------------------------------------------------------

# Additional Methods To Find Periods in Your Data
## Using the first() and last() functions

# Create lastweek using the last 1 week of temps
lastweek <- last(temps, "1 week")

# Print the last 2 observations in lastweek
last(lastweek, 2)

# Extract all but the first two days of lastweek
first(lastweek, "-2 days")

# Extract the first three days of the second week of temps
first(last(first(temps, "2 weeks"), "1 week"), "3 days")

# ------------------------------------------------------------------------
# Math operations in xts
# Matrix arithmetic - add, subtract, multiply, and divide in time!
## Use coredata() or as.numeric() (drop one to a matrix or vector).
## Manually shift index values - i.e. use lag().
## Reindex your data (before or after the calculation).

a <- xts(x = 1:2, as.Date("2012-01-01") + 0:1)
a[index(a)]


a <- xts(x = 1:2, as.Date("2012-01-01") + 0:1)
a[index(a)]

b <- xts(x = 1:2, as.Date("2013-01-01") + 0:1)
b[index(b)]


# Add a and b
a + b

# Add a with the numeric value of b
a + as.numeric(b)


# Add a to b, and fill all missing rows of b with 0
a + merge(b, index(a), fill = 0)

# Add a to b and fill NAs with the last observation
a + merge(b, index(a), fill = na.locf)

# Merging time series
# Perform an inner join of a and b
merge(a, b, join = "inner")

# Perform a left-join of a and b, fill missing values with 0
merge(a, b, join = "left", fill = 0)

# Combining xts by row with rbind
# Row bind a and b, assign this to temps2
temps2 <- rbind(a, b)
temps_2

# ------------------------------------------------------------------------

# Handling missingness in your data

## Airpass data: install.packages("TSA") and library(TSA)
data("airpass")
head(airpass)

# Fill missing values in temps using the last observation
temps_last <- na.locf(airpass)
print(temps_last)

# Fill missing values in temps using the next observation
# Fill missing values using last or previous observation
# # Last obs. carried forward
## na.locf(x)                

# Next obs. carried backward
## na.locf(x, fromLast = TRUE)
## locf = last object carried forward

temps_next <- na.locf(airpass, fromLast = TRUE)
print(temps_next)

# NA interpolation using na.approx()
# Interpolate NAs using linear approximation

na.approx(airpass)

# ------------------------------------------------------------------------

# Lag operators and difference operations
# Combine a leading and lagging time series
## # Your final object
## cbind(lead_x, x, lag_x)

# Create a leading object called lead_x
lead_x <- lag(airpass, k = -1)
print(lead_x)

# Create a lagging object called lag_x
## The k argument in zoo uses positive values for shifting past observations forward and negative values for shifting them backwards
lag_x  <- lag(airpass, k = 1)
print(lag_x)

# Merge your three series together and assign to z
z <- merge(lead_x, x, lag_x)

## Calculate a difference of a series using diff()
# Calculate the first difference of AirPass using lag and subtraction

## # These are the same
### diff(x, differences = 2)
### diff(diff(x))

diff_by_hand <- airpass - lag(airpass)
print(diff_by_hand)

# Use merge to compare the first parts of diff_by_hand and diff(AirPass)
merge(head(diff_by_hand), head(diff(airpass)))

# Calculate the first order 12 month difference of AirPass
diff(airpass, lag = 12, differences = 1)

# ------------------------------------------------------------------------

# One of the benefits to working with time series objects is how easy it is to apply functions by time.
# Apply by Time

# Locate the years
endpoints(airpass, on = "years")

# Locate every two years
## In order to find the end of the second year, you should set k = 2 in your second endpoints() call.
endpoints(airpass, on = "years", k = 2)

# Calculate the yearly endpoints
ep <- endpoints(airpass, on = "years")

# Now calculate the weekly mean and display the results
period.apply(airpass[, "Temp.Mean"], INDEX = ep, FUN = mean)

## Using lapply() and split() to apply functions on intervals
# Split temps by years
temps_yearly <- split(airpass, f = "years") # could also split by "months" etc.

# Create a list of weekly means, temps_avg, and print this list
temps_avg <- lapply(X = temps_yearly, FUN = mean)
temps_avg

## Selection by endpoints vs. split-lapply-rbind
# Use the proper combination of split, lapply and rbind
temps_1 <- do.call(rbind, lapply(split(airpass, "years"), function(w) last(w)))
temps_1

# Create last_day_of_weeks using endpoints()
last_year_of_data <- endpoints(airpass, "years")
last_year_of_data

# Subset airpass using last_year_of_data 
temps_2 <- airpass[last_year_of_data]
temps_2

# ------------------------------------------------------------------------

# Convert univariate series to OHLC data
## Aggregating time series
## in financial series it is common to find Open-High-Low-Close data (or OHLC) calculated over some repeating and regular interval.
path <- set_here("~/STEM_Education/Data Analysis Lessons/8. DATA PREP")
usd_eur <- readxl::read_excel("data_1.xls", sheet = 2)

ts_b <- xts(x = 1:5, order.by = as.POSIXct(dates))


# Convert usd_eur to weekly and assign to usd_eur_weekly
usd_eur_weekly <- to.period(usd_eur, period = "weeks")

# Convert usd_eur to monthly and assign to usd_eur_monthly
usd_eur_monthly <- to.period(usd_eur, period = "months")

# Convert usd_eur to yearly univariate and assign to usd_eur_yearly
usd_eur_yearly <- to.period(usd_eur, period = "years", OHLC = FALSE)


# Convert eq_mkt to quarterly OHLC
mkt_quarterly <- to.period(usd_eur, period = "quarters")

# Convert eq_mkt to quarterly using shortcut function
mkt_quarterly2 <- to.quarterly(usd_eur, name = "edhec_equity", indexAt = "firstof")

# ------------------------------------------------------------------------

# Rolling functions - apply windowing functions to time series data

path <- set_here("~/STEM_Education/Data Analysis Lessons/8. DATA PREP")
edhec <- readxl::read_excel("data_1.xls", sheet = 3)

edhec <- xts(edhec, order.by = as.Date(rownames(edhec), "%Y/%m/%d"))
dat_zoo <- read.zoo(edhec, index.column = 0, sep = ",", format = "%Y/%m/%d")
dat_xts <- as.xts(dat_zoo)


# Split edhec into years
edhec_years <- split(edhec, f = "years")

# Use lapply to calculate the cumsum for each year in edhec_years
edhec_ytd <- lapply(edhec_years, FUN = cumsum)

# Use do.call to rbind the results
edhec_xts <- do.call(rbind, edhec_ytd)

# Calculate the rolling standard deviation of a time series
# Use rollapply to calculate the rolling 3 period sd of edhec
eq_sd <- rollapply(edhec, 3, sd)
eq_sd

# ------------------------------------------------------------------------

# Index, Attributes, and Timezones

# View the first three indexes of temps
index(edhec)[1:3]

# Get the index class of temps
indexClass(edhec)

# Get the timezone of temps
indexTZ(edhec)

# Change the format of the time display
indexFormat(edhec) <- "%Y-%m-%d"

# View the new format
head(edhec)

# Construct times_xts with tzone set to America/Chicago
times_xts <- xts(1:10, order.by = times, tzone = "America/Chicago")

# Change the time zone of times_xts to Asia/Hong_Kong
tzone(times_xts) <- "Asia/Hong_Kong"

# Extract the current time zone of times_xts
tzone(times_xts)

# ------------------------------------------------------------------------

# Periods, Periodicity and Timestamps

# Calculate the periodicity of edhec
periodicity(edhec)

# Convert edhec to yearly
edhec_yearly <- to.yearly(edhec)

# Calculate the periodicity of edhec_yearly
periodicity(edhec_yearly)

# Count the months
nmonths(edhec)

# Count the quarters
nquarters(edhec)

# Count the years
nyears(edhec)


# Explore underlying units of temps in two commands: .index() and .indexwday()
.index(edhec)
.indexwday(edhec)

# Create an index of weekend days using which()
index <- which(.indexwday(edhec) == 0 | .indexwday(edhec) == 6)

# Select the index
edhec[index]


# Make edhec have unique timestamps
z_unique <- make.index.unique(edhec, eps = 1e-4)

# Remove duplicate times in edhec
z_dup <- make.index.unique(edhec, drop = TRUE)

# Round observations in edhec to the next hour
z_round <- align.time(edhec, n = 3600)
