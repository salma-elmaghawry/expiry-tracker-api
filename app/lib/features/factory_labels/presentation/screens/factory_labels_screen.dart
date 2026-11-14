import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/cubit/create_labels_cubit.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/cubit/create_labels_state.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/models/label_draft.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/create_labels_form.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/factory_header.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/label_form_controllers.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/label_preview_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Factory portal, web: fill the form once, get one signed QR label per carton.
class FactoryLabelsScreen extends StatelessWidget {
  const FactoryLabelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateLabelsCubit>(),
      child: const _FactoryLabelsView(),
    );
  }
}

class _FactoryLabelsView extends StatefulWidget {
  const _FactoryLabelsView();

  @override
  State<_FactoryLabelsView> createState() => _FactoryLabelsViewState();
}

class _FactoryLabelsViewState extends State<_FactoryLabelsView> {
  final _controllers = LabelFormControllers();
  Category _category = Category.snacks;
  DateTime? _productionDate;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    // Any key press: redraw the preview, and drop server errors that are now stale.
    _controllers.anyChange.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _controllers.anyChange.removeListener(_onFormChanged);
    _controllers.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    context.read<CreateLabelsCubit>().clearErrors();
    setState(() {});
  }

  // Built fresh on every build: cheap, and it can never get out of sync with the fields.
  LabelDraft get _draft => LabelDraft(
    name: _controllers.name.text,
    barcode: _controllers.barcode.text,
    category: _category,
    boxesText: _controllers.boxes.text,
    perBoxText: _controllers.perBox.text,
    lot: _controllers.lot.text,
    productionDate: _productionDate,
    expiryDate: _expiryDate,
    costText: _controllers.cost.text,
    countText: _controllers.count.text,
  );

  Future<void> _pickDate({required bool expiry}) async {
    final now = DateTime.now();
    final current = expiry ? _expiryDate : _productionDate;
    final picked = await showDatePicker(
      context: context,
      initialDate:
          current ??
          (expiry && _productionDate != null
              ? _productionDate!.add(const Duration(days: 1))
              : now),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null || !mounted) return;

    // Calendar date only, in UTC, like every date the API sends us.
    final date = DateTime.utc(picked.year, picked.month, picked.day);
    context.read<CreateLabelsCubit>().clearErrors();
    setState(() => expiry ? _expiryDate = date : _productionDate = date);
  }

  void _submit() {
    final draft = _draft;
    if (!draft.isComplete) return;
    FocusScope.of(context).unfocus();
    context.read<CreateLabelsCubit>().create(draft.toParams());
  }

  void _onStateChanged(BuildContext context, CreateLabelsState state) {
    final messenger = ScaffoldMessenger.of(context);

    if (state.isSuccess && state.job != null) {
      final job = state.job!;
      // Step 3 replaces this with opening the print preview of this job.
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'factory.created'.tr(
                args: [
                  '${job.cartonCount}',
                  job.firstCartonCode,
                  job.lastCartonCode,
                ],
              ),
            ),
          ),
        );
    }

    // Field errors appear under their fields; anything else gets a snackbar.
    if (state.isFailure && state.failure is! ValidationFailure) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(state.message ?? '')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = _draft;

    return BlocConsumer<CreateLabelsCubit, CreateLabelsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _onStateChanged,
      builder: (context, state) {
        final form = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('factory.title'.tr(), style: AppTextStyles.font32ExtraBold),
            verticalSpace(4),
            Text(
              'factory.subtitle'.tr(),
              style: AppTextStyles.font14Normal.secondary(context),
            ),
            verticalSpace(16),
            CreateLabelsForm(
              controllers: _controllers,
              draft: draft,
              serverErrors: state.fieldErrors,
              isSubmitting: state.isLoading,
              onCategoryChanged: (category) =>
                  setState(() => _category = category),
              onPickProductionDate: () => _pickDate(expiry: false),
              onPickExpiryDate: () => _pickDate(expiry: true),
              onSubmit: _submit,
            ),
          ],
        );
        final preview = LabelPreviewPanel(draft: draft);

        return Scaffold(
          body: Column(
            children: [
              FactoryHeader(current: FactoryTab.create),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.r,
                          vertical: 28.r,
                        ),
                        // Wide: form and preview side by side. Narrow: preview under the form.
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 900) {
                              return Column(
                                children: [form, verticalSpace(28), preview],
                              );
                            }
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 11, child: form),
                                horizontalSpace(28),
                                Expanded(
                                  flex: 9,
                                  child: Padding(
                                    // Lines the preview title up with the form card.
                                    padding: EdgeInsets.only(top: 6.r),
                                    child: preview,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
