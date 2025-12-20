import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';

class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  //  State Management & Controllers
  final List<XFile> _images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showImageError = false;

  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedPropertyType = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedPropertyType.isEmpty) {
      _selectedPropertyType = AppLocalizations.of(context)!.apartment;
    }
  }

  @override
  void dispose() {
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _priceController.dispose();
    _cityController.dispose();
    _governorateController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // 2. Business Logic/Actions
  void _addPhoto(XFile? img) {
    if (img != null) {
      setState(() {
        _images.add(img);
        _showImageError = false;
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isEmpty) {
        _showImageError = true;
      }
    });
  }

  void _submitProperty() {
    if (_images.isEmpty) {
      setState(() {
        _showImageError = true;
      });
    }

    final bool isFormValid = _formKey.currentState!.validate();
    final bool hasImages = _images.isNotEmpty;

    if (isFormValid && hasImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form Submitted Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: const _PropertyAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  _buildHeader(tr, colorScheme),
                  const SizedBox(height: 40),

                  _buildImageSection(tr, colorScheme),
                  const SizedBox(height: 30),

                  _buildEssentialDetailsSection(tr, colorScheme),
                  const SizedBox(height: 40),

                  _buildPriceSection(tr, colorScheme),
                  const SizedBox(height: 40),

                  _buildPropertyTypeSection(tr, colorScheme),
                  const SizedBox(height: 20),

                  _buildLocationDetailsSection(tr, colorScheme),
                  const SizedBox(height: 20),

                  _buildDescriptionSection(tr, colorScheme),

                  _buildSaveButton(tr),

                  const SizedBox(height: 20),
                ]),
          ),
        ),
      ),
    );
  }

  // 4. Helper Private Methods for UI Construction

  Widget _buildHeader(AppLocalizations tr, ColorScheme colorScheme) {
    return Center(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ShaderMask(
                shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                child: Text(
                  tr.malaz,
                  style: TextStyle(color: colorScheme.onPrimary, fontSize: 40, fontWeight: FontWeight.w500),
                ),
              ),
              ShaderMask(
                  shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                  child: SizedBox(
                    height: 70,
                    width: 60,
                    child: Image.asset(
                      "assets/icons/key_logo.png",
                      color: Colors.white,
                    ),
                  ))
            ]),
            const SizedBox(height: 10),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.goldGradientbut.createShader(bounds),
              child: Center(
                child: Text(
                  tr.share_your_property,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildImageSection(AppLocalizations tr, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 0),
              child: Text(
                tr.image_required,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEssentialDetailsSection(AppLocalizations tr, ColorScheme colorScheme) {
    const double titlePadding = 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: titlePadding, bottom: 15),
          child: Text(
            tr.essential_details,
            style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Row(children: [
          Expanded(
              child: _PropertyFormInputField(
                controller: _bedroomsController,
                icon: Icons.bed,
                hint: "0",
                preffix: tr.bedroom,
                isnumber: true,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return tr.field_required;
                  }
                  return null;
                },
              )),
          Expanded(
              child: _PropertyFormInputField(
                controller: _bathroomsController,
                icon: Icons.bathtub,
                hint: "0",
                preffix: tr.bathroom,
                isnumber: true,
                validator: (value) {
                  if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                    return tr.field_required;
                  }
                  return null;
                },
              )),
        ]),
        const SizedBox(height: 15),
        _PropertyFormInputField(
          controller: _areaController,
          icon: Icons.square_foot,
          hint: "0",
          preffix: tr.property_area,
          isnumber: true,
          suffix: ("sqft"),
          validator: (value) {
            if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
              return tr.field_required;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPriceSection(AppLocalizations tr, ColorScheme colorScheme) {
    const double titlePadding = 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: titlePadding, bottom: 10),
          child: Text(
            tr.price,
            style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _PropertyFormInputField(
          controller: _priceController,
          icon: Icons.money,
          hint: "0",
          preffix: "${tr.price} :",
          isnumber: true,
          suffix: "\$",
          validator: (value) {
            if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
              return tr.field_required;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPropertyTypeSection(AppLocalizations tr, ColorScheme colorScheme) {
    const double titlePadding = 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: titlePadding, bottom: 5),
          child: Text(
            tr.property_type,
            style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _PropertyTypeSelector(onTypeSelected: (selectedType) {
          _selectedPropertyType = selectedType;
        }),
      ],
    );
  }

  Widget _buildLocationDetailsSection(AppLocalizations tr, ColorScheme colorScheme) {
    const double titlePadding = 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: titlePadding, bottom: 15),
          child: Text(
            tr.location_details,
            style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _PropertyFormInputField(
          controller: _cityController,
          icon: Icons.location_city,
          hint: tr.syria,
          preffix: tr.city,
          isnumber: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.field_required;
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        _PropertyFormInputField(
          controller: _governorateController,
          icon: Icons.public,
          hint: tr.damascus,
          preffix: tr.governorate,
          isnumber: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.field_required;
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        _PropertyFormInputField(
          controller: _addressController,
          icon: Icons.pin_drop,
          hint: tr.address_loc,
          preffix: tr.address,
          isnumber: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.field_required;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(AppLocalizations tr, ColorScheme colorScheme) {
    const double titlePadding = 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: titlePadding, bottom: 10),
          child: Text(
            tr.description,
            style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _PropertyFormInputField(
          controller: _descriptionController,
          hint: tr.describe_property,
          icon: Icons.description,
          preffix: "${tr.description}:",
          isnumber: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.field_required;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaveButton(AppLocalizations tr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
      child: _PrimaryGradientButton(
        text: tr.save,
        onTap: _submitProperty,
      ),
    );
  }
}

class _PropertyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _PropertyAppBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return AppBar(
      title: Text(
        tr.add_property,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      foregroundColor: colorScheme.onSurface,
      centerTitle: false,
    );
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
    this.suffix = '',
  });

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

        inputFormatters: isnumber
            ? [
          FilteringTextInputFormatter.digitsOnly,
        ]
            : null,

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
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final tr = AppLocalizations.of(context)!;
      propertyTypes = [
        tr.apartment,
        tr.villa,
        tr.house,
        tr.farm,
        tr.country_house,
      ];

      if (propertyTypes.isNotEmpty) {
        _selectedType = propertyTypes.first;
      }
      _isInit = false;
    }
  }

  void _handleSelection(String type) {
    setState(() {
      _selectedType = type;
    });
    if (widget.onTypeSelected != null && _selectedType != null) {
      widget.onTypeSelected!(_selectedType!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 10.0,
        children: propertyTypes.map((type) {
          return _TypeSelectorButton(
            text: type,
            isSelected: _selectedType == type,
            onTap: () => _handleSelection(type),
          );
        }).toList(),
      ),
    );
  }
}


class _TypeSelectorButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeSelectorButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isSelected ? colorScheme.primary : colorScheme.surface;
    final textColor = isSelected ? colorScheme.onPrimary : colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _PropertyImageCarousel extends StatefulWidget {
  final List<XFile> images;
  final Function(XFile?) onImageAdded;
  final Function(int index)? onImageRemoved;
  final bool showError;

  const _PropertyImageCarousel({
    required this.images,
    required this.onImageAdded,
    this.onImageRemoved,
    this.showError = false,
  });

  @override
  State<_PropertyImageCarousel> createState() => _PropertyImageCarouselState();
}

class _PropertyImageCarouselState extends State<_PropertyImageCarousel> {
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    widget.onImageAdded(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;

    return _DottedBox(
      isError: widget.showError,
      child: SizedBox(
        height: 250,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: widget.images.isEmpty
                    ? Center(
                  child: Text(
                    tr.uploud_photo_property,
                    style: TextStyle(color: colorScheme.primary, fontSize: 16),
                  ),
                )
                    : PageView.builder(
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Image.file(
                          File(widget.images[index].path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),

                        // زر الحذف
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              if (widget.onImageRemoved != null) {
                                widget.onImageRemoved!(index);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade700,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5)),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // زر إضافة الصورة
            Positioned(
              top: 10,
              left: 10,
              child: _GradientFab(onPressed: _pickImage),
            ),
          ],
        ),
      ),
    );
  }
}


class _DottedBox extends StatelessWidget {
  final Widget child;
  final bool isError;
  const _DottedBox({required this.child, this.isError = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isError ? Colors.red : Theme.of(context).colorScheme.primary;

    const BoxDecoration borderDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      border: Border.fromBorderSide(BorderSide(color: Colors.transparent, width: 2.0)),
    );

    return SizedBox(
      width: double.infinity,
      child: CustomPaint(
        painter: __PrimaryBorderPainter(
          decoration: borderDecoration,
          borderColor: borderColor,
          isError: isError,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: child,
        ),
      ),
    );
  }
}


class __PrimaryBorderPainter extends CustomPainter {
  final BoxDecoration decoration;
  final Color? borderColor;
  final bool isError;

  __PrimaryBorderPainter({required this.decoration, this.borderColor, required this.isError});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint borderPaint = Paint();

    borderPaint.color = isError ? Colors.red : (borderColor ?? Colors.transparent);

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 2.0;

    final RRect rrect =
    RRect.fromRectAndRadius(rect, decoration.borderRadius!.resolve(TextDirection.ltr).topLeft);

    // لرسم خط متقطع (dotted line)، نحتاج إلى منطق مختلف. بما أن الكلاس الأصلي لم يكن يرسم خطاً متقطعاً حقيقياً،
    // بل يرسم RRect عادي، سأبقيه كما كان مع تغيير الاسم ليصبح خاصاً:
    canvas.drawRRect(rrect.deflate(borderPaint.strokeWidth / 2), borderPaint);
  }

  @override
  bool shouldRepaint(covariant __PrimaryBorderPainter oldDelegate) {
    return oldDelegate.isError != isError || oldDelegate.borderColor != borderColor;
  }
}


class _GradientFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _GradientFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.realGoldGradient,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(Icons.add_a_photo, color: colorScheme.surface, size: 20),
      ),
    );
  }
}