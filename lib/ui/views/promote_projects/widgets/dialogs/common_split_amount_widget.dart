import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/web_image_loading.dart';

Future<void> showCommonAmountDialog({
  required BuildContext context,
  required List<dynamic> dataList,
  required int totalValue,
  required String nameKey,
  required String imageKey,
  required String amountKey,
  required String itemStatusKey,
  required int lockedStatusValue, // eg: 4
  required String title,
  required Function(List<Map<String, dynamic>> updatedList) onNext,
}) async {
  final controllers = List<TextEditingController>.generate(
    dataList.length,
    (i) => TextEditingController(
      text: dataList[i][amountKey].toString(),
    ),
  );

  int calculateTotal() {
    return controllers.fold(
      0,
      (sum, c) => sum + (int.tryParse(c.text) ?? 0),
    );
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          final currentTotal = calculateTotal();
          final bool isMismatch = currentTotal != totalValue;

          return AlertDialog(
            title: Text(title),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
                minWidth: MediaQuery.of(context).size.width * 0.3,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// EXPECTED TOTAL
                    Text(
                      'Total : ₹$totalValue',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    /// ITEM LIST
                    SizedBox(
                      height: 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(dataList.length, (index) {
                            final item = dataList[index];
                            final bool isItemLocked =
                                int.tryParse(item[itemStatusKey].toString()) ==
                                    lockedStatusValue;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.grey[200],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: WebImage(
                                        imageUrl: item[imageKey].toString(),
                                        key: ValueKey(item[imageKey]),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(item[nameKey])),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: controllers[index],
                                      enabled: !isItemLocked,
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => setState(() {}),
                                      decoration: InputDecoration(
                                        hintText: 'Amount',
                                        filled: isItemLocked,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// C,ENT TOTAL
                    Text(
                      'Entered Total : ₹$currentTotal',
                      style: TextStyle(
                        color: isMismatch ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    if (isMismatch)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Total mismatch with item amounts',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    isMismatch ? Colors.grey : continueButton,
                  ),
                ),
                onPressed: isMismatch
                    ? null
                    : () {
                        /// update values back to list
                        for (int i = 0; i < dataList.length; i++) {
                          dataList[i][amountKey] =
                              int.tryParse(controllers[i].text) ?? 0;
                        }

                        onNext(dataList.cast<Map<String, dynamic>>());
                        Navigator.pop(context);
                      },
                child: Text(
                  'Next',
                  style: fontFamilySemiBold.size14.white,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
