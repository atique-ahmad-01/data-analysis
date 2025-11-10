# Sakila Database Analysis Report

**Author:** Atique Ahmad | MSDS25030
**Date:** 10-Nov-2025

## Project Overview

This project analyzes the Sakila database using **R** and the **data.table** package. Queries were performed to explore film data, customers, rentals, and payments. A visualization was created to summarize film ratings.

## 1. Films with rating PG and rental duration > 5 days

**Query:** Filter films with `rating = 'PG'` and `rental_duration > 5`.

**R Code:**

```r
pg_films <- film[rating == "PG" & rental_duration > 5]
fwrite(pg_films, "results/q1_pg_films.csv")
```

*Saved as `results/q1_pg_films.csv`*

---

## 2. Average rental rate of films grouped by rating

**Query:** Calculate average rental rate per film rating.

**R Code:**

```r
avg_rental <- film[, .(avg_rental_rate = mean(rental_rate)), by = rating]
fwrite(avg_rental, "results/q2_avg_rental_by_rating.csv")
```

*Saved as `results/q2_avg_rental_by_rating.csv`*

---

## 3. Total number of films in each language

**Query:** Count films by language.

**R Code:**

```r
films_with_language <- merge(film, language, by.x = "language_id", by.y = "language_id")
film_count_language <- films_with_language[, .N, by = name]
setnames(film_count_language, "N", "total_films")
fwrite(film_count_language, "results/q3_film_count_by_language.csv")
```

*Saved as `results/q3_film_count_by_language.csv`*

---

## 4. Customers’ names and the store they belong to

**Query:** List customers with their store ID.

**R Code:**

```r
customers_store <- merge(customer, store, by.x = "store_id", by.y = "store_id")
customers_store <- customers_store[, .(first_name, last_name, store_id)]
fwrite(customers_store, "results/q4_customers_store.csv")
```
*Saved as `results/q4_customers_store.csv`*

---

## 5. Payment amount, date, and staff who processed it

**Query:** Combine payment and staff info.

**R Code:**

```r
payment_staff <- merge(payment, staff, by.x = "staff_id", by.y = "staff_id")
payment_info <- payment_staff[, .(amount, payment_date, staff_first_name = first_name, staff_last_name = last_name)]
fwrite(payment_info, "results/q5_payment_staff.csv")
```

*Saved as `results/q5_payment_staff.csv`*

---

## 6. Films that are not rented

**Query:** Find films without rentals.

**R Code:**

```r
rented_films <- unique(rental$film_id)
unrented_films <- film[!(film_id %in% rented_films)]
fwrite(unrented_films, "results/q6_unrented_films.csv")
```

*Saved as `results/q6_unrented_films.csv`*

---

## 7. Visualization: Number of films by rating

**Query:** Create a bar plot showing the number of films per rating.

**R Code:**

```r
plot <- ggplot(film, aes(x = rating)) +
  geom_bar(fill = "steelblue") +
  theme_minimal() +
  labs(title = "Number of Films by Rating", x = "Rating", y = "Count")
ggsave("visualizations/q7_films_by_rating.png", plot = plot)
```

**Plot:**
![Number of Films by Rating](/visualizations/q7_films_by_rating.png)

---

## Conclusion

This analysis shows:

* PG-rated films with longer rental durations.
* Average rental rates grouped by film rating.
* Film distribution by language.
* Customer-store associations.
* Payment tracking with staff info.
* Identification of unrented films.
* A clear visualization of film ratings.

All outputs are saved in the `results/` and `visualizations/` folders for further inspection.

