# Flutter Common Widgets Reference

🧱 1. Layout Widgets
These define how widgets are arranged on the screen.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| Row | Arrange widgets horizontally | Can control mainAxis and crossAxis alignment |
| Column | Arrange widgets vertically | Similar to Row but in vertical direction |
| Stack | Place widgets on top of each other | Use Positioned for precise control |
| Expanded | Make a child take all remaining space | Must be inside Row/Column |
| Flexible | Make a child flexible in how much space it takes | More configurable than Expanded |
| Wrap | Wrap widgets in multiple lines | Great for dynamic content |
| Align | Align a widget within its parent | Uses alignment property |
| Padding | Add space around a widget | Accepts EdgeInsets |
| Center | Center a child in its parent | Shorthand for Align.center |
| SizedBox | Add fixed space or size | Can create empty space |
| ConstrainedBox | Add size constraints | More control than SizedBox |
| AspectRatio | Enforce aspect ratio | Useful for responsive design |
| FractionallySizedBox | Size as fraction of parent | Great for responsive layouts |
| LayoutBuilder | Build based on parent constraints | Advanced layout control |
| CustomSingleChildLayout | Custom layout delegate | For complex single-child layouts |
| CustomMultiChildLayout | Custom multi-child layout | For complex multi-child layouts |

📌 When to use: Anytime you want to structure or align UI elements.

🎨 2. UI / Visual Widgets
These display content and styles to the user.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| Text | Show text with style | Rich formatting options |
| SelectableText | Selectable text | Allows copy/paste |
| RichText | Text with multiple styles | More control than Text.rich |
| Icon | Display a material icon | Built-in icon set |
| Image | Show images | Supports various sources |
| Container | Combine layout + decoration | Swiss army knife widget |
| Card | Material design card | Elevated container |
| CircleAvatar | Round images/icons | Great for profiles |
| Divider | Horizontal line divider | Configurable thickness |
| FlutterLogo | Flutter branding | For development |
| Placeholder | Temporary widget | For prototyping |
| Chip | Compact element | Material design element |
| Badge | Show notifications | Overlay indicators |
| Banner | Show message banner | App-wide messages |
| Tooltip | Show hover information | User guidance |

📌 When to use: For rendering UI elements like text, images, icons, etc.

📲 3. Input Widgets (Form & Control)
Used to capture user input.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| TextField | Accept text input | Basic text input field |
| TextFormField | Form-aware TextField | Integrated with forms |
| Checkbox | Toggle boolean values | On/off switch |
| Radio | Select a single option | Exclusive choices |
| Switch | Toggle between on/off | Material design switch |
| Slider | Select from a range of values | Sliding scale input |
| DropdownButton | Select from a dropdown menu | Compact selection |
| Form, FormField | Handle form state and validation | Manage form inputs |

📌 When to use: When you need forms, filters, or user input.

🧭 4. Navigation & Routing Widgets
Widgets for navigating between screens/routes.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| Navigator | Push/pop screens manually | Manage stack of screens |
| MaterialPageRoute | Define a new route with animation | Standard page transition |
| PageView | Swipeable pages like onboarding | Horizontal/vertical swiping |
| BottomNavigationBar | Tabbed navigation at bottom | Switch between top-level views |
| Drawer | Side drawer menu | Hidden navigation panel |
| TabBar, TabView | Tab-based navigation | Organize content into tabs |
| ScaffoldMessenger | Show snackbars across screens | Manage snackbars in app |

📌 When to use: To build multi-screen apps or nested navigation.

🎛 5. Interactive Widgets
Respond to gestures and interactions.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| GestureDetector | Detect taps, swipes, etc. | Low-level gesture recognition |
| InkWell | Material-design ripple tap | Ink splash effect |
| ElevatedButton | Raised button | Material design elevated button |
| TextButton | Flat button | No elevation, just text |
| IconButton | Clickable icon | Icon with tap feedback |
| FloatingActionButton | FAB (floating button) | Circular button for primary action |
| Draggable, DragTarget | Drag and drop support | Reorder or move items |

📌 When to use: When user needs to tap or interact with the UI.

🌐 6. Async & State Widgets
Handle future, streams, and dynamic state.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| FutureBuilder | Show UI based on a Future result | Async snapshot handling |
| StreamBuilder | Show UI based on a Stream | Reactive to stream events |
| ValueListenableBuilder | React to ValueNotifier changes | Rebuilds on value changes |
| AnimatedBuilder | Build animation-based widgets | Rebuilds on animation changes |

📌 When to use: For reactive programming, API loading, or animations.

🧠 7. State Management Widgets
Manage and pass state/data.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| StatefulWidget | Store and react to local state | Basic state management |
| InheritedWidget | Pass data down the tree | Efficient data sharing |
| Provider (package) | Access and manage global state | Popular state management solution |
| BlocBuilder, GetBuilder, Riverpod | Community state mgmt tools | Various state management approaches |

📌 When to use: When data needs to be shared or persisted between widgets.

🖼 8. Scrolling Widgets
Handle lists and scrolling behavior.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| ListView | Scrollable list | Basic scrolling list |
| GridView | Scrollable grid | 2D array of widgets |
| SingleChildScrollView | Make one widget scrollable | Wraps a single child |
| CustomScrollView | Advanced scrollable areas | Slivers for custom effects |
| SliverList, SliverAppBar | Flexible scroll effects | Integrates with slivers |

📌 When to use: When content overflows the screen or needs performance optimization.

🧩 9. Animation & Motion Widgets
Used for animations and transitions.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| AnimatedContainer | Smoothly animate container properties | Implicitly animated container |
| Hero | Shared element transition | Animate widget between screens |
| FadeTransition, ScaleTransition | Custom transitions | Fine-grained control over transitions |
| TweenAnimationBuilder | Animate values over time | Tween-based animations |
| Lottie (package) | Play Lottie animation files | Render animations from JSON |

📌 When to use: For making engaging and dynamic UIs.

📦 10. Platform-Specific Widgets
Widgets that adapt to iOS or Android look.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| CupertinoButton | iOS-style button | Matches iOS design language |
| CupertinoNavigationBar | iOS-style app bar | Translucent navigation bar |
| Platform.isIOS check | Conditionally render Android or iOS widgets | Adaptive layouts |

📌 When to use: For platform-specific designs or look-and-feel.

🌊 11. Sliver Widgets
For advanced scrolling effects.

| Widget | Use Case | Additional Notes |
|--------|----------|-----------------|
| SliverAppBar | Collapsing toolbar | Animated header |
| SliverList | Lazy-loading list | Better performance |
| SliverGrid | Lazy-loading grid | Grid with scrolling |
| SliverToBoxAdapter | Regular widget in sliver | Bridge to normal widgets |
| SliverFillRemaining | Fill remaining space | Useful for forms |
| SliverPersistentHeader | Sticky headers | Custom scroll effects |
| SliverPadding | Sliver with padding | Spacing in CustomScrollView |
| SliverFixedExtentList | Fixed-height items | Better performance |
| SliverPrototypeExtentList | Template-based sizing | Consistent sizes |
| SliverFillViewport | Fill viewport pages | Full-screen sections |

📌 When to use: For advanced scrolling behaviors and effects.

