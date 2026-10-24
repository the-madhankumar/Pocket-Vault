# 🔐 Pocket Vault

**Pocket Vault** is an offline-first password manager built with Flutter. It helps users store and manage their passwords locally, with a focus on privacy, simplicity, and security.

The goal is to make password management accessible without depending on a cloud account or an internet connection for everyday vault access.

## ✨ Features

- **Offline-first:** Access your saved passwords without requiring an internet connection.
- **Password Management:** Add, view, edit, and delete saved credentials.
- **Encrypted Storage:** Protect stored password data using encryption.
- **Master Password:** Use a master password to protect access to your vault.
- **App Lock:** Keep your vault protected when accessing the application.
- **Password Generator:** Generate passwords with configurable length and character options.
- **Clipboard Protection:** Support password visibility controls and clipboard-related security settings.
- **Dark and Light Themes:** Choose an appearance that suits your preference.
- **Local Storage:** Store vault data on the device.
- **Beta Feedback:** Report bugs and suggest new features through GitHub.

## 🛠️ Built With

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform application development |
| Dart | Application programming language |
| Isar | Local database |
| AES-GCM | Encryption for stored sensitive data |
| Argon2id | Master-password key derivation |
| SharedPreferences | Local application settings |
| Provider | State management |

## 📱 Getting Started

### Prerequisites

Install the following before running the project:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- [Android Studio](https://developer.android.com/studio) or Visual Studio Code
- An Android device or emulator

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/the-madhankumar/Pocket-Vault.git
```

**2. Navigate to the project directory**

```bash
cd Pocket-Vault
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
flutter run
```

## 🔑 How to Use

1. Launch Pocket Vault on your device.
2. Set up your master password if prompted.
3. Unlock your vault.
4. Add an account by entering its platform, username or email, password, and other available details.
5. View or manage your saved credentials from the vault.
6. Use the password generator when creating new passwords.
7. Configure app locking, password visibility, and appearance through Settings.

## 🔒 Security and Privacy

Pocket Vault is designed around local storage and privacy.

- Sensitive password data is intended to be encrypted before storage.
- A master password helps protect access to the vault.
- Password visibility can be controlled within the application.
- Security-related settings help reduce accidental exposure of sensitive information.
- The application is designed to provide offline access to saved credentials.

**Important:** Pocket Vault is a personal project under development. It has not been independently security-audited. Do not rely on it as your only password-storage solution for critical accounts until its security, recovery, and backup mechanisms have been thoroughly tested.

Never share your master password, encryption keys, or private vault data in bug reports.

## 🗺️ Roadmap

Planned improvements may include:

- [ ] More secure vault backup and recovery.
- [ ] Additional password-generation options.
- [ ] Improved automatic locking and session protection.
- [ ] Enhanced security and usability testing.
- [ ] More customization options.
- [ ] Additional features based on beta-user feedback.

## 🐛 Bug Reports and Feature Requests

Found a bug or have an idea to improve Pocket Vault?

Open the repository's issue tracker:

[Report an Issue or Suggest a Feature](https://github.com/the-madhankumar/Pocket-Vault/issues)

Please include clear reproduction steps when reporting bugs. Never include real passwords, master passwords, encryption keys, or other sensitive vault information.

## 🤝 Contributing

Contributions, suggestions, and constructive feedback are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Test your changes.
5. Open a pull request describing the improvement.

Please keep security and privacy in mind when contributing.

## 📄 License

No license has been specified here yet. Until a license is added to the repository, do not assume that the source code is available for unrestricted reuse or redistribution.

## 👨‍💻 Author

**Madhan Kumar M**

- GitHub: [@the-madhankumar](https://github.com/the-madhankumar)

---

*Pocket Vault — Your passwords, your device, your control.*
