import 'package:flutter/material.dart';
import 'package:webapp/ui/views/promote_projects/model/promote_project_model.dart';
import 'package:webapp/widgets/initial_textform.dart';
import 'package:webapp/widgets/state_city_drop_down.dart';

class ProjectDetailsDialog extends StatefulWidget {
  final ProjectModel model;
  final bool isEdit;
  final ValueChanged<ProjectModel>? onSave;

  const ProjectDetailsDialog({
    super.key,
    required this.model,
    this.isEdit = false,
    this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required ProjectModel model,
    bool isEdit = false,
    ValueChanged<ProjectModel>? onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectDetailsDialog(
        model: model,
        isEdit: isEdit,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProjectDetailsDialog> createState() => _ProjectDetailsDialogState();
}

class _ProjectDetailsDialogState extends State<ProjectDetailsDialog> {
  int selectedImageIndex = 0;
  bool isView = false;

  late TextEditingController codeCtrl;
  late TextEditingController companyCtrl;
  late TextEditingController serviceCtrl;
  late TextEditingController noteCtrl;
  late TextEditingController paymentCtrl;
  late TextEditingController commissionCtrl;

  late String gender;
  late String state = "Tamil Nadu";
  late String city = "Coimbatore";

  late List<String> images;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final ScrollController thumbnailScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isView = !widget.isEdit;

    codeCtrl = TextEditingController(text: widget.model.projectCode);
    companyCtrl = TextEditingController(text: widget.model.companyName);
    serviceCtrl = TextEditingController(text: widget.model.service);
    noteCtrl = TextEditingController(text: widget.model.note);
    paymentCtrl = TextEditingController(text: widget.model.payment.toString());
    commissionCtrl =
        TextEditingController(text: widget.model.commission.toString());

    gender = widget.model.gender ?? genders.first;
    state = widget.model.state;
    city = widget.model.city;

    images = List.from(widget.model.projectImages);

    // Default to 10th image if available
    if (images.length > 9) {
      selectedImageIndex = 9;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        thumbnailScrollController.animateTo(
          9 * (80 + 8), // thumbnail width + spacing
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 900,
        height: 650,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isView ? 'View Project' : 'Add Project',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Row(
                    children: [
                      if (isView)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isView = false;
                            });
                          },
                        ),
                      if (isView)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => Navigator.pop(context, 'delete'),
                        ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// MAIN CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT: Image Section
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          /// MAIN IMAGE
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: images.isEmpty
                                  ? const Center(child: Text('No Image'))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        images[selectedImageIndex],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// THUMBNAILS
                          SizedBox(
                            height: 80,
                            child: ListView.separated(
                              controller: thumbnailScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (_, index) {
                                final selected = index == selectedImageIndex;
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    selectedImageIndex = index;
                                  }),
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selected
                                            ? Colors.blue
                                            : Colors.grey,
                                        width: selected ? 2 : 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        images[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// RIGHT: Form Section
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Project Code & Company
                            Row(
                              children: [
                                Expanded(
                                  child: _buildField(
                                    label: 'Project Code',
                                    child: InitialTextForm(
                                      radius: 10,
                                      controller: codeCtrl,
                                      hintText: 'Project Code',
                                      readOnly: isView,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildField(
                                    label: 'Company Name',
                                    child: InitialTextForm(
                                      radius: 10,
                                      controller: companyCtrl,
                                      hintText: 'Company',
                                      readOnly: isView,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// Gender & Service
                            Row(
                              children: [
                                Expanded(
                                  child: _buildField(
                                    label: 'Gender',
                                    child: DropdownButtonFormField<String>(
                                      value: genders.contains(gender)
                                          ? gender
                                          : null,
                                      items: genders
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ))
                                          .toList(),
                                      onChanged: isView
                                          ? null
                                          : (val) =>
                                              setState(() => gender = val!),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildField(
                                    label: 'Service',
                                    child: InitialTextForm(
                                      radius: 10,
                                      controller: serviceCtrl,
                                      hintText: 'Service',
                                      readOnly: isView,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// Location (FULL WIDTH)
                            _buildField(
                              label: 'Location',
                              child: StateCityDropdown(
                                isVertical: true,
                                showCity: true,
                                initialState: state,
                                initialCity: city,
                                isStateError: false,
                                isCityError: false,
                                onStateChanged: (val) => state = val,
                                onCityChanged: (val) => city = val ?? '',
                              ),
                            ),
                            const SizedBox(height: 12),

                            /// Payment & Commission
                            Row(
                              children: [
                                Expanded(
                                  child: _buildField(
                                    label: 'Payment',
                                    child: InitialTextForm(
                                      radius: 10,
                                      controller: paymentCtrl,
                                      hintText: 'Payment',
                                      readOnly: isView,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildField(
                                    label: 'Commission',
                                    child: InitialTextForm(
                                      radius: 10,
                                      controller: commissionCtrl,
                                      hintText: 'Commission',
                                      readOnly: isView,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            /// Description (FULL WIDTH)
                            _buildField(
                              label: 'Description',
                              child: InitialTextForm(
                                radius: 10,
                                controller: noteCtrl,
                                hintText: 'Description',
                                readOnly: isView,
                                maxLines: 4,
                              ),
                            ),

                            const SizedBox(height: 16),

                            /// ACTION BUTTONS
                            if (!isView)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _pickImages,
                                    icon: const Icon(Icons.upload),
                                    label: const Text('Upload Image'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: _save,
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImages() {
    if (images.length >= 10) return;
    setState(() {
      images.add('https://via.placeholder.com/400');
    });
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  void _save() {
    final updated = widget.model.copyWith(
      projectCode: codeCtrl.text,
      companyName: companyCtrl.text,
      service: serviceCtrl.text,
      gender: gender,
      state: state,
      city: city,
      payment: double.tryParse(paymentCtrl.text) ?? 0,
      commission: double.tryParse(commissionCtrl.text) ?? 0,
      note: noteCtrl.text,
      projectImages: images,
    );

    widget.onSave?.call(updated);
    Navigator.pop(context);
  }
}
