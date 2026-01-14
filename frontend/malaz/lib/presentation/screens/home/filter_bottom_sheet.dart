import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:malaz/core/config/color/app_color.dart';
import 'package:malaz/presentation/cubits/home/home_cubit.dart';
import 'package:malaz/presentation/cubits/location/location_cubit.dart';
import 'package:malaz/l10n/app_localizations.dart';

import '../../../domain/entities/filters/filters.dart';
import '../pick_location/pick_location_screen.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(0, 5000);
  RangeValues _areaRange = const RangeValues(50, 10000);

  RangeValues _roomsRange = const RangeValues(0, 100);
  RangeValues _bedroomsRange = const RangeValues(0, 50);
  RangeValues _bathroomsRange = const RangeValues(0, 50);

  String? _selectedTypeKey;

  bool _useCurrentLocation = false;
  bool _useMapLocation = false;
  double? _selectedLat;
  double? _selectedLng;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _BuildHeader(
            title: l10n.filter_title,
            resetText: l10n.filter_reset,
            onReset: _resetFilters,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              children: [
                SizedBox(
                  width: 100,
                  height: 150,
                  child: Lottie.asset('assets/lottie/search_on_tablet.json'),
                ),
                _BuildSectionTitle(title: l10n.filter_location_section),
                _BuildLocationSection(
                  currentLocationTitle: l10n.filter_current_location,
                  mapLocationTitle: l10n.filter_map_location,
                  useCurrentLocation: _useCurrentLocation,
                  useMapLocation: _useMapLocation,
                  onCurrentLocationTap: () {
                    setState(() {
                      _useCurrentLocation = !_useCurrentLocation;
                      _useMapLocation = false;
                    });
                    if (_useCurrentLocation) {
                      final lang = Localizations.localeOf(context).languageCode;
                      context.read<LocationCubit>().getCurrentLocation(lang);
                    }
                  },
                  onMapLocationTap: () {
                      _pickLocationFromMap();
                    setState(() {
                      _useMapLocation = !_useMapLocation;
                      _useCurrentLocation = false;
                    });
                  },
                ),
                const SizedBox(height: 24),
                _BuildSectionTitle(title: l10n.filter_price_section),
                _BuildPriceSlider(
                  currentRange: _priceRange,
                  min: 0,
                  max: 5000,
                  onChanged: (values) => setState(() => _priceRange = values),
                ),
                const SizedBox(height: 24),
                _BuildSectionTitle(title: l10n.filter_type_section),
                _BuildPropertyTypeSelector(
                  selectedTypeKey: _selectedTypeKey,
                  typeMap: {
                    "Apartment": l10n.type_apartment,
                    "Villa": l10n.type_villa,
                    "Farm": l10n.type_farm,
                    "CountryHouse": l10n.type_country_house,
                    "Studio": l10n.type_studio,
                  },
                  onTypeSelected: (key) =>
                      setState(() => _selectedTypeKey = key),
                ),
                const SizedBox(height: 24),
                _BuildSectionTitle(title: l10n.filter_area_section),
                _BuildAreaSlider(
                  currentRange: _areaRange,
                  min: 0,
                  max: 10000,
                  onChanged: (values) => setState(() => _areaRange = values),
                ),
                const SizedBox(height: 24),
                _BuildSectionTitle(title: l10n.filter_details_section),
                _BuildIntRangeSlider(
                  title: l10n.filter_total_rooms,
                  currentRange: _roomsRange,
                  min: 0,
                  max: 100,
                  onChanged: (val) => setState(() => _roomsRange = val),
                ),
                const SizedBox(height: 16),
                _BuildIntRangeSlider(
                  title: l10n.filter_bedrooms,
                  currentRange: _bedroomsRange,
                  min: 0,
                  max: 50,
                  onChanged: (val) => setState(() => _bedroomsRange = val),
                ),
                const SizedBox(height: 16),
                _BuildIntRangeSlider(
                  title: l10n.filter_bathrooms,
                  currentRange: _bathroomsRange,
                  min: 0,
                  max: 50,
                  onChanged: (val) => setState(() => _bathroomsRange = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _BuildApplyButton(
            label: l10n.filter_apply_button,
            onTap: () => _applyFilters(context),
            isLocationLoading: _useCurrentLocation &&
                context.watch<LocationCubit>().state is LocationLoading,
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 5000);
      _areaRange = const RangeValues(50, 10000);
      _roomsRange = const RangeValues(0, 100);
      _bedroomsRange = const RangeValues(0, 50);
      _bathroomsRange = const RangeValues(0, 50);
      _selectedTypeKey = null;
      _useCurrentLocation = false;
      _useMapLocation = false;
      _selectedLat = null;
      _selectedLng = null;
    });

    context.read<HomeCubit>().clearFilter();

    Navigator.pop(context);
  }

  void _applyFilters(BuildContext context) {
    double? lat, lng;

    if (_useCurrentLocation) {
      final locState = context.read<LocationCubit>().state;
      if (locState is LocationLoaded) {
        lat = locState.location.lat;
        lng = locState.location.lng;
      }
    } else if (_useMapLocation) {
      lat = _selectedLat;
      lng = _selectedLng;
      print('lat shit $lat and lng shit $lng');
    }

    final params = Filter(
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
      minArea: _areaRange.start,
      maxArea: _areaRange.end,
      type: _selectedTypeKey,
      minRooms: _roomsRange.start.toInt(),
      maxRooms: _roomsRange.end.toInt(),
      minBedrooms: _bedroomsRange.start.toInt(),
      maxBedrooms: _bedroomsRange.end.toInt(),
      minBathrooms: _bathroomsRange.start.toInt(),
      maxBathrooms: _bathroomsRange.end.toInt(),
      lat: lat,
      lng: lng,
      radiusInKm: (lat != null) ? 10.0 : null,
    );

    context.read<HomeCubit>().loadApartments(newFilter: params);
    Navigator.pop(context);
  }

  Future<void> _pickLocationFromMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickLocationScreen(
          initialLat: _selectedLat,
          initialLng: _selectedLng,
        ),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        _selectedLat = result['lat'];
        _selectedLng = result['lng'];
        _useMapLocation = true;
        _useCurrentLocation = false;
      });
    }
  }
}

