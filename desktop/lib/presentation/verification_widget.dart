import 'package:desktop/presentation/user_details.dart';
import 'package:desktop/presentation/user_list.dart';
import 'package:flutter/material.dart';

class VerificationWidget extends StatelessWidget {
  const VerificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: MediaQuery.of(context).size.width * 0.2, height: MediaQuery.of(context).size.height, child: const UserList()),
        SizedBox(width: MediaQuery.of(context).size.width * 0.8, height: MediaQuery.of(context).size.height, child: const UserDetails())
      ],
    );
  }
}
