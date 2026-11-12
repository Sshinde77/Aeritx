import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/products/controller/filtering_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'local/local.dart';

class ProductView extends HookConsumerWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = context.query('t');
    final query = context.query('search');
    final args = (type: type, query: query);

    final filtered = ref.watch(filteringCtrlProvider(args));

    final filterCtrl =
        useCallback(() => ref.read(filteringCtrlProvider(args).notifier));

    final searchTextCtrl = useTextEditingController();

    void search() {
      filterCtrl().search(searchTextCtrl.text);
    }

    useEffect(() {
      searchTextCtrl.text = query ?? '';
      return null;
    }, const []);
    final tr = context.tr;
    return Scaffold(
      appBar: context.onMobile
          ? KAppBar(
              title: Text(tr.products),
              leading: SquareButton.backButton(onPressed: () => context.pop()),
              bottom: AppBarTextField(
                hint: tr.search_for_product,
                controller: searchTextCtrl,
                onSubmit: search,
                onChanged: (v) => search(),
                suffix: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      scrollControlDisabledMaxHeightRatio: context.vByWidth(
                          sp: 0.9, mp: 0.85, tab: 0.8, xl: 0.7),
                      builder: (_) =>
                          FilterBottomSheet(args, searchTextCtrl.text),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      color: context.colors.secondaryContainer,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Assets.lottie.filter2.lottie(),
                  ),
                ),
              ),
            )
          : KAppBar(
              color: context.colors.primary,
              title: Text(tr.products),
              leading: SquareButton.backButton(onPressed: () => context.pop()),
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 60),
                child: Padding(
                  padding: defaultPadding,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 60,
                            width: context.width / 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: context.colors.onPrimary,
                                hintText: tr.search_for_product,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                scrollControlDisabledMaxHeightRatio:
                                    context.vByWidth(
                                        sp: 0.9, mp: 0.85, tab: 0.8, xl: 0.7),
                                builder: (_) => FilterBottomSheet(
                                    args, searchTextCtrl.text),
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: defaultRadius,
                                color: context.colors.secondaryContainer,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Assets.lottie.filter2.lottie(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
      body: filtered.when(
        loading: () => const ProductsLoading(),
        error: ErrorView.new,
        data: (data) {
          final isEmpty =
              data.products.fold((l) => l.isEmpty, (r) => r.isEmpty);

          if (isEmpty) {
            return const SingleChildScrollView(
              child: Center(child: NoItemsAnimationWithFooter()),
            );
          }

          final ProductFilteringState(:pagination, :products) = data;
          return Padding(
            padding: EdgeInsets.all(
                context.vByWidth(sp: 10.0, mp: 12.0, tab: 14.0, xl: 16.0)),
            child: MGridViewWithFooter(
              physics: defaultScrollPhysics,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              itemCount: products.fold((l) => l.length, (r) => r.length),
              crossAxisCount: context.columns(sp: 2, mp: 3, tab: 4, xl: 5),
              pagination: pagination,
              onPrevious: () {
                filterCtrl().previousPage();
              },
              onNext: () {
                filterCtrl().nextPage();
              },
              builder: (context, index) {
                return products.fold(
                  (l) => ProductCard(product: l[index], type: type),
                  (r) => DigitalProductCard(product: r[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.columns(sp: 2, mp: 3, tab: 4, xl: 5),
      ),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      itemCount: context.vByWidth(sp: 6, mp: 9, tab: 12, xl: 20),
      itemBuilder: (context, index) => KShimmer.card(
          height: context.vByWidth(sp: 140, mp: 170, tab: 200, xl: 220)),
    );
  }
}
