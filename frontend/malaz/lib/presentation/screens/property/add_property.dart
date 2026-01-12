import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:malaz/presentation/global_widgets/brand/build_branding.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';
import '../../cubits/property/property_cubit.dart';
import '../../global_widgets/glowing_key/build_glowing_key.dart';
import 'map_picker.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final List<XFile> _images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showImageError = false;

  // Controllers
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  double? _selectedLat;
  double? _selectedLng;
  String _selectedPropertyType = '';
  String? _selectedGovernorate;

  @override
  void initState() {
    super.initState();
    context.read<AddApartmentCubit>().resetState();
  }

  @override
  void dispose() {
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _titleController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  String _mapTypeToEnglish(String localType, AppLocalizations tr) {
    if (localType == tr.apartment) return 'Apartment';
    if (localType == tr.villa) return 'Villa';
    if (localType == tr.farm) return 'Farm';
    if (localType == tr.house) return 'House';
    if (localType == tr.country_house) return 'Country House';
    return 'Apartment';
  }

  void _addPhoto(XFile? img) {
    if (img != null) {
      setState(() { _images.add(img); _showImageError = false; });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isEmpty) _showImageError = true;
    });
  }

  void _submitProperty() {
    if (_images.isEmpty) setState(() => _showImageError = true);
    if (_selectedLat == null || _selectedLng == null) {
      _showSnackBar(context, "piease select locationً", Colors.orange);
      return;
    }

    if (_cityController.text.isEmpty) _cityController.text = "City Selected";
    if (_addressController.text.isEmpty) _addressController.text = "Address Selected";

    if (_formKey.currentState!.validate() && _images.isNotEmpty) {
      final tr = AppLocalizations.of(context)!;
      context.read<AddApartmentCubit>().submitApartment(
          title: _titleController.text,
          price: int.parse(_priceController.text),
          rooms: int.parse(_roomsController.text),
          bathrooms: int.parse(_bathroomsController.text),
          bedrooms: int.parse(_bedroomsController.text),
          area: int.parse(_areaController.text),
          city: _cityController.text,
          governorate:_selectedGovernorate!,
          address: _addressController.text,
          description: _descriptionController.text,
          type: _mapTypeToEnglish(_selectedPropertyType, tr),
          images: _images,
          main_pic: _images.first,
        latitide: _selectedLat ?? 0.0,
        longitude: _selectedLng ?? 0.0,

      );
    }
  }
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return BlocConsumer<AddApartmentCubit, ApartmentState>(
      listener: (context, state) {
        final bool isActuallySuccess = state is AddApartmentSuccess ||
            (state is AddApartmentError && (state.message.contains("successfully") || state.message.contains("بنجاح")));

        if (isActuallySuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
          final message = (state is AddApartmentSuccess) ? state.message : (state as AddApartmentError).message;
          _showSnackBar(context, message, Colors.green);
            Navigator.of(context).pop();

        }
        else if (state is AddApartmentError) {
          _showSnackBar(context, state.message, Colors.red);
        }
      },
      builder: (context, state) {
        final isLoading = state is AddApartmentLoading;

        return ModalProgressHUD(
          inAsyncCall: isLoading,
          color: Colors.white,
          dismissible: false,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: const _PropertyAppBar(),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40),
                      _buildHeader(tr, colorScheme),
                      const SizedBox(height: 30),
                      _buildImageSection(tr, colorScheme),
                      const SizedBox(height: 20),
                      _buildEssentialDetailsSection(tr, colorScheme),
                      const SizedBox(height: 30),
                      _buildPriceSection(tr, colorScheme),
                      const SizedBox(height: 30),
                      _buildPropertyTypeSection(tr, colorScheme),
                      const SizedBox(height: 20),
                      _buildLocationDetailsSection(tr, colorScheme),
                      const SizedBox(height: 20),
                      _buildDescriptionSection(tr, colorScheme),
                      _buildSaveButton(tr, _submitProperty),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedLat = result['lat'];
        _selectedLng = result['lng'];

        var details = result['details'];
        if (details != null) {
          _cityController.text = details['city'] ?? '';
          _addressController.text = details['address'] ?? '';
          _selectedGovernorate = details['governorate']??'';
        }
      });
    }
  }

  Widget _buildHeader(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      children: [
        BuildBranding(),
        Text(tr.share_your_property, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6), fontSize: 14)),
      ],
    );
  }

  Widget _buildImageSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PropertyImageCarousel(
            images: _images,
            onImageAdded: _addPhoto,
            onImageRemoved: _removePhoto,
            showError: _showImageError,
          ),
          if (_showImageError)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text("At least one image is required", style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _buildEssentialDetailsSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(tr.essential_details, style: TextStyle(color: colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        _PropertyFormInputField(controller: _titleController, icon: Icons.title, hint: tr.title_hint, preffix: tr.title+":", isnumber: false, validator: (v) => v!.isEmpty ? tr.field_required : null),
        Row(children: [
          Expanded(child: _PropertyFormInputField(controller: _roomsController, icon: Icons.meeting_room, hint: "0", preffix: "${tr.rooms}:", isnumber: true, validator: (v) => v!.isEmpty ? tr.field_required : null)),
          Expanded(child: _PropertyFormInputField(controller: _bedroomsController, icon: Icons.bed, hint: "0", preffix: tr.bedrooms, isnumber: true, validator: (v) => v!.isEmpty ? tr.field_required : null)),
        ]),
        Row(children: [
          Expanded(child: _PropertyFormInputField(controller: _bathroomsController, icon: Icons.bathtub, hint: "0", preffix: tr.bathrooms, isnumber: true, validator: (v) => v!.isEmpty ? tr.field_required : null)),
        ]),
        _PropertyFormInputField(controller: _areaController, icon: Icons.square_foot, hint: "0", preffix: tr.area, isnumber: true, suffix: "sqft", validator: (v) => v!.isEmpty ? tr.field_required : null),
      ],
    );
  }

  Widget _buildPriceSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(tr.price, style: TextStyle(color: colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold))),
        _PropertyFormInputField(controller: _priceController, icon: Icons.payments, hint: "0", preffix: "${tr.price}:", isnumber: true, suffix: "\$", validator: (v) => v!.isEmpty ? tr.field_required : null),
      ],
    );
  }

  Widget _buildPropertyTypeSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(tr.property_type, style: TextStyle(color: colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold))),
        _PropertyTypeSelector(onTypeSelected: (type) => _selectedPropertyType = type),
      ],
    );
  }

  Widget _buildLocationDetailsSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Text(
            tr.location_details,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: InkWell(
            onTap: _openMapPicker,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    FlutterMap(
                      key: ValueKey('${_selectedLat}_${_selectedLng}'),
                      options: MapOptions(
                        initialCenter: _selectedLat != null
                            ? LatLng(_selectedLat!, _selectedLng!)
                            : const LatLng(33.5138, 36.2765),
                        initialZoom: _selectedLat != null ? 15.0 : 12.0,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                          userAgentPackageName: 'com.malaz.app',
                        ),
                        if (_selectedLat != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(_selectedLat!, _selectedLng!),
                                width: 80,
                                height: 80,
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                            ],
                          ),
                      ],
                    ),

                    if (_selectedLat != null)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text("Edit location", style: TextStyle(fontSize: 12, color: colorScheme.primary)),
                            ],
                          ),
                        ),
                      ),

                    if (_selectedLat == null)
                      Container(
                        color: Colors.black.withOpacity(0.2),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.map_outlined, color: Colors.white, size: 40),
                              const SizedBox(height: 8),
                              Text("click to select location", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildDescriptionSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Text(tr.description, style: TextStyle(color: colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold))),
        _PropertyFormInputField(controller: _descriptionController, hint: tr.describe_property, icon: Icons.description, preffix: "", isnumber: false, validator: (v) => v!.isEmpty ? tr.field_required : null),
      ],
    );
  }

  Widget _buildSaveButton(AppLocalizations tr, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: _PrimaryGradientButton(text: tr.save, onTap: onTap),
    );
  }
}


