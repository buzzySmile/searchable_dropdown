import 'package:flutter/material.dart';
import 'searchable_dropdown.dart';

class SearchableDropdownFormField<T> extends FormField<T> {
  SearchableDropdownFormField({
    Key key,
    @required String labelText,
    Widget searchTitle,
    Widget closeButton,
    T defaultValue,
    T initialValue,
    @required List<T> items,
    bool loading = false,
    bool isRequired = false,
    bool autovalidate = false,
    FormFieldValidator<T> validator,
    this.onChanged,
    VoidCallback onValidationFailed,
    FormFieldSetter<T> onSaved,
  })  : assert(items != null || items.isNotEmpty || defaultValue != null),
        super(
            key: key,
            initialValue: initialValue ?? defaultValue,
            autovalidate: autovalidate,
            validator: (selectedItem) {
              if (isRequired && selectedItem == null) {
                if (onValidationFailed != null) {
                  onValidationFailed();
                }
                return 'Необходимо выбрать значение';
              }
              return validator == null ? null : validator(selectedItem);
            },
            onSaved: (T item) => onSaved(item),
            builder: (FormFieldState<T> field) {
              final InputDecoration effectiveDecoration = InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                fillColor: (defaultValue != null && defaultValue != field.value)
                    ? Colors.greenAccent.shade100
                    : null,
              ).applyDefaults(Theme.of(field.context).inputDecorationTheme);

              String _error;
              if (loading) {
                _error = 'Идет загрузка справочника...';
              } else if (items.isEmpty) {
                _error = 'Ошибка! Перезагрузите справочник';
              } else if (field.value != null && !items.contains(field.value)) {
                _error = 'Ошибка! Некорректное значение справочника';
              }

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
                          errorText: _error ?? field.errorText),
                      isEmpty: field.value == null || loading,
                      child: SearchableDropdown.single(
                        icon: loading
                            ? Container(
                                width: 24.0,
                                height: 24.0,
                                child: Material(
                                  type: MaterialType.circle,
                                  // elevation: 2.0,
                                  color: Theme.of(field.context).canvasColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(field.context).primaryColor),
                                    ),
                                  ),
                                ),
                              )
                            : const Icon(Icons.arrow_drop_down),
                        closeButton: closeButton,
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
