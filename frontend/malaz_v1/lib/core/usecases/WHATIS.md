# What's Usecases Directory?

- The `core/usecases` directory contains the formula of the `usecases` in the project take a look to the example below for better understanding.

## - Usecase File

A use case file defines a single task, like fetching data from a repository or signing in a user. It acts as a bridge between the presentation layer and the data layer.

* **Why is that?**
This approach, central to Clean Architecture, we use `usecases` in UI's and cubits to order something from repositories. 

* **How it works?**
A use case typically has a single public method (`call`) that is executed by the presentation layer. This method coordinates with repositories to get the job done and returns a result, usually as an `Either<Failure, SuccessType>` to handle both success and error states gracefully.

* **Example:**
```

LoginButton -> LoginUseCase -> LoginRepo -> LoginDataSource -> backend

```
