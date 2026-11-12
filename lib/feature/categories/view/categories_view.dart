import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/categories/providers/categories_provider.dart';
import 'package:e_com/feature/categories/view/local/category_card.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoriesView extends ConsumerWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);
    return Scaffold(
      appBar: KAppBar(
        title: Text(context.tr.category),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: context.onMobile
            ? defaultPadding.copyWith(top: 15)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: MasonryGridView.builder(
          physics: defaultScrollPhysics,
          shrinkWrap: true,
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: context.columns(sp: 3, mp: 4, tab: 6, xl: 8),
          ),
          mainAxisSpacing: context.vByWidth(sp: 6, mp: 10, tab: 20, xl: 30),
          clipBehavior: Clip.none,
          crossAxisSpacing: context.vByWidth(sp: 6, mp: 10, tab: 20, xl: 30),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(category: category);
          },
        ),
      ),
    );
  }
}
