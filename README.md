# macOS Development Environment Setup

This project provides an automated setup for a macOS development environment using Ansible. It configures your macOS system with essential development tools, terminal customizations, and best practices configurations.

## 🚀 Features

- 📦 Package Management
  - Homebrew installation and configuration
  - Essential development tools and utilities
  - Programming languages and frameworks

- 🔧 Shell Configuration
  - ZSH setup with Oh-My-Zsh
  - Powerlevel10k theme
  - Useful plugins and customizations
  - Enhanced command-line productivity tools

- 🛠 Development Tools
  - Git and GitHub CLI configuration
  - VS Code setup
  - iTerm2 with custom preferences
  - Kubernetes tools
  - Infrastructure tools (Terraform, etc.)

- ⚙️ System Preferences
  - Custom macOS preferences
  - Development-friendly defaults
  - Enhanced security settings

## 📋 Prerequisites

- macOS (tested on Sonoma 14.0+)
- Administrator access
- Internet connection

## 🚀 Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/setup-macos.git
   cd setup-macos
   ```

2. Make the setup script executable:
   ```bash
   chmod +x setup.sh
   ```

3. Run the setup script:
   ```bash
   ./setup.sh
   ```

4. Follow the prompts to configure Git and other personal preferences.

The script will execute the following playbooks in order:
1. `01-homebrew.yml`: Installs Homebrew and essential tools
2. `02-shell.yml`: Configures ZSH with Oh-My-Zsh and customizations
3. `03-git.yml`: Sets up Git and GitHub CLI
4. `04-languages.yml`: Installs and configures programming languages

## 🧪 Testing Without macOS

For testing or development without a macOS machine, we provide a Docker-based test environment:

1. Ensure Docker is installed on your system

2. Make the test script executable:
   ```bash
   chmod +x test/test-environment.sh
   ```

3. Run the test environment:
   ```bash
   ./test/test-environment.sh
   ```

### Test Environment Limitations

The test environment simulates a macOS environment but has some limitations. See `test/test-environment.sh` for a detailed list of what works and what doesn't.

## 📁 Project Structure

```
.
├── setup.sh              # Main setup script
├── playbooks/           # Ansible playbooks directory
│   ├── 01-homebrew.yml # Homebrew packages and apps installation
│   ├── 02-shell.yml    # ZSH configuration and customization
│   ├── 03-git.yml      # Git and GitHub CLI configuration
│   └── 04-languages.yml # Programming languages setup (Erlang, Elixir, Ruby, Node.js, Go)
├── test/               # Test environment directory
│   ├── Dockerfile     # Test environment definition
│   ├── .dockerignore  # Docker ignore file
│   └── test-environment.sh  # Test environment script
└── README.md           # Project documentation
```

## 🔧 Customization

### Adding New Homebrew Packages

Edit `playbooks/01-homebrew.yml` and add packages under the appropriate section:

```yaml
- name: Install Development Tools
  homebrew:
    name:
      - your-package-name
    state: present
```

### Modifying ZSH Configuration

Edit `playbooks/02-shell.yml` to customize:
- Plugins
- Theme settings
- Shell aliases
- Environment variables

### Git Configuration

Edit `playbooks/03-git.yml` to modify:
- Git aliases
- Default settings
- GitHub CLI configuration

### Programming Languages

Edit `playbooks/04-languages.yml` to:
- Add/remove programming languages
- Change versions
- Add global tools
- Modify language-specific settings

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 🐛 Known Issues

- Some features may not work on Apple Silicon Macs without Rosetta 2
- Certain system preferences may require manual intervention
- Test environment cannot fully simulate macOS-specific features

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- [Ansible](https://www.ansible.com/)
- [Homebrew](https://brew.sh/)
- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- All the amazing open-source tools included in this setup

## 📮 Support

If you encounter any issues or have questions:
1. Check the [Known Issues](#-known-issues) section
2. Open an issue in the repository
3. Provide detailed information about your system and the problem 