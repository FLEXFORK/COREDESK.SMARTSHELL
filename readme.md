# SmartShell

**A modern, customizable PowerShell-based desktop application with advanced theming and comprehensive logging capabilities.**

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PowerShell](https://img.shields.io/badge/PowerShell-7.0+-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.2-green.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)

---

## 🚀 Features

### 🎨 **Advanced Theming System**
- **Catppuccin Theme Support** - Built-in support for Catppuccin color schemes (Mocha, Frappe, Macchiato)
- **Custom Theme Engine** - JSON-based theme configuration system
- **Dynamic Color Mapping** - Automatic UI color application from theme files
- **Theme Hot-Swapping** - Change themes without application restart

### 📝 **Comprehensive Logging**
- **Multi-Level Logging** - INFO, WARN, ERROR, DEBUG levels with color-coded output
- **Automatic Log Rotation** - Configurable file rotation and cleanup
- **Session Management** - Unique session tracking with timestamps
- **Error Isolation** - Separate error logs for troubleshooting
- **Performance Monitoring** - Built-in execution time tracking

### 🖥️ **Modern GUI Framework**
- **Custom Windows Forms Interface** - Native Windows integration
- **Splash Screen System** - Professional application startup experience
- **Responsive Design** - Adaptive UI elements with theme-aware styling
- **Custom Window Controls** - Themed minimize, maximize, and close buttons

### 🔧 **Developer Experience**
- **Comprehensive Test Suite** - Unit, integration, and functional tests
- **Modular Architecture** - Service-oriented design with clear separation of concerns
- **Configuration Management** - JSON-based settings with validation
- **Error Handling** - Robust error recovery and user feedback

---

## 📸 Screenshots

### Splash Screen
![SmartShell Splash Screen](docs/images/splash-screen.png)
*Professional startup experience with theme-aware design*

### Main Application Window
![SmartShell Main Window](docs/images/main-window.png)
*Modern interface with custom theming and responsive design*

### Theme Showcase
![Theme Variations](docs/images/theme-showcase.png)
*Multiple Catppuccin theme variants in action*

---

## 🛠️ Installation

### Prerequisites
- **Windows 10/11** or Windows Server 2016+
- **PowerShell 7.0+** (recommended) or Windows PowerShell 5.1+
- **.NET Framework 4.7.2** or higher

### Quick Start
```powershell
# Clone the repository
git clone https://github.com/FLEXFORK/COREDESK.SMARTSHELL.git
cd COREDESK.SMARTSHELL

# Launch the application
cd program
powershell.exe -ExecutionPolicy Bypass -File "smartshell.ps1"
```

### Development Setup
```powershell
# Clone and enter directory
git clone https://github.com/FLEXFORK/COREDESK.SMARTSHELL.git
cd COREDESK.SMARTSHELL

# Run comprehensive tests
cd program/tests
powershell.exe -ExecutionPolicy Bypass -File "helpers/run-all-tests.ps1"

# Launch with development options
cd ../
powershell.exe -ExecutionPolicy Bypass -File "smartshell.ps1" -Development
```

---

## 🎯 Usage

### Basic Application Launch
```powershell
# Standard launch
.\program\smartshell.ps1

# Launch with specific theme
.\program\smartshell.ps1 -Theme "catppuccin-mocha"

# Development mode with enhanced logging
.\program\smartshell.ps1 -Development -LogLevel DEBUG
```

### Configuration

#### Settings File (`program/source/configs/settings.json`)
```json
{
  "version": "1.0.2",
  "theme": {
    "current": "catppuccin-mocha",
    "path": "./source/configs/themes"
  },
  "window": {
    "width": 1024,
    "height": 768,
    "startupPosition": "CenterScreen"
  },
  "logging": {
    "enabled": true,
    "path": "./logs",
    "level": "INFO",
    "maxFiles": 10
  }
}
```

#### Custom Theme Creation
```json
{
  "name": "My Custom Theme",
  "type": "dark",
  "colors": {
    "base": "#1e1e2e",
    "text": "#cdd6f4",
    "mauve": "#cba6f7",
    "mantle": "#181825",
    "surface0": "#313244",
    "red": "#f38ba8",
    "yellow": "#f9e2af"
  }
}
```

---

## 🏗️ Architecture

### Project Structure
```
COREDESK.SMARTSHELL/
├── program/
│   ├── smartshell.ps1              # Main entry point
│   ├── source/
│   │   ├── services/               # Core service modules
│   │   │   ├── logger.service.ps1  # Logging system
│   │   │   └── settings.service.ps1 # Configuration management
│   │   ├── views/                  # UI components
│   │   │   ├── splash.view.ps1     # Splash screen
│   │   │   └── window.view.ps1     # Main window
│   │   ├── scripts/                # Utility scripts
│   │   └── configs/                # Configuration files
│   │       ├── settings.json       # Application settings
│   │       └── themes/             # Theme definitions
│   ├── tests/                      # Comprehensive test suite
│   │   ├── unit/                   # Unit tests
│   │   ├── integration/            # Integration tests
│   │   ├── functional/             # End-to-end tests
│   │   └── helpers/                # Test utilities
│   ├── assets/                     # Static resources
│   └── logs/                       # Application logs
├── docs/                           # Documentation
│   ├── images/                     # Screenshots and diagrams
│   ├── version.md                  # Version information
│   └── changes.md                  # Changelog
└── release/                        # Distribution packages
```

### Service Architecture
- **Logger Service** - Centralized logging with rotation and session management
- **Settings Service** - Configuration management with theme integration
- **View System** - Modular UI components with theme awareness
- **Script System** - Utility functions and window management

---

## 🧪 Testing

SmartShell includes a comprehensive test framework with multiple test categories:

### Running Tests
```powershell
# Run all tests
.\tests\helpers\run-all-tests.ps1

# Run specific test categories
.\tests\helpers\run-all-tests.ps1 -TestType Unit
.\tests\helpers\run-all-tests.ps1 -TestType Integration
.\tests\helpers\run-all-tests.ps1 -TestType Functional

# Run with detailed output
.\tests\helpers\run-all-tests.ps1 -Detailed
```

### Test Categories
- **Unit Tests** (100% passing) - Individual component testing
- **Integration Tests** (100% passing) - Service interaction testing
- **Functional Tests** (80% passing) - End-to-end workflow testing
- **Performance Tests** - Load and benchmark testing

### Test Coverage
- **Services**: 90%+ function coverage
- **Views**: 70%+ component coverage
- **Critical Paths**: 100% coverage

---

## 🎨 Theming

### Built-in Themes
- **catppuccin-mocha** - Dark theme with purple accents
- **catppuccin-frappe** - Warm dark theme with soft colors
- **catppuccin-macchiato** - Balanced dark theme

### Theme Development
1. Create JSON theme file in `program/source/configs/themes/`
2. Define color palette using Catppuccin color naming convention
3. Test theme with `Get-Theme -ThemeName "your-theme"`
4. Apply theme via settings or command line parameter

### Color Mapping
SmartShell automatically maps theme colors to UI elements:
- `base` → Background color
- `text` → Foreground text
- `mauve` → Accent color
- `mantle` → Title bar
- `red` → Close button
- `yellow` → Minimize button

---

## 🔧 Development

### Prerequisites for Development
- **Git** for version control
- **PowerShell ISE** or **Visual Studio Code** with PowerShell extension
- **Pester** for advanced testing (optional)

### Development Workflow
1. **Fork** the repository
2. **Create** feature branch: `git checkout -b feature/your-feature`
3. **Implement** changes with tests
4. **Run** test suite: `.\tests\helpers\run-all-tests.ps1`
5. **Commit** with conventional commits: `git commit -m "feat: add new feature"`
6. **Push** and create pull request

### Code Quality Guidelines
- **Security First** - Validate all external input
- **Error Handling** - Use typed errors, never silent failures
- **Performance** - Avoid N+1 loops, batch operations
- **Testing** - Every non-trivial function requires tests
- **Documentation** - Export symbols require JSDoc comments

---

## 📊 Performance

### Startup Performance
- **Cold Start**: ~2-3 seconds
- **Warm Start**: ~1-2 seconds
- **Splash Screen**: ~500ms display time

### Memory Usage
- **Base Application**: ~15-25 MB
- **With Logging**: ~20-30 MB
- **Peak Usage**: ~40-50 MB

### Logging Performance
- **File I/O**: Async write operations
- **Rotation**: <100ms for cleanup
- **Session Management**: Minimal overhead

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](docs/contribute.md) for details.

