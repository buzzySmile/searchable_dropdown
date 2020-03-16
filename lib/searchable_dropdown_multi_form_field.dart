import 'package:flutter/material.dart';
import 'searchable_dropdown.dart';

class SearchableDropdownMultiFormField<T> extends FormField<List<T>> {
  SearchableDropdownMultiFormField({
    Key key,
    @required String labelText,
    Widget searchTitle,
    List<T> initialValues,
    @required List<T> items,
    bool isRequired = false,
    // FocusNode focusNode,
    bool autovalidate = false,
    FormFieldValidator<List<T>> validator,
    this.onChanged,
    FormFieldSetter<List<T>> onSaved,
  })  : assert(items != null || items.isNotEmpty),
        super(
            key: key,
            initialValue: initialValues ?? <T>[],
            autovalidate: autovalidate,
            validator: (List<T> selectedItems) {
              if (isRequired &&
                  (selectedItems == null || selectedItems.isEmpty)) {
                return 'Необходимо выбрать значение';
              }
              return validator == null ? null : validator(selectedItems);
            },
            onSaved: onSaved,
            builder: (FormFieldState<List<T>> field) {
              final InputDecoration effectiveDecoration = InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                isDense: true,
              ).applyDefaults(Theme.of(field.context).inputDecorationTheme);

              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      labelText + (isRequired ? ' *' : ''),
                      style: TextStyle(fontSize: 14.0, color: Colors.black54),
                    ),
                    InputDecorator(
                      decoration: effectiveDecoration.copyWith(
                          errorText: field.errorText),
                      isEmpty: field.value == null,
                      child: SearchableDropdown.multiple(
                        underline: Container(),
                        isExpanded: true,
                        searchHint: searchTitle,
                        selectedItems: items.expand<int>((item) {
                          if (field.value.contains(item))
                            return [items.indexOf(item)];
                          return [];
                        }).toList(),
                        displayClearIcon: false,
                        items: items.map<DropdownMenuItem<T>>((T item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.toString()),
                          );
                        }).toList(),
                        onChanged: (List<int> indices) => onChanged == null
                            ? null
                            : field.didChange(indices
                                .map((index) => items.elementAt(index))
                                .toList()),
                      ),
                    ),
                  ]);
            });

  final ValueChanged<List<T>> onChanged;

  @override
  FormFieldState<List<T>> createState() =>
      _SearchDropdownMultiCustomFieldState();
}

class _SearchDropdownMultiCustomFieldState<T> extends FormFieldState<List<T>> {
  @override
  SearchableDropdownMultiFormField<T> get widget => super.widget;

  @override
  void didChange(List<T> value) {
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged(value);
    validate();
  }
}
