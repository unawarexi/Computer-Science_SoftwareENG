# Flutter Styling Properties

This table summarizes various styling properties in Flutter, including their descriptions and examples.

---

## 1. **Text Styling Properties**

| **Property**       | **Description**                                       | **Example**                     |
|--------------------|-------------------------------------------------------|---------------------------------|
| `fontSize`         | Controls the size of the text.                        | `fontSize: 24`                  |
| `fontWeight`       | Controls the thickness of the font.                   | `fontWeight: FontWeight.bold`   |
| `fontStyle`        | Italicizes the text.                                  | `fontStyle: FontStyle.italic`   |
| `color`            | Sets the color of the text.                           | `color: Colors.blue`             |
| `letterSpacing`    | Adjusts the space between each letter.                | `letterSpacing: 2.0`             |
| `wordSpacing`      | Adjusts the space between words.                      | `wordSpacing: 4.0`               |
| `shadows`          | Adds shadow to the text.                              | `shadows: [Shadow(...)]`         |

---

## 2. **Container Styling Properties**

| **Property**       | **Description**                                        | **Example**                     |
|--------------------|--------------------------------------------------------|---------------------------------|
| `width`            | Sets the width of the container.                       | `width: 200`                    |
| `height`           | Sets the height of the container.                      | `height: 100`                   |
| `margin`           | Adds outer spacing around the container.               | `margin: EdgeInsets.all(10)`    |
| `padding`          | Adds inner spacing within the container.               | `padding: EdgeInsets.all(20)`    |
| `color`            | Sets the background color of the container.            | `color: Colors.green`            |
| `borderRadius`     | Rounds the corners of the container.                   | `borderRadius: BorderRadius.circular(15)` |
| `boxShadow`        | Adds shadow effect to the container.                   | `boxShadow: [BoxShadow(...)]`    |
| `border`           | Adds a border to the container.                        | `border: Border.all(color: Colors.black)` |

---

## 3. **Button Styling Properties**

| **Button Type**        | **Property**       | **Description**                                        | **Example**                     |
|------------------------|--------------------|--------------------------------------------------------|---------------------------------|
| **ElevatedButton**     | `primary`          | Sets the button background color.                      | `primary: Colors.blue`          |
|                        | `onPrimary`        | Sets the button text color.                            | `onPrimary: Colors.white`       |
|                        | `elevation`        | Adds a shadow effect behind the button.                | `elevation: 5`                  |
|                        | `shape`            | Defines the shape of the button (e.g., rounded).       | `shape: RoundedRectangleBorder(...)` |
| **TextButton**         | `primary`          | Sets the text color of the button.                     | `primary: Colors.red`           |
| **OutlinedButton**     | `side`             | Sets the border color of the button.                   | `side: BorderSide(color: Colors.orange)` |
|                        | `primary`          | Sets the text color of the button.                     | `primary: Colors.orange`         |

---

## 4. **Row and Column Styling Properties**

| **Property**               | **Description**                                                | **Example**                     |
|----------------------------|----------------------------------------------------------------|---------------------------------|
| `mainAxisAlignment`        | Controls the alignment of children along the main axis.        | `MainAxisAlignment.spaceBetween` |
| `crossAxisAlignment`       | Controls the alignment of children along the cross axis.       | `CrossAxisAlignment.center`      |
| `children`                 | Defines the widgets inside the row or column.                  | `children: [Icon(...), Text(...)]` |

---

## 5. **Image Styling Properties**

| **Property**       | **Description**                                        | **Example**                     |
|--------------------|--------------------------------------------------------|---------------------------------|
| `height`           | Sets the height of the image.                          | `height: 200`                   |
| `width`            | Sets the width of the image.                           | `width: 200`                    |
| `fit`              | Defines how the image should fit inside its container. | `fit: BoxFit.cover`             |
| `color`            | Applies a color filter to the image.                   | `color: Colors.blue`            |
| `colorBlendMode`   | Blends the color with the image.                       | `colorBlendMode: BlendMode.darken` |

---

## 6. **List Styling Properties**

| **Property**       | **Description**                                        | **Example**                     |
|--------------------|--------------------------------------------------------|---------------------------------|
| `padding`          | Adds spacing inside the list.                          | `padding: EdgeInsets.all(10)`   |
| `leading`          | Adds a widget to the start of the list item.           | `leading: Icon(Icons.star)`     |
| `title`            | Main text of the list item.                            | `title: Text('First Item')`     |
| `trailing`         | Adds a widget to the end of the list item.             | `trailing: Icon(Icons.arrow_forward)` |

---

## 7. **App Theming Properties**

| **Property**       | **Description**                                        | **Example**                     |
|--------------------|--------------------------------------------------------|---------------------------------|
| `primaryColor`     | Sets the primary color of the app.                     | `primaryColor: Colors.blue`     |
| `accentColor`      | Sets the accent color of the app.                      | `accentColor: Colors.orange`    |
| `textTheme`        | Defines the styles for different text widgets.         | `textTheme: TextTheme(...)`      |
| `buttonTheme`      | Customizes button styles globally.                     | `buttonTheme: ButtonThemeData(...)` |

---

## Conclusion

This guide provides an overview of key styling properties in Flutter. Use this table as a reference to enhance your Flutter applications' design and usability.
