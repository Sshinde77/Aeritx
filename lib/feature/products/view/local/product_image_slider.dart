import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/auth/controller/auth_ctrl.dart';
import 'package:e_com/feature/user_dash/provider/user_dash_provider.dart';
import 'package:e_com/feature/wishlist/controller/wishlist_ctrl.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductImageSlider extends HookConsumerWidget {
  const ProductImageSlider({
    super.key,
    required this.images,
    required this.isProduct,
    required this.id,
  });

  final List<String> images;
  final bool isProduct;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(authCtrlProvider);

    final wishList =
        ref.watch(userDashProvider.select((v) => v?.wishlists.listData ?? []));
    final wishListCtrl =
        useCallback(() => ref.read(wishlistCtrlProvider.notifier));

    final WishlistData? wishListId =
        wishList.where((e) => e.product.uid == id).firstOrNull;

    final bool isWishListed = wishListId != null;

    // Optimistic UI state - updates instantly
    final optimisticWishlist = useState(isWishListed);
    final isLoading = useState(false);
    final showLoadingIndicator = useState(false);

    useEffect(
      () {
        // Sync optimistic state with actual state
        optimisticWishlist.value = isWishListed;
        return null;
      },
      [isWishListed],
    );

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            clipBehavior: Clip.none,
            height: context.onMobile ? 270 : 400,
            viewportFraction: 1,
            initialPage: 0,
            autoPlay: true,
          ),
          itemBuilder: (context, index, _) {
            final img = images[index];
            return ClipRRect(
              borderRadius: defaultRadius,
              child: HostedImage(
                fit: BoxFit.fitHeight,
                img,
                width: context.width / 1.1,
                enablePreviewing: true,
              ),
            );
          },
        ),
        if (isLoggedIn)
          if (isProduct)
            Positioned(
              bottom: 10,
              right: 20,
              child: IconButton.filled(
                onPressed: isLoading.value
                    ? null
                    : () async {
                        // Prevent double-tap
                        if (isLoading.value) return;
                        isLoading.value = true;

                        // Optimistic UI update - instant feedback
                        final wasWishlisted = optimisticWishlist.value;
                        optimisticWishlist.value = !optimisticWishlist.value;

                        // Show loading indicator after 500ms if still loading
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (isLoading.value) {
                            showLoadingIndicator.value = true;
                          }
                        });

                        try {
                          if (wasWishlisted) {
                            await wishListCtrl()
                                .deleteWishlist(wishListId!.uid);
                            if (context.mounted) {
                              Toaster.showSuccess('Removed from Wishlist');
                            }
                          } else {
                            await wishListCtrl().addToWishlist(id);
                            if (context.mounted) {
                              Toaster.showSuccess('Added to Wishlist');
                            }
                          }
                        } catch (e) {
                          // Rollback on error
                          optimisticWishlist.value = wasWishlisted;
                          if (context.mounted) {
                            Toaster.showError('Something went wrong');
                          }
                        } finally {
                          isLoading.value = false;
                          showLoadingIndicator.value = false;
                        }
                      },
                icon: showLoadingIndicator.value
                    ? SizedBox.square(
                        dimension: 25,
                        child: CircularProgressIndicator(
                          color: context.colors.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: optimisticWishlist.value
                            ? const Icon(
                                Icons.favorite,
                                key: ValueKey('filled'),
                                size: 25,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                                key: ValueKey('outlined'),
                                size: 25,
                              ),
                      ),
              ),
            ),
      ],
    );
  }
}
