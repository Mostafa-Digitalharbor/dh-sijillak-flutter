import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../cubit/search_cubit.dart';

/// The query box of the search screen. It takes focus when it appears and
/// follows the cubit's query, so picking a recent search fills it in.
class SearchInputField extends StatefulWidget {
  const SearchInputField({super.key});

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  final _controller = TextEditingController();

  /// Scope around the field, used to hand the focus to it once it is built.
  final _scope = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scope.nextFocus();
    });
  }

  @override
  void dispose() {
    _scope.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _show(String query) {
    _controller.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listenWhen: (_, current) => current.query != _controller.text,
      listener: (_, state) => _show(state.query),
      child: FocusScope(
        node: _scope,
        child: AppTextField(
          hint: context.l10n.searchHint,
          controller: _controller,
          onChanged: context.read<SearchCubit>().queryChanged,
          height: AppSizes.fieldHeight,
        ),
      ),
    );
  }
}
