# Theme System Guide

## 🎨 Design System

The app now features a modern, minimalist design inspired by shadcn/ui with full support for both light and dark modes.

### Color Palettes

#### Dark Mode
- **Background**: Deep black (#0A0A0A) - professional and easy on the eyes
- **Surface**: Dark gray (#141414) - cards and elevated content  
- **Borders**: Subtle gray (#262626) - clean separation
- **Text**: Off-white (#FAFAFA) - high readability
- **Accent**: Blue (#3B82F6) - **button highlights and focus states**
- **Success**: Green (#10B981)
- **Error**: Red (#EF4444)

#### Light Mode  
- **Background**: Warm off-white (#FBFBF9) - soft and inviting
- **Surface**: Pure white (#FFFFFF) - crisp and clean
- **Borders**: Light beige (#E7E5E4) - gentle separation  
- **Text**: Warm black (#1C1917) - comfortable reading
- **Accent**: **Warm orange (#F97316)** - friendly and energetic
- **Success**: Green (#10B981)
- **Error**: Red (#EF4444)

### Typography

Uses **system default fonts** for optimal native experience:
- **iOS/macOS**: San Francisco (SF Pro)
- **Android**: Roboto
- **Windows**: Segoe UI

#### Type Scale (Material Design 3)
- **Display Large**: 34px, Bold (fw700), 0.25 letter-spacing
- **Display Medium**: 28px, Semibold (fw600)
- **Display Small**: 24px, Semibold (fw600)
- **Headline Medium**: 20px, Semibold (fw600), 0.15 letter-spacing
- **Title Large**: 22px, Regular (fw400)
- **Title Medium**: 16px, Medium (fw500), 0.15 letter-spacing
- **Body Large**: 16px, Regular (fw400), 0.5 letter-spacing
- **Body Medium**: 14px, Regular (fw400), 0.25 letter-spacing
- **Body Small**: 12px, Regular (fw400), 0.4 letter-spacing
- **Label Large**: 14px, Medium (fw500), 0.1 letter-spacing
- **Label Medium**: 12px, Medium (fw500), 0.5 letter-spacing
- **Label Small**: 11px, Medium (fw500), 0.5 letter-spacing

### Button Styles

#### Dark Mode - Blue Highlights
Buttons in dark mode feature **blue accent highlights** when pressed or hovered:
- **Pressed**: 20% opacity blue overlay
- **Hovered**: 10% opacity blue overlay
- Creates a modern, tech-forward feel

#### Light Mode - Warm Highlights
Buttons in light mode feature **warm orange highlights**:
- **Pressed**: 15% opacity orange overlay
- **Hovered**: 8% opacity orange overlay  
- Creates a friendly, approachable feel

### FAB (Floating Action Button)

#### Dark Mode
- White background with subtle blue highlight on interaction
- No elevation for flat, modern look

#### Light Mode
- Warm orange background (#F97316)
- Slight elevation (2dp) with increased highlight elevation (4dp)
- White text for contrast

## 🔄 Theme Switching

### Toggle Button
Located in the app bar (top right):
- **Dark Mode Icon** (☀️ light_mode): Shows when in dark mode
- **Light Mode Icon** (🌙 dark_mode): Shows when in light mode

### How to Toggle
Tap the theme icon in the app bar to instantly switch between light and dark modes.

### Implementation
```dart
// Access theme service
final themeService = Provider.of<ThemeService>(context, listen: false);

// Toggle theme
themeService.toggleTheme();

// Check current theme
bool isDark = themeService.isDark;
ThemeMode mode = themeService.themeMode;
```

## 🎯 Design Principles

### 1. **Minimalism**
- Clean borders, no unnecessary shadows
- Generous whitespace
- Subtle color palette

### 2. **Industry Standards**
- Material Design 3 guidelines
- Native system fonts
- Standard component behavior

### 3. **Accessibility**
- High contrast ratios
- Proper text sizing
- Clear visual hierarchy

### 4. **Consistency**
- Same border radius throughout (8-12px)
- Consistent spacing (4px grid)
- Unified color system

## 🚀 Usage Examples

### Theme-Aware Colors
```dart
// Use theme colors instead of hardcoded values
Container(
  color: Theme.of(context).colorScheme.surface,
  border: Border.all(
    color: Theme.of(context).dividerColor,
  ),
)

// Text colors
Text(
  'Hello',
  style: TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
  ),
)
```

### Theme-Based Logic
```dart
// Different colors for light/dark mode
backgroundColor: Theme.of(context).brightness == Brightness.dark
    ? Colors.blue
    : Colors.orange,
```

## 📱 UI Components

### Cards
- Rounded corners (12px)
- 1px border matching theme
- No shadow (elevation: 0)
- Surface color background

### Inputs
- Rounded corners (8px)
- 1px border in default state
- **2px accent-colored border when focused**
- Filled background

### Buttons
- Rounded corners (8px)
- **Interactive highlights** matching theme accent
- No elevation (flat design)
- Proper padding (24px horizontal, 14px vertical)

### Dialogs
- Rounded corners (12px)
- 1px border
- Surface color background
- Centered content
- Clear action buttons

## 🎨 Color Usage Guide

### When to Use Each Color

#### Primary (Black/White)
- Main action buttons
- Important CTAs
- Key interactive elements

#### Secondary (Gray/Beige)
- Background surfaces
- Secondary content areas
- Inactive states

#### Accent (Blue/Orange)
- Focus states
- Button highlights
- Interactive feedback
- Links and actionable items

#### Error (Red)
- Destructive actions
- Delete buttons
- Error messages
- Validation failures

#### Success (Green)
- Success messages
- Confirmation snackbars
- Positive feedback

## 🔧 Customization

To modify the theme colors, edit `lib/theme/app_theme.dart`:

```dart
// Dark mode colors
static const Color darkBackground = Color(0xFF0A0A0A);
static const Color darkAccent = Color(0xFF3B82F6); // Blue highlight

// Light mode colors
static const Color lightBackground = Color(0xFFFBFBF9);
static const Color lightAccent = Color(0xFFF97316); // Warm orange
```

## 📋 Checklist for New Components

When creating new UI components:
- [ ] Use `Theme.of(context)` for colors
- [ ] Test in both light and dark modes
- [ ] Apply proper typography from theme
- [ ] Add button highlights using overlay colors
- [ ] Use theme border colors
- [ ] Verify contrast ratios
- [ ] Test with system fonts

---

**Design Philosophy**: Clean, modern, and professional while maintaining warmth and approachability.

