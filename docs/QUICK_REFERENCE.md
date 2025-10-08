# Quick Reference Guide - Code Patterns

A quick reference for common patterns and code snippets used in this project.

## 🎯 When to Use What

| Need | Use | Example File |
|------|-----|--------------|
| Define data structure | **Model** | `models/player.dart` |
| Business logic / CRUD | **Service** | `services/player_service.dart` |
| Reusable validation | **Utils** | `utils/validators.dart` |
| Reusable UI component | **Widget** | `widgets/player_form.dart` |
| Complete page | **Screen** | `screens/add_player_screen.dart` |
| App-wide styling | **Theme** | `theme/app_theme.dart` |

## 📋 Common Patterns

### Pattern 1: Creating a Model

```dart
class MyModel {
  final String id;
  final String name;
  
  // Constructor
  MyModel({required this.id, required this.name});
  
  // Factory for creation
  factory MyModel.create({required String name}) {
    return MyModel(
      id: Uuid().v4(),
      name: name,
    );
  }
  
  // Method for updates (immutable)
  MyModel copyWith({String? name}) {
    return MyModel(
      id: id,
      name: name ?? this.name,
    );
  }
}
```

### Pattern 2: Creating a Service

```dart
class MyService extends ChangeNotifier {
  // Private data
  final List<MyModel> _items = [];
  
  // Public getter (read-only)
  List<MyModel> get items => List.unmodifiable(_items);
  
  // Create
  void addItem(MyModel item) {
    _items.add(item);
    notifyListeners(); // Important!
  }
  
  // Update
  void updateItem(String id, MyModel updated) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updated;
      notifyListeners();
    }
  }
  
  // Delete
  void deleteItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
```

### Pattern 3: Creating a Validator

```dart
class MyValidators {
  MyValidators._(); // Prevent instantiation
  
  static String? validateSomething(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 3) {
      return 'Must be at least 3 characters';
    }
    return null; // null = valid
  }
}
```

### Pattern 4: Creating a Reusable Widget

```dart
class MyWidget extends StatefulWidget {
  final String title;
  final Function(String) onSubmit;
  
  const MyWidget({
    super.key,
    required this.title,
    required this.onSubmit,
  });
  
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose(); // Important!
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        TextField(controller: _controller),
        ElevatedButton(
          onPressed: () => widget.onSubmit(_controller.text),
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

### Pattern 5: Creating a Screen

```dart
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Get service (don't listen to changes)
    final service = Provider.of<MyService>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Consumer<MyService>(
        builder: (context, service, child) {
          // This rebuilds when service changes
          return ListView.builder(
            itemCount: service.items.length,
            itemBuilder: (context, index) {
              return Text(service.items[index].name);
            },
          );
        },
      ),
    );
  }
}
```

## 🔄 Data Flow Snippets

### Getting Data from Service

```dart
// Method 1: Get once (no rebuilding)
final service = Provider.of<MyService>(context, listen: false);
final items = service.items;

// Method 2: Listen to changes (rebuilds on update)
Consumer<MyService>(
  builder: (context, service, child) {
    return Text('Count: ${service.items.length}');
  },
)
```

### Updating Data

```dart
// 1. Get service
final service = Provider.of<MyService>(context, listen: false);

// 2. Call service method
service.addItem(newItem);

// 3. Service calls notifyListeners()
// 4. All Consumers rebuild automatically!
```

### Form Validation

```dart
// 1. Create form key
final _formKey = GlobalKey<FormState>();

// 2. Wrap in Form widget
Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: Validators.validateEmail,
      ),
    ],
  ),
)

// 3. Validate on submit
if (_formKey.currentState!.validate()) {
  // All validations passed
  print('Form is valid!');
}
```

### Navigation

```dart
// Navigate to a screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => MyScreen(),
  ),
);

// Go back
Navigator.pop(context);

// Go back with result
Navigator.pop(context, result);
```

### Showing Messages

```dart
// Success message
SnackBarHelper.showSuccess(context, 'Operation successful!');

// Error message
SnackBarHelper.showError(context, 'Something went wrong');

// Custom snackbar
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Hello!')),
);
```

### Confirmation Dialog

```dart
void _confirmAction(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Do action
              performAction();
              Navigator.pop(dialogContext);
            },
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );
}
```

## 🎨 Theme Usage

### Using Theme Colors

```dart
// Get theme colors
Container(
  color: Theme.of(context).colorScheme.surface,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).colorScheme.onSurface,
    ),
  ),
)

// Use theme text styles
Text(
  'Title',
  style: Theme.of(context).textTheme.titleLarge,
)

