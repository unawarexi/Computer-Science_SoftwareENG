# 📦 Flutter BLoC (Business Logic Component) - Complete Guide

## 📖 Table of Contents

- [What is BLoC?](#-what-is-bloc)
- [Why use BLoC?](#-why-use-bloc)
- [When to use BLoC](#-when-to-use-bloc)
- [Core Principles](#-core-principles)
- [BLoC vs Cubit](#-bloc-vs-cubit)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [How BLoC Works](#-how-bloc-works)
- [Step-by-Step Example](#-step-by-step-example)
  - [1. Define Events](#1-define-events)
  - [2. Define States](#2-define-states)
  - [3. Implement BLoC](#3-implement-bloc)
  - [4. Provide BLoC](#4-provide-bloc)
  - [5. Use BLoC in UI](#5-use-bloc-in-ui)
- [Cubit - Simpler Alternative](#-cubit---simpler-alternative)
- [Best Practices](#-best-practices)
- [Common Pitfalls](#-common-pitfalls)
- [Testing BLoC](#-testing-bloc)
- [Advanced Topics](#-advanced-topics)
- [Useful Packages](#-useful-packages)
- [Resources](#-resources)
- [License](#-license)

---

## 🧠 What is BLoC?

**BLoC (Business Logic Component)** is a design pattern for managing state and logic separately from the UI. It uses **Streams and Sinks** to send and receive data, ensuring **clean separation of concerns** between presentation and business logic layers.

BLoC was introduced by **Google** and became one of the most recommended state management patterns in Flutter.

---

## ❓ Why Use BLoC?

- 🧼 **Clean Architecture**: Separates UI and logic.
- 🔄 **Reactive**: Listens to changes using streams.
- 📦 **Reusable**: Logic can be reused across widgets.
- 🔬 **Testable**: Easily test business logic without UI.
- 🌍 **Scalable**: Great for large applications.
- 👥 **Team Collaboration**: Helps developers work in parallel.

---

## ⏳ When to Use BLoC

**Use BLoC when:**
- Your app has **complex state logic**.
- You need **clear separation of concerns**.
- You want **predictable, testable state management**.
- You are building **large or enterprise-scale** applications.
- You work with **multiple developers or teams**.

**Avoid BLoC for:**
- Very simple apps with minimal state logic.
- Quick prototypes or small apps where simpler solutions (like `setState`, `Provider`) suffice.

---

## 📚 Core Principles

- **Unidirectional Data Flow**
- **Event → Logic → State**
- **Streams for Output**, **Sinks for Input**
- **Immutable States**
- **State Mapping using `mapEventToState()`**

---

## ⚖️ BLoC vs Cubit

| Feature    | BLoC                     | Cubit                    |
|------------|--------------------------|--------------------------|
| Complexity | High                     | Lower                    |
| Events     | Required                 | Not required             |
| Use case   | Complex logic            | Simpler state management |
| Extends    | `Bloc<Event, State>`     | `Cubit<State>`           |

---

## 🧩 Installation

```bash
flutter pub add flutter_bloc
```

Also, for hydrated state or easier testing:

```bash
flutter pub add hydrated_bloc bloc_test
```

Import in Dart files:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
```

---

## 🗂️ Project Structure

```
lib/
├── bloc/
│   ├── counter_bloc.dart
│   ├── counter_event.dart
│   └── counter_state.dart
├── screens/
│   └── counter_screen.dart
├── main.dart
```

---

## ⚙️ How BLoC Works

The BLoC pattern works by separating your app's business logic from its UI. This is achieved by using **Events** (which represent user actions or triggers), **States** (which represent the UI's current condition), and the **BLoC** itself (which handles the logic of converting events into new states).

Here's a simple flow diagram:

```
[ UI ] -> dispatch(Event) -> [ BLoC ] -> yield(State) -> [ UI ]
```

- **UI dispatches Events:**  
  When a user interacts with the UI (like tapping a button), the UI sends an **Event** to the BLoC.  
  Example: User taps "+" button → UI dispatches `Increment` event.

- **BLoC maps Event to new State:**  
  The BLoC receives the event and contains logic to determine what should happen. It processes the event and emits a new **State** based on the logic.  
  Example: On `Increment` event, BLoC increases the counter and emits a new state with the updated value.

- **UI rebuilds based on new State:**  
  The UI listens to the BLoC's state stream. When a new state is emitted, the UI rebuilds itself to reflect the latest state.  
  Example: The counter text updates to show the new value.

This cycle ensures a **unidirectional data flow**:  
User Action → Event → BLoC Logic → State → UI Update

---

## 🧪 Step-by-Step Example

Let's break down a simple counter app using BLoC:

### 1. Define Events

Events are classes that represent actions or occurrences in your app.  
For a counter, we might have two events: increment and decrement.

```dart
abstract class CounterEvent {} // Base class for all events

class Increment extends CounterEvent {} // Event for increasing the counter

class Decrement extends CounterEvent {} // Event for decreasing the counter
```

- `CounterEvent` is the abstract base class.
- `Increment` and `Decrement` extend `CounterEvent` and represent specific actions.

### 2. Define States

States are classes that represent the data or condition of the UI at any given time.

```dart
class CounterState {
  final int counter;

  CounterState(this.counter);
}
```

- `CounterState` holds the current value of the counter.
- States should be **immutable** (not changed after creation) for predictability.

### 3. Implement BLoC

The BLoC receives events, processes them, and emits new states.

```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    // When an Increment event is received, emit a new state with counter + 1
    on<Increment>((event, emit) => emit(CounterState(state.counter + 1)));
    // When a Decrement event is received, emit a new state with counter - 1
    on<Decrement>((event, emit) => emit(CounterState(state.counter - 1)));
  }
}
```

- `CounterBloc` extends `Bloc<CounterEvent, CounterState>`.
- The constructor sets the initial state to `CounterState(0)`.
- The `on<EventType>` method registers handlers for each event type.
  - When `Increment` is added, the counter increases by 1.
  - When `Decrement` is added, the counter decreases by 1.
- The `emit` function outputs the new state, which the UI listens to.

---

### 4. Provide BLoC

```dart
void main() {
  runApp(
    BlocProvider(
      create: (_) => CounterBloc(),
      child: MyApp(),
    ),
  );
}
```

### 5. Use BLoC in UI

```dart
class CounterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<CounterBloc, CounterState>(
          builder: (context, state) {
            return Text('Count: ${state.counter}');
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(Increment()),
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(Decrement()),
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
```

---

## 🧪 Cubit - Simpler Alternative

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

Provide Cubit:

```dart
BlocProvider(
  create: (_) => CounterCubit(),
  child: CounterScreen(),
);
```

Use in UI:

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, count) => Text('Count: $count'),
);
```

---

## 🧠 Best Practices

- Use Equatable for comparing states.
- Keep logic in BLoC, not in UI.
- Keep states immutable.
- Name events and states clearly.
- Dispose BLoC where necessary if not using BlocProvider.

---

## ⚠️ Common Pitfalls

- Placing heavy logic in UI.
- Forgetting to use BlocProvider.
- Not using Equatable, causing unnecessary rebuilds.
- Not testing BLoC logic.

---

## 🧪 Testing BLoC

Add bloc_test:

```bash
flutter pub add bloc_test
```

Example test:

```dart
blocTest<CounterBloc, CounterState>(
  'emits [1] when Increment is added',
  build: () => CounterBloc(),
  act: (bloc) => bloc.add(Increment()),
  expect: () => [CounterState(1)],
);
```

---

## 🚀 Advanced Topics

- Hydrated BLoC – persist state with local storage
- MultiBlocProvider – provide multiple BLoCs
- BlocListener – respond to state changes (e.g., show dialog)
- BlocSelector – optimize rebuilds
- State Composition – for complex state modeling

---

## 📦 Useful Packages

- flutter_bloc
- bloc
- hydrated_bloc
- equatable
- bloc_test

---

## 📚 Resources

- [Official BLoC Docs](https://bloclibrary.dev/#/)
- [Felix Angelov’s GitHub](https://github.com/felangel)
- [Reso Coder - BLoC Tutorial](https://resocoder.com/flutter-bloc/)
- [Flutter Dev YouTube - Streams and BLoC](https://www.youtube.com/watch?v=LeLrsnHeCZY)

---

## 🪪 License

MIT © Andrew Chukwuweike  
For educational and commercial use. Customize as needed.

