# Flutter Widgets Guide

Widgets are the fundamental building blocks of a Flutter application. Everything in Flutter is a widget, from the layout structures to the UI components. This guide outlines key concepts and commonly used Flutter widgets.

## What is a Widget?

In Flutter, **widgets** describe the structure and behavior of the app's user interface. Each widget is immutable, meaning that after it's built, it cannot change. However, if a widget's state needs to change (like user interaction), a new widget is created, and the old one is replaced.

Widgets can be classified into two main types:

- **Stateless Widgets**: These widgets do not maintain any internal state. Once built, they don't change.
- **Stateful Widgets**: These widgets can maintain internal state that changes over time. This is ideal for dynamic content, like user input or animations.

> For a comprehensive list of commonly used widgets, please refer to [Common Widgets Reference](common_widgets.md)

---

## Stateful vs Stateless Widgets

| **Widget Type**      | **Description**                                                                                   |
|----------------------|---------------------------------------------------------------------------------------------------|
| **StatelessWidget**   | A widget that describes part of the UI by building a constellation of other widgets. It does not maintain any state and re-renders only when required. |
| **StatefulWidget**    | A widget that maintains state that may change over time. It's composed of two classes: the `StatefulWidget` and the `State` class. The `State` class holds the widget’s state and is mutable. |

### Example: StatelessWidget
```dart
class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('This is a StatelessWidget');
  }
}
```

## Example: StatefulWidget
```dart
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

## Widget Lifecycle
For StatefulWidget, the widget goes through a lifecycle, which includes the following methods:

- **initState()** – Called once when the widget is first inserted into the widget tree.
- **didChangeDependencies()** – Called when the widget’s dependencies change.
- **build()** – Called when the widget is built or rebuilt.
- **setState()** – Tells Flutter that the widget's state has changed and it needs to be rebuilt.
- **dispose()** – Called when the widget is removed from the widget tree and its resources need to be cleaned up.

### Example of Lifecycle in Stateful Widget
```dart
class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void initState() {
    super.initState();
    print('Widget initialized');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('My Stateful Widget'),
    );
  }

  @override
  void dispose() {
    print('Widget disposed');
    super.dispose();
  }
}
```

## Widget Tree
In Flutter, widgets are arranged in a tree structure called the widget tree. The root of the tree is usually the MaterialApp or CupertinoApp. Each widget can have child widgets, which are arranged in branches that form the widget tree.

- **Parent Widget**: A widget that holds other widgets.
- **Child Widget:** A widget nested inside a parent widget.
- **Sibling Widgets**: Widgets that share the same parent.

## Example of a Widget Tree

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Widget Tree Example'),
        ),
        body: Column(
          children: [
            Text('This is a Text widget.'),
            ElevatedButton(
              onPressed: () {},
              child: Text('This is a Button'),
            ),
          ],
        ),
      ),
    );
  }
}
```

