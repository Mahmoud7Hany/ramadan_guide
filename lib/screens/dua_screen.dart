// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dua.dart';
import '../providers/dua_provider.dart';
import '../widgets/animated_card.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.05),
                theme.colorScheme.surface,
                theme.colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن دعاء...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  textInputAction: TextInputAction.search,
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
                child: TabBar(
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text('الأدعية'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text('المفضلة'),
                        ],
                      ),
                    ),
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.primaryContainer,
                  ),
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  dividerColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _DuaList(
                      category: 'ramadan',
                      searchQuery: _searchQuery.trim(),
                    ),
                    _DuaList(
                      category: 'favorites',
                      searchQuery: _searchQuery.trim(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddDuaDialog(context),
          child: const Icon(Icons.add_rounded),
        ),
      ),
    );
  }

  Future<void> _showAddDuaDialog(BuildContext context) async {
    final textController = TextEditingController();
    final descriptionController = TextEditingController();
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text('إضافة دعاء جديد'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'الدعاء',
                hintText: 'اكتب الدعاء هنا',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                prefixIcon: const Icon(Icons.format_quote_rounded),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'المناسبة',
                hintText: 'مثال: دعاء الإفطار',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                prefixIcon: const Icon(Icons.info_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            label: const Text('إلغاء'),
          ),
          FilledButton.icon(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Provider.of<DuaProvider>(context, listen: false).addDua(
                  textController.text,
                  descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class _DuaList extends StatelessWidget {
  final String category;
  final String searchQuery;

  const _DuaList({required this.category, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Consumer<DuaProvider>(
      builder: (context, duaProvider, child) {
        final duas = category == 'favorites'
            ? duaProvider.favoriteDuas
            : duaProvider.duasByCategory(category);
        
        final filteredDuas = duas.where((dua) {
          final query = searchQuery.toLowerCase();
          return dua.text.toLowerCase().contains(query) ||
                 dua.description.toLowerCase().contains(query);
        }).toList();
        
        if (filteredDuas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category == 'favorites' ? Icons.favorite_outline : Icons.menu_book_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  category == 'favorites' ? 'لا توجد أدعية مفضلة' : 'لا توجد أدعية',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                if (category != 'favorites') ...[
                  const SizedBox(height: 8),
                  Text(
                    'اضغط على زر الإضافة لإضافة دعاء جديد',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredDuas.length,
          itemBuilder: (context, index) {
            final dua = filteredDuas[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _DuaCard(dua: dua),
            );
          },
        );
      },
    );
  }
}

class _DuaCard extends StatelessWidget {
  final Dua dua;

  const _DuaCard({required this.dua});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedCard(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer.withOpacity(0.4),
              theme.colorScheme.surface,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showEditDuaDialog(context),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.format_quote_rounded,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dua.text,
                              style: theme.textTheme.titleMedium?.copyWith(
                                height: 1.8,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (dua.description.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.label_outline_rounded,
                                      size: 16,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      dua.description,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _ActionButton(
                        onPressed: () {
                          Provider.of<DuaProvider>(context, listen: false)
                              .toggleFavorite(dua.id);
                        },
                        icon: dua.isFavorite 
                            ? Icons.favorite_rounded 
                            : Icons.favorite_outline_rounded,
                        color: dua.isFavorite ? theme.colorScheme.primary : null,
                        tooltip: dua.isFavorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        onPressed: () => _showEditDuaDialog(context),
                        icon: Icons.edit_rounded,
                        tooltip: 'تعديل',
                      ),
                      const SizedBox(width: 8),
                      _ActionButton(
                        onPressed: () => _showDeleteConfirmation(context),
                        icon: Icons.delete_outline_rounded,
                        color: theme.colorScheme.error,
                        tooltip: 'حذف',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDuaDialog(BuildContext context) async {
    final textController = TextEditingController(text: dua.text);
    final descriptionController = TextEditingController(text: dua.description);
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            Icon(
              Icons.edit_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Text('تعديل الدعاء'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'الدعاء',
                hintText: 'اكتب الدعاء هنا',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                prefixIcon: const Icon(Icons.format_quote_rounded),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'المناسبة',
                hintText: 'مثال: دعاء الإفطار',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                prefixIcon: const Icon(Icons.info_outline_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            label: const Text('إلغاء'),
          ),
          FilledButton.icon(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Provider.of<DuaProvider>(context, listen: false).updateDua(
                  dua.id,
                  textController.text,
                  descriptionController.text,
                );
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.save_rounded),
            label: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final theme = Theme.of(context);
    
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.9),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 12),
            Text(
              'حذف الدعاء',
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: const Text('هل أنت متأكد من حذف هذا الدعاء؟'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            label: const Text('إلغاء'),
          ),
          FilledButton.tonalIcon(
            onPressed: () {
              Provider.of<DuaProvider>(context, listen: false).deleteDua(dua.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_rounded),
            label: const Text('حذف'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final String tooltip;

  const _ActionButton({
    required this.onPressed,
    required this.icon,
    this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color ?? theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}