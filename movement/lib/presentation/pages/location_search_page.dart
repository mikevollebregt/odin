import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movement/infrastructure/notifiers/responsive_ui.dart';
import 'package:rive/rive.dart';
import 'package:uuid/uuid.dart';

import '../../infrastructure/notifiers/generic_notifier.dart';
import '../../infrastructure/repositories/database/database.dart';
import '../../infrastructure/repositories/dtos/address_dto.dart';
import '../../infrastructure/repositories/dtos/enums/log_type.dart';
import '../../infrastructure/repositories/dtos/googlemaps_dto.dart';
import '../../infrastructure/repositories/dtos/parsed_response.dart';
import '../../infrastructure/repositories/dtos/stop_dto.dart';
import '../../infrastructure/repositories/log_repository.dart';
import '../../infrastructure/services/localization_service.dart';
import '../../providers.dart';

class LocationSearchPage extends ConsumerStatefulWidget {
  final StopDto stopDto;

  const LocationSearchPage(this.stopDto);

  @override
  ConsumerState<LocationSearchPage> createState() => LocationSearchPageState();
}

class LocationSearchPageState extends ConsumerState<LocationSearchPage> {
  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = '';
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    log('LocationSearchPage::build', '', LogType.Flow);
    final stopNotifier = ref.watch(stopNotifierProvider(widget.stopDto));
    final stopDto = stopNotifier.stopDto;

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: const BackButton(),
          title: _buildSearchField(context, ref),
        ),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 6 * y,
              child: _buildLoadingAnimation(ref, context),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(searchPageNotifierProvider);
                  final questionObject = GoogleMapsDTO(
                      placeId: 'UnknownID',
                      lat: 0,
                      lon: 0,
                      displayName: 'Niet gevonden? Druk op de kaart om je locatie te verzetten.',
                      address: AddressDTO(address: '', city: '', postcode: '', country: ''));
                  if (state is Loaded<ParsedResponse<List<GoogleMapsDTO>>>) {
                    final searchNotifier = ref.watch(searchPageNotifierProvider.notifier);
                    searchNotifier.resetAnimation();
                    if (state.loadedObject.payload != null) {
                      if (state.loadedObject.payload!.where((dto) => dto.placeId == 'UnknownID').isEmpty) {
                        state.loadedObject.payload!.add(questionObject);
                      }
                    } else {
                      state.loadedObject.payload = [];
                    }
                    return ListView.builder(
                      itemCount: state.loadedObject.payload!.length,
                      itemBuilder: (context, index) {
                        final address = state.loadedObject.payload![index];
                        return InkWell(
                          onTap: () {
                            if (address.placeId != 'UnknownID') {
                              final manualGeolocation = ManualGeolocation(
                                uuid: Uuid().v4(),
                                classifiedPeriodUuid: stopDto.classifiedPeriod.uuid,
                                createdOn: DateTime.now(),
                                latitude: address.lat!,
                                longitude: address.lon!,
                                synced: false,
                              );

                              log('LocationSearchPage::updateStopManualGeoloc', '', LogType.Flow);
                              stopNotifier.updateStop(googleMapsData: address.toGoogleMapsData(), manualGeolocations: [manualGeolocation]);
                            }
                            Navigator.pop(context);
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 15 * y, bottom: 15 * y, left: 15 * x),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.1,
                                    child: address.placeId != 'UnknownID'
                                        ? const FaIcon(
                                            FontAwesomeIcons.locationDot,
                                            color: Color(0xFF00A1CD),
                                          )
                                        : const FaIcon(
                                            FontAwesomeIcons.question,
                                            color: Color(0xFF00A1CD),
                                          ),
                                  ),
                                  if (address.placeId != 'UnknownID')
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text(address.displayName!.split(',')[0]),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5 * y),
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text(
                                            address.displayName!.split(',').length > 1
                                                ? '${address.displayName!.split(',')[1]} ${address.displayName!.split(',').length > 2 ? address.displayName!.split(',')[2] : ''}'
                                                : '',
                                            style: const TextStyle(color: Color(0xFFAAAAAA)),
                                          ),
                                        ),
                                      ],
                                    )
                                  else
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      child: Text(address.displayName!.split(',')[0]),
                                    ),
                                ],
                              )),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(searchPageNotifierProvider.notifier);
    _searchQueryController.text = notifier.getSearchText();
    _searchQueryController.selection = TextSelection.fromPosition(TextPosition(offset: _searchQueryController.text.length));
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).translate('locationsearchpage_hinttext'),
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.black26),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: EdgeInsets.only(left: 10 * x, bottom: 8 * y, top: 10 * y),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16 * f),
      onChanged: (query) {
        updateSearchQuery(ref, context, query);
      },
    );
  }

  Widget _buildLoadingAnimation(WidgetRef ref, BuildContext context) {
    final notifier = ref.read(searchPageNotifierProvider.notifier);

    return RiveAnimation.asset(
      'assets/animations/loading_loop.riv',
      controllers: [notifier.getController()],
      fit: BoxFit.fitWidth,
    );
  }

  void updateSearchQuery(WidgetRef ref, BuildContext context, String newQuery) {
    final notifier = ref.read(searchPageNotifierProvider.notifier);

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      notifier.setPlaying(true);
      notifier.searchQuery(newQuery);
    });

    setState(() {
      searchQuery = newQuery;
      notifier.setSearchText(newQuery);
      _searchQueryController.text = '';
    });
  }
}
