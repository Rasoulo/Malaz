# What's Remote Directory?

- The `remote` directory contains data sources that fetch data from the network.

## - How it works?
Each data source in this directory is responsible for communicating with a specific API endpoint. It handles making HTTP requests and parsing the JSON responses into data models. It will throw an `Exception` if an error occurs (e.g., `ServerException` for server errors, `NetworkException` for network errors).

* **Why is that?**
This isolates the network communication logic. The repository implementation will call methods from these data sources and catch any exceptions, converting them into `Failure` objects for the domain layer.
