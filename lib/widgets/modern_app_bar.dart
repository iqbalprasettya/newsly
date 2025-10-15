import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showSearch;
  final VoidCallback? onSearchTap;
  final bool showBackButton;
  final bool integrated; // New parameter for integrated mode

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showSearch = false,
    this.onSearchTap,
    this.showBackButton = false,
    this.integrated = false, // Default to card mode
  });

  @override
  Widget build(BuildContext context) {
    if (integrated) {
      // Integrated mode - no card, just padding
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Row(
          children: [
            // Back button or spacing
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
                color: Theme.of(context).colorScheme.onSurface,
              )
            else
              const SizedBox(width: 8),

            // Title
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            // Search button
            if (showSearch)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: onSearchTap,
                  tooltip: 'Search',
                ),
              ),

            // Theme toggle
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () => themeProvider.toggleTheme(),
                    tooltip: themeProvider.isDarkMode
                        ? 'Light Mode'
                        : 'Dark Mode',
                  ),
                );
              },
            ),

            // Additional actions
            if (actions != null) ...actions!,
          ],
        ),
      );
    } else {
      // Card mode - original design
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 40, 16, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Back button or spacing
              if (showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                  color: Theme.of(context).colorScheme.onSurface,
                )
              else
                const SizedBox(width: 8),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),

              // Search button
              if (showSearch)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: onSearchTap,
                    tooltip: 'Search',
                  ),
                ),

              // Theme toggle
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => themeProvider.toggleTheme(),
                      tooltip: themeProvider.isDarkMode
                          ? 'Light Mode'
                          : 'Dark Mode',
                    ),
                  );
                },
              ),

              // Additional actions
              if (actions != null) ...actions!,
            ],
          ),
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
