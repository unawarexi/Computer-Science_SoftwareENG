# Flutter Styling Properties

This table provides an overview of key styling properties in Flutter, describing their use and implementation for widgets.

| Property            | Description                                                                                 | Example Usage                                               |
|---------------------|---------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| `color`             | Sets the background color of the widget.                                                     | `Container(color: Colors.blue)`                             |
| `padding`           | Provides space inside the widget boundary, surrounding its child.                            | `Padding(padding: EdgeInsets.all(16))`                      |
| `margin`            | Adds space outside the widget boundary.                                                      | `Container(margin: EdgeInsets.symmetric(horizontal: 20))`   |
| `width`             | Defines the width of the widget.                                                             | `Container(width: 100)`                                     |
| `height`            | Defines the height of the widget.                                                            | `Container(height: 50)`                                     |
| `alignment`         | Aligns the widget’s child within its bounds.                                                 | `Container(alignment: Alignment.center)`                    |
| `decoration`        | Applies visual effects like borders, gradients, shadows, etc.                                | `Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)))` |
| `borderRadius`      | Rounds the corners of the widget when combined with `BoxDecoration`.                         | `BoxDecoration(borderRadius: BorderRadius.circular(15))`    |
| `boxShadow`         | Adds shadow effects around the widget.                                                       | `BoxDecoration(boxShadow: [BoxShadow(color: Colors.grey)])` |
| `fontSize`          | Specifies the size of the text.                                                              | `TextStyle(fontSize: 20)`                                   |
| `fontWeight`        | Sets the thickness or boldness of the text.                                                  | `TextStyle(fontWeight: FontWeight.bold)`                    |
| `fontStyle`         | Specifies if the text should be italicized.                                                  | `TextStyle(fontStyle: FontStyle.italic)`                    |
| `letterSpacing`     | Controls the space between letters.                                                          | `TextStyle(letterSpacing: 2.0)`                             |
| `textAlign`         | Aligns text horizontally within its container.                                               | `Text(textAlign: TextAlign.center)`                         |
| `overflow`          | Handles the visual behavior when text overflows the widget’s bounds.                         | `Text(overflow: TextOverflow.ellipsis)`                     |
| `flex`              | Determines the proportion of space a widget takes in a `Flex` layout.                        | `Expanded(flex: 2)`                                         |
| `mainAxisAlignment` | Aligns children along the main axis (vertical for `Column`, horizontal for `Row`).            | `Row(mainAxisAlignment: MainAxisAlignment.spaceBetween)`     |
| `crossAxisAlignment`| Aligns children along the cross axis (opposite to the main axis).                            | `Column(crossAxisAlignment: CrossAxisAlignment.start)`       |
| `backgroundBlendMode`| Blends the background color or image with a given `BlendMode`.                              | `Container(color: Colors.red.withOpacity(0.5))`             |
| `transform`         | Applies transformations like translation, rotation, or scaling to a widget.                  | `Transform.rotate(angle: 0.5)`                              |
| `shape`             | Defines the shape of widgets, such as `CircleBorder` or `RoundedRectangleBorder`.             | `BoxDecoration(shape: BoxShape.circle)`                     |
| `border`            | Draws a border around the widget.                                                            | `BoxDecoration(border: Border.all(color: Colors.black))`    |
| `gradient`          | Applies gradient color effects to the widget.                                                | `BoxDecoration(gradient: LinearGradient(colors: [Colors.red, Colors.blue]))` |
| `opacity`           | Sets the transparency level of a widget.                                                     | `Opacity(opacity: 0.8)`                                     |
| `clipBehavior`      | Controls how the content inside the widget is clipped if it overflows its bounds.             | `Container(clipBehavior: Clip.hardEdge)`                    |
| `elevation`         | Adds a shadow to the widget that elevates it above the surrounding elements.                 | `Card(elevation: 5.0)`                                      |

## References
- [Flutter Documentation](https://flutter.dev/docs/development/ui/widgets)
- [Dart API](https://api.flutter.dev/)
