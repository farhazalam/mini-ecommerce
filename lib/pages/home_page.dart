import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'products_page.dart';
import 'maps_page.dart';
import 'package:mini_ecommerce/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    return Directionality(
      textDirection: languageProvider.isArabic
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            // Language Dropdown
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.language),
                  onSelected: (value) {
                    if (value == 'en') {
                      languageProvider.setLocale(const Locale('en', ''));
                    } else if (value == 'ar') {
                      languageProvider.setLocale(const Locale('ar', ''));
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'en',
                      child: Row(
                        children: [
                          const Icon(Icons.language),
                          const SizedBox(width: 8),
                          Text(l10n.english),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'ar',
                      child: Row(
                        children: [
                          const Icon(Icons.language),
                          const SizedBox(width: 8),
                          Text(l10n.arabic),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Logout Menu
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'logout') {
                      await authProvider.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout),
                          const SizedBox(width: 8),
                          Text(l10n.logout),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = authProvider.user;
            if (user == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No user data available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Card
                Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcome,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.hello(user.fullName),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    l10n.quickActions,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildActionCard(
                          context,
                          l10n.browseProducts,
                          Icons.shopping_bag_outlined,
                          Colors.green,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProductsPage(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          context,
                          l10n.myOrders,
                          Icons.receipt_outlined,
                          Colors.orange,
                          () {
                            Navigator.of(context).pushNamed('/orders');
                          },
                        ),
                        _buildActionCard(
                          context,
                          l10n.profile,
                          Icons.person_outlined,
                          Colors.purple,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          context,
                          l10n.nearby,
                          Icons.location_on_outlined,
                          Colors.red,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MapsPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