class _PropertyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PropertyAppBar();
  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(decoration: const BoxDecoration(gradient: AppColors.premiumGoldGradient2)),

            PositionedDirectional(
              top: -20,
              start: -40,
              child: const BuildGlowingKey(size: 180,opacity: 0.15,rotation: -0.2),
            ),

            PositionedDirectional(
              bottom: 40,
              end: -10,
              child: const BuildGlowingKey(size: 140,opacity: 0.12,rotation: 0.5),
            ),

            PositionedDirectional(
              top: 40,
              end: 80,
              child: const BuildGlowingKey(size: 70,opacity: 0.12,rotation: 2.5),
            ),
          ],
        )
    ), title: Text(tr.add_property, style: TextStyle(fontWeight: FontWeight.bold,color:colorScheme.surface)),);
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PrimaryGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryGradientButton({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))]),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: ShaderMask(shaderCallback: (bounds) => AppColors.premiumGoldGradient2.createShader(bounds), child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))))),
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _PropertyFormInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hint;
  final IconData icon;
  final String preffix;
  final String suffix;
  final bool isnumber;

  const _PropertyFormInputField({
    this.controller,
    this.validator,
    required this.hint,
    required this.icon,
    required this.isnumber,
    required this.preffix,
    this.suffix = '',});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double horizontalPadding = 17.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: isnumber ? TextInputType.number : TextInputType.text,
        maxLines: isnumber ? 1 : null,
        minLines: isnumber ? null : 1,
        inputFormatters: isnumber ? [FilteringTextInputFormatter.digitsOnly,] : null,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: colorScheme.onSurface,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  preffix,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          suffixIcon: (suffix.isNotEmpty && suffix != ' ')
              ? Padding(
            padding: const EdgeInsets.only(right: 15),
            child: SizedBox(
              width: 37,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  suffix,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
              : null,
          hintText: hint,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.4),
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}



