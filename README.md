# Google-Location-Data
This is a Shiny app that uses location data from Google Takeout along with self-recorded data to supplement measurements of a cross-country road trip.  For the first few months, Location History was not turned on, and thus the first 15,000 of 47,000 miles of the trip was not accounted for.  So, the timeline starts at the point in which location history was initiated.

Google's location system calculates distance measurments based on linear Euclidean distances between any two points.  While this is a very accurate measure (for most points are tallied just minutes from one another), I increased the accuracy by proportionalizing the linear distances and multoplying by my self-reported mileage to make for the best possible measurment of mileage between any two given points.

Further measurements will be incorporated and updates rolled out over time to perfect the aestehtics and usability of this app.
