# Automatically install required packages if missing
required_packages <- c("data.table", "ggplot2")
for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

# Load required packages
library(data.table)
library(ggplot2)

# Create results folder if it doesn't exist
if(!dir.exists("results")) dir.create("results")

# Load CSVs into data.tables
film <- fread("data/film.csv")
language <- fread("data/language.csv")
customer <- fread("data/customer.csv")
store <- fread("data/store.csv")
payment <- fread("data/payment.csv")
staff <- fread("data/staff.csv")
rental <- fread("data/rental.csv")

# 1. Films with rating PG and rental duration > 5 days
pg_films <- film[rating == "PG" & rental_duration > 5]
fwrite(pg_films, "results/q1_pg_films.csv")

# 2. Average rental rate of films grouped by rating
avg_rental <- film[, .(avg_rental_rate = mean(rental_rate)), by = rating]
fwrite(avg_rental, "results/q2_avg_rental_by_rating.csv")

# 3. Total number of films in each language
films_with_language <- merge(film, language, by.x = "language_id", by.y = "language_id")
film_count_language <- films_with_language[, .N, by = name]
setnames(film_count_language, "N", "total_films")
fwrite(film_count_language, "results/q3_film_count_by_language.csv")

# 4. Customers’ names and the store they belong to
customers_store <- merge(customer, store, by.x = "store_id", by.y = "store_id")
customers_store <- customers_store[, .(first_name, last_name, store_id)]
fwrite(customers_store, "results/q4_customers_store.csv")

# 5. Payment amount, payment date, and staff who processed each payment
payment_staff <- merge(payment, staff, by.x = "staff_id", by.y = "staff_id")
payment_info <- payment_staff[, .(amount, payment_date, staff_first_name = first_name, staff_last_name = last_name)]
fwrite(payment_info, "results/q5_payment_staff.csv")

# 6. Films that are not rented
rented_films <- unique(rental$film_id)
unrented_films <- film[!(film_id %in% rented_films)]
fwrite(unrented_films, "results/q6_unrented_films.csv")

# 7. Plot: Number of films by rating
plot <- ggplot(film, aes(x = rating)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Number of Films by Rating", x = "Rating", y = "Count")
ggsave("visualizations/q7_films_by_rating.png", plot = plot)
