# What's Models Directory?

- The `models` directory contains the data models for the application. These models are concrete implementations of the entities defined in the [domain layer](../../domain/entities/WHATIS.md).

## - How it works?
Models often include extra functionality that entities don't have, such as methods for JSON serialization and deserialization (`toJson`, `fromJson`). This keeps the `domain` layer pure and free from any dependency on external data formats.

* **Example:**
```dart
// user_model.dart
import '../../domain/entities/user_entity.dart';

class UserModel extends User {
  // ... properties

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // ... fromJson implementation
  }

  Map<String, dynamic> toJson() {
    // ... toJson implementation
  }
}
```
