import 'package:desktop/infastructure/repositories/dtos/user_device_dto.dart';
import 'package:desktop/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infastructure/notifiers/generic_notifier.dart';

class UserList extends ConsumerWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userListNotifierProvider);
    if (state is Loaded<List<UserDeviceDTO>>) {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: ListView.builder(
          controller: ScrollController(),
          shrinkWrap: false,
          itemCount: state.loadedObject.length,
          itemBuilder: (context, i) {
            return _buildItems(ref, state.loadedObject[i]);
          },
        ),
      );
    } else {
      return const Text("Loading..");
    }
  }

  Widget _buildItems(WidgetRef ref, UserDeviceDTO dto) {
    return InkWell(
      child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: Column(children: [
            Text("Username: ${dto.user.username} - ${dto.user.id}"),
            Text("Brand: ${dto.device.brand} - ${dto.device.model}"),
            Text("SDK: ${dto.device.sdk}"),
          ])),
      onTap: () {
        final notifier = ref.watch(userDetailsNotifierProvider.notifier);
        final validatedNotifier = ref.watch(validatedNotifierProvider.notifier);

        notifier.getDetailsAsync(dto.user.id!);
        validatedNotifier.setUserId(dto.user.id!);
      },
    );
  }
}
