# Sales Marts

TODO: Add explanation of this mart
TODO: Add explanation of each folder in dbt proj

The models in this directory are:
*   'dtm_avg_time_to_5_transactions': Calculates the average time it takes for a store to make its first 5 transactions.
*   'dtm_avg_transacted_amount_by_typology_country': Calculates the average transacted amount for each store typology and country.
*   'dtm_overall_avg_time_to_5_transactions' - Calculates the overall average time to 5 transactions. Instructions were a bit
    ambiguous about granurality of result, then this one just just in case for overall summary. As it was easy to build.
*   'dtm_percentage_transactions_by_device_type': Calculates the percentage of transactions for each device type.
*   'dtm_top_10_products_sold': Ranks the top 10 products by the number of times they were sold.
*   'dtm_top_10_stores_by_amount': Ranks the top 10 stores by total transacted amount.
