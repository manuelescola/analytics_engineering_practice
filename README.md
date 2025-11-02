# Analytics Engineering Practice Project

A data analytics engineering practice project implementing a modern data pipeline using **dbt** (data build tool) and **DuckDB**. This project demonstrates the medallion architecture pattern with bronze, silver, and gold layers for retail data analytics.

## 📁 Project Structure

```
analytics_engineering_practice/
├── data/
│   └── source/
│       ├── batch_1/          # Initial data batch
│       └── batch_2/          # Subsequent data batch
│           ├── customers.csv
│           ├── orders.csv
│           ├── order_items.csv
│           └── products.csv
├── dbt/
│   └── retail_duckdb/        # dbt project root
│       ├── models/
│       │   ├── bronze/       # Raw data ingestion layer
│       │   ├── silver/       # Cleaned and validated data layer
│       │   └── gold/         # Business-ready analytics layer
│       ├── snapshots/        # SCD Type 2 dimension tracking
│       └── README.md
└── warehouse/
    └── warehouse.duckdb      # DuckDB database file
```

## 🏗️ Architecture

This project follows the **Medallion Architecture** pattern:

### Bronze Layer (`models/bronze/`)
- **Purpose**: Raw data ingestion from source CSV files
- **Materialization**: Incremental tables
- **Models**:
  - `bronze_customers.sql`
  - `bronze_orders.sql`
  - `bronze_order_items.sql`
  - `bronze_products.sql`

### Silver Layer (`models/silver/`)
- **Purpose**: Cleaned, validated, and standardized data
- **Materialization**: Views
- **Transformations**:
  - Data type casting
  - Trimming whitespace
  - Normalizing text (lowercase, etc.)
  - Data quality checks via schema tests
- **Models**:
  - `silver_vw_customers.sql`
  - `silver_vw_orders.sql`
  - `silver_vw_order_items.sql`
  - `silver_vw_products.sql`

### Gold Layer (`models/gold/`)
- **Purpose**: Business-ready dimensional models and fact tables
- **Materialization**: Tables (with incremental loading where applicable)
- **Models**:
  - **Fact Tables**:
    - `gold_fact_sales.sql` - Incremental fact table with SCD2 lookups
  - **Dimension Tables**:
    - `gold_dim_customers.sql` - Customer dimension
    - `gold_dim_customers_current.sql` - Current customer snapshot
    - `gold_dim_products.sql` - Product dimension
    - `gold_dim_products_current.sql` - Current product snapshot
    - `gold_dim_date.sql` - Date dimension

### Snapshots (`snapshots/`)
- **Purpose**: Track historical changes using SCD Type 2 methodology
- **Snapshots**:
  - `dim_customers_scd2.sql` - Customer slow-changing dimension
  - `dim_products_scd2.sql` - Product slow-changing dimension

## 🚀 Getting Started

### Prerequisites
- Python 3.8+
- dbt-core
- dbt-duckdb adapter

### Installation

1. Install dbt and the DuckDB adapter:
```bash
pip install dbt-core dbt-duckdb
```

2. Navigate to the dbt project:
```bash
cd dbt/retail_duckdb
```

3. Configure your dbt profile (if needed) in `~/.dbt/profiles.yml`

### Running the Project

1. **Load data for a specific batch**:
```bash
# Load batch_1
dbt run --vars '{"batch_name": "batch_1", "load_path": "../data/source/batch_1"}'

# Load batch_2
dbt run --vars '{"batch_name": "batch_2", "load_path": "../data/source/batch_2"}'
```

2. **Run all models**:
```bash
dbt run
```

3. **Run tests**:
```bash
dbt test
```

4. **Generate documentation**:
```bash
dbt docs generate
dbt docs serve
```

5. **Run snapshots** (for SCD2 tracking):
```bash
dbt snapshot
```

## 📊 Data Model

The project models a retail e-commerce scenario with:

- **Customers**: Customer master data with loyalty status
- **Products**: Product catalog with pricing information
- **Orders**: Order header information
- **Order Items**: Order line items with quantities and prices

### Key Features

- **Incremental Loading**: Bronze and gold layers use incremental materialization for efficient data processing
- **SCD Type 2**: Dimensions support historical tracking of customer and product changes
- **Data Quality**: Schema tests ensure data integrity at the silver layer
- **Batch Processing**: Supports loading data from multiple batches

## 🔧 Configuration

The project uses variables for batch processing:
- `batch_name`: Identifier for the current batch being loaded
- `load_path`: Path to the source CSV files for the batch

## 📝 Notes

- The warehouse database (DuckDB) is stored in `warehouse/warehouse.duckdb`
- Logs and compiled artifacts are in `target/` directory
- The project follows dbt best practices for modularity and reusability

## 📚 Resources

- [dbt Documentation](https://docs.getdbt.com/)
- [DuckDB Documentation](https://duckdb.org/docs/)
- [dbt Discourse](https://discourse.getdbt.com/)

## 🎯 Learning Objectives

This project demonstrates:
- Modern data transformation practices
- Medallion architecture implementation
- Incremental data loading strategies
- SCD Type 2 dimension modeling
- dbt project organization and best practices
- Data quality testing with dbt

