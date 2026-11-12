import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

/// Simple LatLng class to replace google_maps_flutter dependency
class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}

class AddressMapView extends StatefulWidget {
  const AddressMapView({super.key, required this.onLocationSelect});

  final Function(LatLng? latLng, String? address, String? cc) onLocationSelect;

  @override
  State<AddressMapView> createState() => AddressMapViewState();
}

class AddressMapViewState extends State<AddressMapView> {
  bool btLoad = false;
  String? country;

  LatLng? current;
  bool mkLoad = false;
  final txCtrl = TextEditingController();

  @override
  void dispose() {
    txCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final location = Location();

    bool service;
    PermissionStatus permission;
    LocationData loc;

    service = await location.serviceEnabled();
    if (!service) {
      service = await location.requestService();
      if (!service) {
        Toaster.showError(TR.current.enableLocSer);
        return;
      }
    }

    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        Toaster.showError(TR.current.grantLocPermission);
        return;
      }
    }

    loc = await location.getLocation();
    final latLng = LatLng(loc.latitude!, loc.longitude!);
    current = latLng;
    await getAddressString(latLng);
    if (mounted) setState(() {});
  }

  Future<void> getAddressString(LatLng latlng) async {
    try {
      final place = await geo.placemarkFromCoordinates(
        latlng.latitude,
        latlng.longitude,
      );

      final loc = place.firstOrNull;

      if (loc == null) {
        Toaster.showError('Unable to find address for this location');
        return;
      }

      txCtrl.text =
          '${loc.street}, ${loc.subLocality}, ${loc.locality}, ${loc.country}';

      country = loc.isoCountryCode;
    } catch (e) {
      Toaster.showError('Error retrieving address: ${e.toString()}');
    }
  }

  Future<void> searchAddress() async {
    try {
      final address = txCtrl.text.trim();
      if (address.isEmpty) {
        Toaster.showError('Please enter a valid address');
        return;
      }

      setState(() => mkLoad = true);

      final place = await geo.locationFromAddress(address);
      final loc = place.firstOrNull;

      if (loc == null) {
        Toaster.showError('Address not found. Please try a different address');
        setState(() => mkLoad = false);
        return;
      }

      Logger.json(place.map((e) => e.toJson()).toList());
      current = LatLng(loc.latitude, loc.longitude);

      await getAddressString(current!);

      setState(() => mkLoad = false);
    } catch (e) {
      setState(() => mkLoad = false);
      Toaster.showError('Error searching address: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.selectLocation),
        leading: IconButton(
          onPressed: () {
            widget.onLocationSelect(current, txCtrl.text, country);
            context.nPop();
          },
          icon: const Icon(Icons.done_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => context.nPop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Location display area (replaces GoogleMap)
          Expanded(
            child: Container(
              color: context.colors.surfaceContainerHighest,
              child: current == null
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Padding(
                        padding: defaultPaddingAll,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 64,
                              color: context.colors.primary,
                            ),
                            const Gap(Insets.lg),
                            Text(
                              'Current Location',
                              style: context.textTheme.titleLarge,
                            ),
                            const Gap(Insets.sm),
                            Container(
                              padding: const EdgeInsets.all(Insets.med),
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: defaultRadius,
                                border: Border.all(
                                  color: context.colors.outline.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.my_location,
                                        size: 16,
                                        color: context.colors.primary,
                                      ),
                                      const Gap(Insets.sm),
                                      Text(
                                        'Lat: ${current!.latitude.toStringAsFixed(6)}',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  const Gap(Insets.xs),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.my_location,
                                        size: 16,
                                        color: context.colors.primary,
                                      ),
                                      const Gap(Insets.sm),
                                      Text(
                                        'Lng: ${current!.longitude.toStringAsFixed(6)}',
                                        style: context.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Gap(Insets.lg),
                            Text(
                              'Enter your address below or use current location',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          // Address input section
          Container(
            color: context.colors.surface,
            padding: defaultPaddingAll,
            width: context.width,
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: txCtrl,
                    enabled: !mkLoad,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Enter address or street name',
                      suffixIcon: IconButton(
                        onPressed: mkLoad ? null : () => searchAddress(),
                        icon: mkLoad
                            ? const SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                ),
                const Gap(Insets.med),
                IconButton.filled(
                  onPressed: (btLoad || mkLoad)
                      ? null
                      : () async {
                          setState(() => btLoad = true);
                          await getLocation();
                          setState(() => btLoad = false);
                        },
                  icon: btLoad
                      ? SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            color: context.colors.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.location_on),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