/// ============================================================================
/// [UI_BUILDING_WIDGETS] - Modular Components
/// ============================================================================

class _BuildHeader extends StatelessWidget {
  final String title;
  final String resetText;
  final VoidCallback onReset;

  const _BuildHeader(
      {required this.title, required this.resetText, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(resetText),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ),
    );
  }
}

class _BuildSectionTitle extends StatelessWidget {
  final String title;
  const _BuildSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _BuildLocationSection extends StatelessWidget {
  final String currentLocationTitle;
  final String mapLocationTitle;
  final bool useCurrentLocation;
  final bool useMapLocation;
  final VoidCallback onCurrentLocationTap;
  final VoidCallback onMapLocationTap;

  const _BuildLocationSection({
    required this.currentLocationTitle,
    required this.mapLocationTitle,
    required this.useCurrentLocation,
    required this.useMapLocation,
    required this.onCurrentLocationTap,
    required this.onMapLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SelectionCard(
            icon: Icons.my_location,
            title: currentLocationTitle,
            isSelected: useCurrentLocation,
            onTap: onCurrentLocationTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SelectionCard(
            icon: Icons.map_outlined,
            title: mapLocationTitle,
            isSelected: useMapLocation,
            onTap: onMapLocationTap,
          ),
        ),

      ],
    );
  }
}

