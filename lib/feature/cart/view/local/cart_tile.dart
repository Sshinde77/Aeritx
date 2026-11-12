import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/cart/controller/carts_ctrl.dart';
import 'package:e_com/models/cart/carts_model.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CartTile extends HookConsumerWidget {
  const CartTile({
    super.key,
    required this.cart,
    this.onCartDelete,
  });

  final CartData cart;
  final Function(CartData cart)? onCartDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartsCtrl = useCallback(() => ref.read(cartCtrlProvider.notifier));
    final isLoggedIn = ref.watch(authCtrlProvider);
    final product = cart.product;

    final borderColor =
        context.colors.secondary.withValues(alpha: context.isDark ? 0.8 : 0.2);

    final isLoading = useState(false);
    final optimisticQuantity = useState(cart.quantity);
    final isQuantityLoading = useState(false);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () => RouteNames.productDetails.pushNamed(
                  context,
                  pathParams: {'id': product.uid},
                  query: {
                    'isRegular': 'true',
                    't': 'cart',
                  },
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: context.onMobile ? 90 : 180,
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: defaultRadius,
                            image: DecorationImage(
                              image:
                                  HostedImage.provider(product.featuredImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            product.name,
                            style: context.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: context.colors.secondaryContainer
                                  .withValues(alpha: 0.08),
                              borderRadius: defaultRadius,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              cart.variant,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            product.category,
                            style: context.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    if (isLoggedIn)
                                      TextSpan(
                                        text: cart.variantPrice.formate(),
                                      )
                                    else
                                      TextSpan(
                                        text: cart.baseDiscount
                                            .formate(rateCheck: true),
                                      ),
                                  ],
                                ),
                                style: context.textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: borderColor),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: isLoading.value || isQuantityLoading.value
                          ? null
                          : () async {
                              isLoading.value = true;
                              await cartsCtrl().deleteCart(context, cart.uid);
                              onCartDelete?.call(cart);
                              isLoading.value = false;
                            },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: context.colors.secondaryContainer.withValues(
                            alpha: context.isDark ? 0.1 : 0.05,
                          ),
                        ),
                        child: Icon(
                          Icons.delete_rounded,
                          color: isLoading.value || isQuantityLoading.value
                              ? context.colors.outline
                              : context.colors.error,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: context.colors.secondaryContainer.withValues(
                          alpha: context.isDark ? 0.1 : 0.05,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: isQuantityLoading.value
                                  ? null
                                  : () async {
                                      if (optimisticQuantity.value <= 1) return;
                                      isQuantityLoading.value = true;
                                      final newQuantity =
                                          optimisticQuantity.value - 1;
                                      optimisticQuantity.value = newQuantity;
                                      await cartsCtrl().updateQuantity(
                                        cart.uid,
                                        newQuantity,
                                      );
                                      isQuantityLoading.value = false;
                                    },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: context.colors.surface,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: optimisticQuantity.value <= 1
                                        ? context.colors.outline
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Text(
                                '${optimisticQuantity.value}',
                                key: ValueKey(optimisticQuantity.value),
                                style: context.textTheme.titleLarge,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: isQuantityLoading.value
                                  ? null
                                  : () async {
                                      isQuantityLoading.value = true;
                                      final newQuantity =
                                          optimisticQuantity.value + 1;
                                      optimisticQuantity.value = newQuantity;
                                      await cartsCtrl().updateQuantity(
                                        cart.uid,
                                        newQuantity,
                                      );
                                      isQuantityLoading.value = false;
                                    },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: context.colors.surface,
                                ),
                                child: const Center(
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        if (isLoading.value)
          const Positioned.fill(
            child: BlurredLoading(),
          )
      ],
    );
  }
}
