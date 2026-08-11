import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../application/discovery_providers.dart';
import 'widgets/offering_card.dart';

/// HOME-02: search teachable offerings by skill name.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
            hintText: 'Search skills or people',
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: query.isEmpty
          ? const _Hint('Search for a skill to learn')
          : ref.watch(offeringSearchProvider(query)).when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (_, _) => const _Hint('Something went wrong'),
                data: (results) {
                  if (results.isEmpty) {
                    return _Hint('No teachers found for "$query"');
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.screen),
                    itemCount: results.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) => OfferingCard(
                      offering: results[i],
                      onTap: () => context.push('/offering', extra: results[i]),
                    ),
                  );
                },
              ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: AppColors.textTertiary),
      ),
    );
  }
}
