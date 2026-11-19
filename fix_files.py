#!/usr/bin/env python3
import os

BASE = os.path.join(os.environ.get('USERPROFILE', ''), 'Desktop/Rent_Guru/flutter assignment/rental_management_system')
# Use raw path
BASE = os.path.expanduser('~\\Desktop\\Rent_Guru\\flutter assignment\\rental_management_system')

def fix(path, old, new):
    full = os.path.join(BASE, path)
    with open(full, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(old, new)
    with open(full, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f'Fixed {path}')

# login_screen: Don\\'t -> Don't
fix('lib/features/auth/presentation/screens/login_screen.dart', "Don\\\\'t", "Don't")

# forgot_password_screen
fix('lib/features/auth/presentation/screens/forgot_password_screen.dart', "to\\\\n", "to\n")
fix('lib/features/auth/presentation/screens/forgot_password_screen.dart', "Didn\\\\'t", "Didn't")

# notifications_screen
fix('lib/features/notifications_screen.dart', "Error: \\\\")", "Error: '${e.message}'")

# property_detail_screen - fix corrupted path in interpolation
fix('lib/features/properties/presentation/screens/property_detail_screen.dart', "Text('\\c:\\Users\\Nischal's PC\\Desktop\\Rent_Guru\\flutter assignment{p.monthlyRent}/month'", "Text('${p.monthlyRent}/month'")
fix('lib/features/properties/presentation/screens/property_detail_screen.dart', "Text('\\c:\\Users\\Nischal's PC\\Desktop\\Rent_Guru\\flutter assignment{p.securityDeposit}'", "Text('${p.securityDeposit}')")

# property_listing_screen
fix('lib/features/properties/presentation/screens/property_listing_screen.dart', "Text('\\c:\\Users\\Nischal's PC\\Desktop\\Rent_Guru\\flutter assignment{property.monthlyRent}/month'", "Text('${property.monthlyRent}/month'")

# status_screen
fix('lib/features/verification/presentation/screens/status_screen.dart', "error: (e, _) => Center(child: Text('Error: '))", "error: (e, _) => Center(child: Text('Error: ${e.message}'))")

print('All fixes applied')

