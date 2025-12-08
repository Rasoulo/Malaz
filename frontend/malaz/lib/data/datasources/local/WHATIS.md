# What's Local Directory?

- The `local` directory contains data sources that manage data stored on the device.

## - How it works?
Data sources in this directory interact with local storage mechanisms like a local database (e.g., SQLite, Hive) or key-value stores (e.g., SharedPreferences). They are responsible for caching data that was fetched from the network, or storing user-specific data like session tokens.

* **Why is that?**
Caching data locally improves performance by reducing the number of network requests and allows the app to be used offline. The repository implementation will typically check the local data source for data before attempting to fetch it from the remote data source.
