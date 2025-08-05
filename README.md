
# Dynamic Flutter Form Builder
A dynamic form builder for Flutter that generates forms from remote or local data, designed with clean architecture principles.

# 🚀 Purpose
This project provides a robust solution for dynamically building and rendering Flutter forms. 
It fetches form schemas from a data source (e.g., a remote API or a local JSON file) and constructs the corresponding UI widgets. The architecture ensures that the logic for form generation is highly scalable, testable, and decoupled from the data source, making it easy to adapt to various backend systems.


# 🧠 Design Principles
Clean Architecture: The project is structured with a clear separation of concerns, dividing the code into domain, data, and presentation layers. This enhances maintainability and testability.

Decoupled Logic: The core form generation logic is not tied to any specific data source. You can easily switch the implementation of the `FormDataSource` interface to fetch data from a different source without altering the rest of the application.

# 🧩 Key Classes and Their Roles
Class Roles:

`InputField`:	An abstract base class defining common attributes for all form fields (id, title, isRequired, inputType). Concrete subclasses like TextInputField, SelectInputField, and FileInputField handle specific input types.

`FormController`:	A StateNotifier that manages the UI state of the form, including loading, success, or error states. It also holds the current list of fields and exposes a reload() method to refresh the form state.

`FormRepository`:	Acts as a bridge between the data layer and the application logic. It uses a FormDataSource to retrieve the form schema and parses it into usable InputField models.

`FormDataSource`:	Handles the logic for retrieving and submitting form data. It uses a parser to convert raw JSON into the appropriate input models, abstracting away the data source details.
# 🧪 Testing Strategy
The project includes testing suite to ensure reliability and correctness.

# ✅ Unit Tests

form_parser_test.dart: Validates the parsing logic that maps raw data (e.g., JSON) to the InputField Dart objects. This ensures that the data models are correctly created from the source.

form_controller_test.dart: Confirms that the FormController correctly manages and updates its state in response to actions like reload(), ensuring the UI state is always accurate.

# 🔁 Integration Test

fetch_form_process_integration_test.dart: This test simulates the end-to-end process of fetching form data. It uses a mocked data source to verify that the entire flow—from the repository fetching data to the controller updating its state with the correct form fields—works as expected.

# 🛠️ Highlights
State Management: Utilizes StateNotifier for clean and reactive state management.

Polymorphism: Supports multiple input types (text, file, select, etc.) through polymorphic `InputField` subclasses.

Testability: Designed to be highly testable, allowing for easy mocking of data sources and controllers.