class _PropertyTypeSelector extends StatefulWidget {
  final Function(String type)? onTypeSelected;
  const _PropertyTypeSelector({this.onTypeSelected});
  @override
  State<_PropertyTypeSelector> createState() => _PropertyTypeSelectorState();
}

class _PropertyTypeSelectorState extends State<_PropertyTypeSelector> {
  List<String> propertyTypes = [];
  String? _selectedType;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tr = AppLocalizations.of(context)!;
    propertyTypes = [tr.apartment, tr.villa, tr.house, tr.farm, tr.country_house];
    _selectedType ??= propertyTypes.first;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Wrap(
        spacing: 12, runSpacing: 10,
        children: propertyTypes.map((type) => _TypeSelectorButton(text: type, isSelected: _selectedType == type, onTap: () { setState(() => _selectedType = type); widget.onTypeSelected?.call(type); })).toList(),
      ),
    );
  }
}

class _TypeSelectorButton extends StatelessWidget {
  final String text; final bool isSelected; final VoidCallback onTap;
  const _TypeSelectorButton({required this.text, required this.isSelected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(gradient: isSelected ? AppColors.premiumGoldGradient2: null,color: !isSelected ? colorScheme.surface : null, borderRadius: BorderRadius.circular(10), border: Border.all(color: colorScheme.primary.withOpacity(0.3))),
        child: Text(text, style: TextStyle(color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _PropertyImageCarousel extends StatelessWidget {
  final List<XFile> images;
  final Function(XFile?) onImageAdded;
  final Function(int index) onImageRemoved;
  final bool showError;

  const _PropertyImageCarousel({required this.images, required this.onImageAdded, required this.onImageRemoved, this.showError = false});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return _DottedBox(
      isError: showError,
      child: SizedBox(
        height: 250,
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: images.isEmpty
                    ? Center(child: Text(tr.uploud_photo_property, style: TextStyle(color: Theme.of(context).colorScheme.primary)))
                    : PageView.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) => Stack(children: [
                    Image.file(File(images[index].path), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                    Positioned(top: 8, right: 8, child: GestureDetector(onTap: () => onImageRemoved(index), child: Container(decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Icon(Icons.close, color: Colors.white, size: 20)))),
                  ]),
                ),
              ),
            ),
            Positioned(top: 10, left: 10, child: _GradientFab(onPressed: () async {
              final img = await ImagePicker().pickImage(source: ImageSource.gallery);
              onImageAdded(img);
            })),
          ],
        ),
      ),
    );
  }
}

class _DottedBox extends StatelessWidget {
  final Widget child; final bool isError;
  const _DottedBox({required this.child, this.isError = false});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: __PrimaryBorderPainter(isError: isError, borderColor: Theme.of(context).colorScheme.primary), child: Padding(padding: const EdgeInsets.all(5), child: child));
  }
}

class __PrimaryBorderPainter extends CustomPainter {
  final bool isError; final Color borderColor;
  __PrimaryBorderPainter({required this.isError, required this.borderColor});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = isError ? Colors.red : borderColor ..style = PaintingStyle.stroke..strokeWidth = 2.0;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(18)), paint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _GradientFab({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onPressed, child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, gradient: AppColors.premiumGoldGradient2), child: Icon(Icons.add_a_photo, color: Colors.white, size: 20)));
  }
}