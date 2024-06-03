// ignore_for_file: avoid_print

import 'package:checkout_screen_ui/checkout_ui.dart';
import 'package:checkout_screen_ui/models/checkout_result.dart';
import 'package:e_learning/Features/Timeline/presentation/view/CourseDetailsPage.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:flutter/material.dart';

class MyDemoPage extends StatelessWidget {
  final Course course;
  const MyDemoPage({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<CardPayButtonState> _payBtnKey =
        GlobalKey<CardPayButtonState>();

    Future<void> _creditPayClicked(
        CardFormResults results, CheckOutResult checkOutResult) async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return CourseDetailsPage(course: course);
          },
        ),
      );
    }

    final List<PriceItem> _priceItems = [
      PriceItem(name: 'Product A', quantity: 1, itemCostCents: 5200),
      PriceItem(name: 'Product B', quantity: 2, itemCostCents: 8599),
      PriceItem(name: 'Product C', quantity: 1, itemCostCents: 2499),
      PriceItem(
          name: 'Delivery Charge',
          quantity: 1,
          itemCostCents: 1599,
          canEditQuantity: false),
    ];

    const String _payToName = 'Magic Vendor';

    Function? _onBack = Navigator.of(context).canPop()
        ? () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) {
                  return CourseDetailsPage(course: course);
                },
              ),
            )
        : null;

    return Scaffold(
      backgroundColor: ColorsData.backgroundColor,
      appBar: null,
      body: CheckoutPage(
        data: CheckoutData(
          priceItems: _priceItems,
          payToName: _payToName,
          onCardPay: _creditPayClicked,
          onBack: _onBack,
          payBtnKey: _payBtnKey,
          displayTestData: true,
          taxRate: 0.07,
        ),
      ),
    );
  }
}
