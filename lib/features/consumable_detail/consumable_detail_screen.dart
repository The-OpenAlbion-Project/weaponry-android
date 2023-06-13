import 'package:flutter/material.dart';
import 'package:openalbion_weaponry/constants/app_dimens.dart';
import 'package:openalbion_weaponry/data/vos/item_vo.dart';
import 'package:openalbion_weaponry/features/consumable_detail/sections/consumable_enchantment_section.dart';
import 'package:openalbion_weaponry/features/consumable_detail/sections/consumable_tab_section.dart';
import 'package:openalbion_weaponry/features/item_detail/widgets/normal_back_button.dart';
import 'package:openalbion_weaponry/providers/consumable_detail_provider.dart';
import 'package:provider/provider.dart';

class ConsumableDetailScreen extends StatelessWidget {
  static const routeName = 'consumer_detail_screen';
  final ConsumableDetailArgs args;
  const ConsumableDetailScreen({super.key, required this.args});

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConsumableDetailProvider>(create: (_) => ConsumableDetailProvider()..getItemDetail(args.type, args.item.id)),
        // ChangeNotifierProvider(create: (_) => MarketPriceProvider()..initializeIdAndMarket(args.item.identifier))
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NormalBackButton(),
                ConsumableEnchantmentSection(item: args.item),
                ConsumableTabSection(),
                SizedBox(height: MARGIN_LARGE),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConsumableDetailArgs {
  final ItemVO item;
  final String type;

  ConsumableDetailArgs({required this.type, required this.item});
}
