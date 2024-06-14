import 'package:flutter/material.dart';
import 'package:test_chat_app/chat_icons.dart';

import 'search_bar_delegate.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  void showSearchBar(BuildContext context) {
    showSearch(context: context, delegate: SearchBarDelegate());
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        showSearchBar(context);
      },
      readOnly: true,
      decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xffEDF2F6),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xffEDF2F6),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffEDF2F6))),
          isDense: true,
          hintText: 'Поиск',
          hintStyle: const TextStyle(
              color: Color(0xff9DB7CB),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Gilray'),
          prefixIcon: const Icon(
            Chat.Search_s,
            size: 24,
            color: Color(0xff9DB7CB),
          )),
      autofocus: false,
    );
  }
}