### Quick Contribution Steps
1. Check [Issues](https://github.com/FLEXFORK/COREDESK.SMARTSHELL/issues) for open tasks
2. Fork the repository
3. Create a feature branch
4. Make your changes with tests
5. Submit a pull request

### Development Standards
- Follow PowerShell best practices
- Include comprehensive tests
- Update documentation
- Use conventional commit messages

---

## 📋 Changelog

See [CHANGES.md](docs/changes.md) for detailed version history.

### Recent Updates (v1.0.2)
- ✅ Enhanced logging system with rotation
- ✅ Comprehensive test framework
- ✅ Improved theme management
- ✅ Performance optimizations
- ✅ Bug fixes and stability improvements

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](docs/license.md) file for details.

---

## 🙏 Acknowledgments

- **Catppuccin Team** - For the beautiful color schemes
- **PowerShell Community** - For excellent tooling and guidance
- **Contributors** - For ongoing improvements and feedback

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/FLEXFORK/COREDESK.SMARTSHELL/issues)
- **Discussions**: [GitHub Discussions](https://github.com/FLEXFORK/COREDESK.SMARTSHELL/discussions)
- **Documentation**: [Project Wiki](https://github.com/FLEXFORK/COREDESK.SMARTSHELL/wiki)

---

**Made with ❤️ by the SmartShell Team**
