import 'package:flutter/material.dart';
import 'searchable_dropdown.dart';

class SearchableDropdownFormField<T> extends FormField<T> {
  SearchableDropdownFormField({
    Key key,
    @required String labelText,
    Widget searchTitle,
    T defaultValue,
    T initialValue,
    @required List<T> items,
    bool isRequired = false,
    // FocusNode focusNode,
    bool autovalidate = false,
    FormFieldValidator<T> validator,
    this.onChanged,
    FormFieldSetter<T> onSaved,
  })  : assert(items != null || items.isNotEmpty || defaultValue != null),
        super(
            key: key,
            initialValue: initialValue != null ? initialValue : defaultValue,
            autovalidate: autovalidate,
            validator: (selectedItem) {
              if (isRequired && selectedItem == null) {
                return 'Необходимо выбрать значение';
              }
              return validator == null ? null : validator(selectedItem);
            },
            onSaved: (T item) => onSaved(item),
            builder: (FormFieldState<T> field) {
              final InputDecoration effectiveDecoration = InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                isDense: true,
                fillColor: (defaultValue != null && defaultValue != field.value)
                    ? Colors.greenAccent.shade100
                    : null,
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
                      child: SearchableDropdown.single(
                        closeButton: null,
                        // closeButton: (selectedItems) => FlatButton(
                        //   padding: EdgeInsets.zero,
                        //   onPressed: () => Navigator.pop(field.context),
                        //   child: buttonTitle,
                        // ),
                        underline: Container(),
                        isExpanded: true,
                        searchHint: searchTitle,
                        value: field.value,
                        displayClearIcon: false,
                        items: items.map<DropdownMenuItem<T>>((T item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item.toString()),
                          );
                        }).toList(),
                        onChanged: onChanged == null ? null : field.didChange,
                      ),
                    ),
                  ]);
            });

  final ValueChanged<T> onChanged;

  @override
  FormFieldState<T> createState() => _SearchDropdownCustomFieldState();
}

class _SearchDropdownCustomFieldState<T> extends FormFieldState<T> {
  @override
  SearchableDropdownFormField<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged(value);
    validate();
  }
}