// Check current brightness
if (Theme.of(context).brightness == Brightness.dark) {
  // Dark mode logic
} else {
  // Light mode logic
}
```

### Toggle Theme

```dart
IconButton(
  icon: Icon(
    Theme.of(context).brightness == Brightness.dark
        ? Icons.light_mode
        : Icons.dark_mode,
  ),
  onPressed: () {
    Provider.of<ThemeService>(context, listen: false).toggleTheme();
  },
)
```

## 📝 State Management Patterns

### Local State (setState)

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int _counter = 0;
  
  void _increment() {
    setState(() {
      _counter++; // This rebuilds the widget
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Counter: $_counter');
  }
}
```

### App-Wide State (Provider)

```dart
// 1. Create ChangeNotifier service
class CounterService extends ChangeNotifier {
  int _count = 0;
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners();
  }
}

// 2. Provide at app level
ChangeNotifierProvider(
  create: (_) => CounterService(),
  child: MyApp(),
)

// 3. Consume in widgets
Consumer<CounterService>(
  builder: (context, counter, child) {
    return Text('Count: ${counter.count}');
  },
)

// 4. Update from anywhere
Provider.of<CounterService>(context, listen: false).increment();
```

## 🧪 Testing Patterns

### Testing a Service

```dart
void main() {
  test('createPlayer adds player to list', () {
    // Arrange
    final service = PlayerService();
    
    // Act
    service.createPlayer(
      nickname: 'Test',
      fullName: 'Test User',
      // ...
    );
    
    // Assert
    expect(service.players.length, 1);
    expect(service.players.first.nickname, 'Test');
  });
}
```

### Testing a Validator

```dart
void main() {
  test('validateEmail rejects invalid email', () {
    // Act
    final result = Validators.validateEmail('invalid');
    
    // Assert
    expect(result, isNotNull);
    expect(result, contains('valid email'));
  });
  
  test('validateEmail accepts valid email', () {
    // Act
    final result = Validators.validateEmail('test@example.com');
    
    // Assert
    expect(result, isNull);
  });
}
```

## 🔍 Debugging Tips

### Print Statements

```dart
print('Value: $value'); // Simple debug
debugPrint('Debug info: $info'); // Better for Flutter
```

### Checking Provider State

```dart
final service = Provider.of<MyService>(context, listen: false);
print('Current items: ${service.items.length}');
```

### Form Validation Debugging

```dart
if (_formKey.currentState!.validate()) {
  print('✅ Form valid');
} else {
  print('❌ Form invalid - check validators');
}
```

## 📖 Common Mistakes to Avoid

### ❌ Mistake 1: Forgetting to dispose controllers

```dart
// Wrong
class _MyState extends State<MyWidget> {
  final _controller = TextEditingController();
  // No dispose = memory leak!
}

// Correct
class _MyState extends State<MyWidget> {
  late TextEditingController _controller;
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### ❌ Mistake 2: Not calling notifyListeners

```dart
// Wrong
void addItem(Item item) {
  _items.add(item);
  // UI won't update!
}

// Correct
void addItem(Item item) {
  _items.add(item);
  notifyListeners(); // Important!
}
```

### ❌ Mistake 3: Business logic in widgets

```dart
// Wrong
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ❌ Don't validate in widgets!
    if (email.contains('@')) { ... }
  }
}

// Correct
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ✅ Use service/utils
    if (Validators.validateEmail(email) == null) { ... }
  }
}
```

### ❌ Mistake 4: Hardcoding colors

```dart
// Wrong
Container(
  color: Colors.white, // Won't adapt to theme!
)

// Correct
Container(
  color: Theme.of(context).colorScheme.surface,
)
```

## 🚀 Performance Tips

1. **Use const constructors**
   ```dart
   const Text('Hello'); // Cached by Flutter
   ```

2. **Avoid rebuilding entire trees**
   ```dart
   Consumer<MyService>(
     builder: (context, service, child) {
       return Column(
         children: [
           child!, // This part doesn't rebuild
           Text('Count: ${service.count}'), // Only this rebuilds
         ],
       );
     },
     child: ExpensiveWidget(), // Build once, reuse
   )
   ```

3. **Use keys for list items**
   ```dart
   ListView.builder(
     itemBuilder: (context, index) {
       return MyWidget(
         key: Key(items[index].id), // Helps Flutter optimize
         item: items[index],
       );
     },
   )
   ```

---

## 🎓 Learning Path

1. **Start Here**:
   - Understand Models (simplest)
   - Learn Utils (helper functions)

2. **Then Learn**:
   - Services (business logic)
   - Widgets (reusable UI)

3. **Finally Master**:
   - Screens (orchestration)
   - State management flow

4. **Read Full Guide**:
   - See [ARCHITECTURE_GUIDE.md](ARCHITECTURE_GUIDE.md) for detailed explanations

---

**Remember**: This reference is your cheat sheet - bookmark it! 📚

