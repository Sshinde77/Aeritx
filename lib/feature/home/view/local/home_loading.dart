import 'package:e_com/_core/_core.dart';
import 'package:e_com/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomePageLoading extends StatelessWidget {
  const HomePageLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KShimmer.card(
            height: context.vByWidth(sp: 140, mp: 170, tab: 220, xl: 280),
            width: double.infinity),
        const SizedBox(height: 5),
        KShimmer.card(height: 30, width: 200),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: KShimmer.card(
                  height: context.vByWidth(sp: 50, mp: 60, tab: 70, xl: 80)),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: KShimmer.card(
                  height: context.vByWidth(sp: 50, mp: 60, tab: 70, xl: 80)),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: KShimmer.card(
                  height: context.vByWidth(sp: 50, mp: 60, tab: 70, xl: 80)),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: KShimmer.card(
                  height: context.vByWidth(sp: 50, mp: 60, tab: 70, xl: 80)),
            ),
          ],
        ),
        const SizedBox(height: 5),
        KShimmer.card(
            height: context.vByWidth(sp: 80, mp: 90, tab: 100, xl: 120),
            width: double.infinity),
        const SizedBox(height: 5),
        KShimmer(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.padValue(sp: 12, mp: 16, tab: 20, xl: 24),
                  vertical: context.vByWidth(sp: 8, mp: 10, tab: 12, xl: 14),
                ),
                child: Row(
                  children: [
                    Expanded(child: KShimmer.card(height: 50)),
                    const SizedBox(width: 5),
                    Expanded(child: KShimmer.card(height: 50)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        context.padValue(sp: 12, mp: 16, tab: 20, xl: 24)),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        context.columns(sp: 2, mp: 3, tab: 4, xl: 5),
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                  ),
                  itemCount: context.vByWidth(sp: 4, mp: 6, tab: 8, xl: 10),
                  itemBuilder: (context, index) => KShimmer.card(
                      height:
                          context.vByWidth(sp: 40, mp: 48, tab: 56, xl: 64)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        KShimmer.card(height: 100, width: double.infinity),
        const SizedBox(height: 5),
        KShimmer.card(height: 100, width: double.infinity),
      ],
    );
  }
}
