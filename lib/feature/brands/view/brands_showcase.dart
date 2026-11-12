import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:e_com/routes/routes.dart';
import 'package:e_com/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BrandShowcase extends ConsumerWidget {
  const BrandShowcase({super.key, required this.brands});

  final List<BrandData> brands;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      clipBehavior: Clip.none,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brands.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.columns(sp: 3, mp: 4, tab: 5, xl: 6),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // Make tiles a bit taller on small screens to avoid text/icon overlap
        childAspectRatio:
            context.vByWidth(sp: 0.85, mp: 0.9, tab: 1.0, xl: 1.1),
      ),
      itemBuilder: (context, index) {
        final brand = brands[index];
        return InkWell(
          borderRadius: defaultRadius,
          onTap: () => RouteNames.brandProducts
              .pushNamed(context, pathParams: {'id': brand.uid}),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  width: 0, color: context.colors.secondaryContainer),
              borderRadius: defaultRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: context.vByWidth(sp: 40, mp: 50, tab: 60, xl: 70),
                    width: context.vByWidth(sp: 40, mp: 50, tab: 60, xl: 70),
                    decoration: BoxDecoration(
                      borderRadius: defaultRadius,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: HostedImage.provider(brand.logo),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    brand.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
