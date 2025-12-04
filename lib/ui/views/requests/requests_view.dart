import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'requests_viewmodel.dart';

class RequestsView extends StackedView<RequestsViewModel> {
  const RequestsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RequestsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: const Center(child: Text("RequestsView")),
      ),
    );
  }

  @override
  RequestsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RequestsViewModel();
}