class _BuildPriceSlider extends StatelessWidget {
  final RangeValues currentRange;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const _BuildPriceSlider({
    required this.currentRange,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("\$${currentRange.start.toInt()}",
                style: const TextStyle(
                    color: AppColors.tertiary, fontWeight: FontWeight.bold)),
            Text("\$${currentRange.end.toInt()}",
                style: const TextStyle(
                    color: AppColors.tertiary, fontWeight: FontWeight.bold)),
          ],
        ),
        RangeSlider(
          values: currentRange,
          min: min,
          max: max,
          divisions: 100,
          activeColor: AppColors.primaryDark,
          inactiveColor: Colors.grey.withOpacity(0.2),
          labels: RangeLabels(
            "\$${currentRange.start.toInt()}",
            "\$${currentRange.end.toInt()}",
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _BuildPropertyTypeSelector extends StatelessWidget {
  final String? selectedTypeKey;
  final Map<String, String> typeMap;
  final ValueChanged<String?> onTypeSelected;

  const _BuildPropertyTypeSelector({
    required this.selectedTypeKey,
    required this.typeMap,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: typeMap.entries.map((entry) {
          final isSelected = selectedTypeKey == entry.key;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              selectedColor: AppColors.primaryDark,
              backgroundColor: Theme.of(context).cardColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                onTypeSelected(selected ? entry.key : null);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BuildAreaSlider extends StatelessWidget {
  final RangeValues currentRange;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const _BuildAreaSlider({
    required this.currentRange,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${currentRange.start.round()} m²",
                style: const TextStyle(
                    color: AppColors.tertiary, fontWeight: FontWeight.bold)),
            Text("${currentRange.end.round()} m²",
                style: const TextStyle(
                    color: AppColors.tertiary, fontWeight: FontWeight.bold)),
          ],
        ),
        RangeSlider(
          values: currentRange,
          min: min,
          max: max,
          divisions: 100,
          activeColor: AppColors.primaryDark,
          inactiveColor: Colors.grey.withOpacity(0.2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _BuildRoomsCounters extends StatelessWidget {
  final String totalRoomsLabel;
  final String bedroomsLabel;
  final String bathroomsLabel;
  final String anyLabel;
  final int rooms;
  final int bedrooms;
  final int bathrooms;
  final ValueChanged<int> onRoomsChanged;
  final ValueChanged<int> onBedroomsChanged;
  final ValueChanged<int> onBathroomsChanged;

  const _BuildRoomsCounters({
    required this.totalRoomsLabel,
    required this.bedroomsLabel,
    required this.bathroomsLabel,
    required this.anyLabel,
    required this.rooms,
    required this.bedrooms,
    required this.bathrooms,
    required this.onRoomsChanged,
    required this.onBedroomsChanged,
    required this.onBathroomsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _CounterRow(
              title: totalRoomsLabel,
              anyLabel: anyLabel,
              value: rooms,
              onChanged: onRoomsChanged),
          const Divider(),
          _CounterRow(
              title: bedroomsLabel,
              anyLabel: anyLabel,
              value: bedrooms,
              onChanged: onBedroomsChanged),
          const Divider(),
          _CounterRow(
              title: bathroomsLabel,
              anyLabel: anyLabel,
              value: bathrooms,
              onChanged: onBathroomsChanged),
        ],
      ),
    );
  }
}

class _BuildApplyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLocationLoading;

  const _BuildApplyButton(
      {required this.label,
      required this.onTap,
      required this.isLocationLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 4),
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(32)),
        child: ElevatedButton(
          onPressed: isLocationLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: isLocationLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2))
              : Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withOpacity(0.1)
              : Theme.of(context).cardColor,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryLight
                : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primaryLight : Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primaryLight : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String title;
  final String anyLabel;
  final int value;
  final ValueChanged<int> onChanged;

  const _CounterRow(
      {required this.title,
      required this.anyLabel,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w500, color: theme.onSurface)),
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => value > 0 ? onChanged(value - 1) : null,
                  color: theme.onSurface),
              SizedBox(
                  width: 40,
                  child: Center(
                      child: Text(value == 0 ? anyLabel : "$value+",
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)))),
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => onChanged(value + 1),
                  color: theme.onSurface),
            ],
          ),
        ],
      ),
    );
  }
}

class _BuildIntRangeSlider extends StatelessWidget {
  final String title;
  final RangeValues currentRange;
  final double min;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const _BuildIntRangeSlider({
    required this.title,
    required this.currentRange,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              "${currentRange.start.toInt()} - ${currentRange.end.toInt()}",
              style: const TextStyle(
                  color: AppColors.tertiary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        RangeSlider(
          values: currentRange,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: AppColors.primaryDark,
          inactiveColor: Colors.grey.withOpacity(0.2),
          labels: RangeLabels(
            currentRange.start.toInt().toString(),
            currentRange.end.toInt().toString(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
