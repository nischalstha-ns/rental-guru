/// Common form validators used across screens.
class Validators {
  Validators._();

  static String? Function(String?) get email => _compose(<String? Function(String?)>[
    _required('Email is required'),
    _matches(RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$'), 'Please enter a valid email address'),
  ]);

  static String? Function(String?) get password => _compose(<String? Function(String?)>[
    _required('Password is required'),
    _minLength(8, 'Password must be at least 8 characters'),
  ]);

  static String? Function(String?) get confirmPassword => (String? value) {
    return null;
  };

  static String? Function(String?) get fullName => _compose(<String? Function(String?)>[
    _required('Full name is required'),
    _minLength(2, 'Name must be at least 2 characters'),
  ]);

  static String? Function(String?) get phone => _compose(<String? Function(String?)>[
    _required('Phone number is required'),
    _matches(RegExp(r'^[\d\s+()-]{7,20}$'), 'Please enter a valid phone number'),
  ]);

  static String? Function(String?) get positiveNumber => (String? value) {
    if (value == null || value.isEmpty) return null;
    final num = double.tryParse(value);
    if (num == null || num <= 0) return 'Please enter a valid positive number';
    return null;
  };

  static String? Function(String?) get nonEmpty => _required('This field is required');

  static String? Function(String?) _required(String message) => (String? value) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  };

  static String? Function(String?) _minLength(int length, String message) => (String? value) {
    if (value == null || value.length < length) return message;
    return null;
  };

  static String? Function(String?) _matches(RegExp regex, String message) => (String? value) {
    if (value == null || !regex.hasMatch(value)) return message;
    return null;
  };

  static String? Function(String?) _compose(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
