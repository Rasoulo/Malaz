import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/color/app_color.dart';
import '../../../l10n/app_localizations.dart';

class AddProperty extends StatefulWidget {
  const AddProperty({super.key});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  final List<XFile> _images = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showImageError = false;

  // Controllers لحقول الإدخال
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _governorateController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _selectedPropertyType = 'Apartment';

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
    // 1. التحقق من وجود صورة
    if (_images.isEmpty) {
      setState(() {
        _showImageError = true;
      });
    }

    // 2. التحقق من صحة حقول النموذج (Validation)
    final isValid = _formKey.currentState!.validate();

    if (isValid && _images.isNotEmpty) {
      // إذا كان النموذج صحيحاً والصور موجودة، قم بإرسال البيانات
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property Data is valid and saved!')),
      );
      // يمكنك هنا إضافة منطق إرسال البيانات (API call)
    } else {
      // إظهار رسالة خطأ عامة إذا فشل التحقق
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the highlighted errors.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tr = AppLocalizations.of(context)!;
    const double titlePadding = 24.0; // بادئة موحدة للعناوين

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title:  Text("Add property", style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),

                  // شعار المالاز
                  ShaderMask(
                      shaderCallback: (bounds) => AppColors.realGoldGradient.createShader(bounds),
                      child:Center(
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(" MALAZ",style: TextStyle(color: colorScheme.onPrimary,fontSize: 40),),
                                Icon(Icons.house,color: colorScheme.onPrimary,size: 40,),
                              ]
                          )
                      )
                  ),
                  const SizedBox(height: 10),

                  // رسالة الترحيب
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.goldGradientbut.createShader(bounds),
                    child:const Center(
                      child: Text(
                        "Share your property details with us",
                        style: TextStyle(color: Colors.white,fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🌟 1. واجهة رفع الصور
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child :PropertyImageCarousel(
                      images: _images,
                      onImageAdded: _addPhoto,
                      onImageRemoved: _removePhoto,
                      showError: _showImageError,
                    ),
                  ),
                  if (_showImageError)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 24),
                      child: Text(tr.image_required,
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // 🌟 2. عنوان الميزات الأساسية
                  Padding(
                    padding: EdgeInsets.only(left: titlePadding, bottom: 15),
                    child: Text(
                      "Essential Details",
                      style: TextStyle(color: colorScheme.primary,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // حقول غرف النوم والحمامات (في صف واحد)
                  Row(
                      children: [
                        Expanded(
                            child: BedroomTextFieldInline(
                              controller: _bedroomsController,
                              icon: Icons.bed,
                              hint: "0",
                              preffix: "Bedrooms:",
                              isnumber: true,
                              suffix: "",
                              validator: (value) {
                                if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                                  return 'Required (Number)';
                                }
                                return null;
                              },
                            )
                        ),
                        Expanded(
                            child: BedroomTextFieldInline(
                              controller: _bathroomsController,
                              icon: Icons.bathtub,
                              hint: "0",
                              preffix: "Bathrooms:",
                              isnumber: true,
                              suffix: "",
                              validator: (value) {
                                if (value == null || value.isEmpty || int.tryParse(value) == null) {
                                  return 'Required (Number)';
                                }
                                return null;
                              },
                            )
                        ),
                      ]
                  ),

                  const SizedBox(height: 15),

                  // حقل المساحة
                  BedroomTextFieldInline(
                    controller: _areaController,
                    icon: Icons.square_foot,
                    hint: "0",
                    preffix: "Property Area:",
                    isnumber: true,
                    suffix: "(sqft)" ,
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Area is required.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // 🌟 3. قسم السعر
                  Padding(
                    padding: EdgeInsets.only(left: titlePadding, bottom: 10),
                    child: Text(
                      "Price",
                      style: TextStyle(color: colorScheme.primary,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  BedroomTextFieldInline(
                    controller: _priceController,
                    icon: Icons.money,
                    hint: "0",
                    preffix: "Price:",
                    isnumber: true,
                    suffix:"\$" ,
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Price is required.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  // 🌟 4. قسم نوع العقار
                  Padding(
                    padding: EdgeInsets.only(left: titlePadding, bottom: 5),
                    child: Text(
                      "Property Type",
                      style: TextStyle(color: colorScheme.primary,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  PropertyTypeSelector(
                      onTypeSelected: (selectedType) {
                        _selectedPropertyType = selectedType;
                      }
                  ),

                  const SizedBox(height:20),

                  // 🌟 5. عنوان تفاصيل الموقع
                  Padding(
                    padding: EdgeInsets.only(left: titlePadding, bottom: 15),
                    child: Text(
                      "Location Details",
                      style: TextStyle(color: colorScheme.primary,fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // حقول الموقع
                  Column(
                      children: [
                        BedroomTextFieldInline(
                          controller: _cityController,
                          icon: Icons.location_city,
                          hint: "Syria",
                          preffix: "City:",
                          isnumber: false,
                          suffix: "",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'City name is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15,),
                        BedroomTextFieldInline(
                          controller: _governorateController,
                          icon: Icons.public,
                          hint: "Damascus",
                          preffix: "Governorate:",
                          isnumber: false,
                          suffix: "",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Governorate is required.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        BedroomTextFieldInline(
                          controller: _addressController,
                          icon: Icons.pin_drop,
                          hint: "Alhamak,bostan Aldoor",
                          preffix: "Address:",
                          isnumber: false,
                          suffix:"" ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Address is required.';
                            }
                            return null;
                          },
                        ),
                      ]
                  ),

                  const SizedBox(height: 20),

                  // 🌟 6. عنوان الوصف
                  Padding(
                    padding: EdgeInsets.only(left: titlePadding, bottom: 10),
                    child: Text(
                      "Description",
                      style: TextStyle(color: colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // حقل الوصف (متعدد الأسطر)
                  BedroomTextFieldInline(
                    controller: _descriptionController,
                    hint: 'Describe your property details...',
                    icon: Icons.description,
                    preffix: 'Description:',
                    isnumber: false, // يسمح بالأسطر المتعددة
                    suffix: '',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description is required.';
                      }
                      return null;
                    },
                  ),

                  // --------------------------------------------------------
                  // 🌟🌟🌟 زر الحفظ (Save Button) 🌟🌟🌟
                  // --------------------------------------------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                    child: ElevatedButton(
                      onPressed: _submitProperty,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary, // لون الزر
                        minimumSize: const Size(double.infinity, 55), // عرض كامل
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Save Property', // يمكنك استخدام tr.save_property هنا
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary, // لون النص داخل الزر
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
// -------------------------------------------------------------------
// 2. كلاس PropertyImageCarousel
// -------------------------------------------------------------------
class PropertyImageCarousel extends StatefulWidget {
  final List<XFile> images;
  final Function(XFile?) onImageAdded;
  final Function(int index)? onImageRemoved;
  final bool showError;

  const PropertyImageCarousel({
    super.key,
    required this.images,
    required this.onImageAdded,
    this.onImageRemoved,
    this.showError = false,
  });

  @override
  State<PropertyImageCarousel> createState() => _PropertyImageCarouselState();
}

class _PropertyImageCarouselState extends State<PropertyImageCarousel> {

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    widget.onImageAdded(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DottedBox(
      isError: widget.showError,
      child: Container(
        height: 250,
        child: Stack(
          children: <Widget>[
            // 1. عرض الصور (PageView.builder)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: widget.images.isEmpty
                    ? Center(
                  child: Text(
                    'Click to upload a photo of your property',
                    style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 16
                    ),
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

                        // زر الحذف (دائرة حمراء بها X)
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
                                  border: Border.all(color: Colors.white, width: 1.5)
                              ),
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

            // 2. زر "إضافة صور"
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


// -------------------------------------------------------------------
// 3. الكلاس المساعد: DottedBox (يحافظ على اللون الصلب للحدود)
// -------------------------------------------------------------------

class DottedBox extends StatelessWidget {
  final Widget child;
  final bool isError;
  const DottedBox({required this.child, this.isError = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color borderColor = isError ? Colors.red : Theme.of(context).colorScheme.primary;

    const BoxDecoration borderDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2.0)),
    );

    return Container(
      width: double.infinity,
      child: CustomPaint(
        painter: _PrimaryBorderPainter(
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

// -------------------------------------------------------------------
// 4. الكلاس المساعد: _PrimaryBorderPainter (الرسام الذي يتعامل مع اللون الصلب)
// -------------------------------------------------------------------

class _PrimaryBorderPainter extends CustomPainter {
  final BoxDecoration decoration;
  final Color? borderColor;
  final bool isError;

  _PrimaryBorderPainter({required this.decoration, this.borderColor, required this.isError});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint borderPaint = Paint();

    if (isError) {
      borderPaint.color = Colors.red;
    } else if (borderColor != null) {
      borderPaint.color = borderColor!;
    } else {
      return;
    }

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = decoration.border!.top.width;

    final RRect rrect = RRect.fromRectAndRadius(rect, decoration.borderRadius!.resolve(TextDirection.ltr).topRight);
    canvas.drawRRect(rrect.deflate(borderPaint.strokeWidth / 2), borderPaint);
  }

  @override
  bool shouldRepaint(covariant _PrimaryBorderPainter oldDelegate) {
    return oldDelegate.isError != isError || oldDelegate.borderColor != borderColor;
  }
}

// -------------------------------------------------------------------
// 5. الكلاس المساعد: _GradientFab (زر الإضافة الدائري بالتدرج)
// -------------------------------------------------------------------

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
          gradient: AppColors.realGoldGradient, // ⚠️ يتطلب استيراد AppColors!
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Icon(Icons.add_a_photo, color: colorScheme.surface, size: 20),
      ),
    );
  }
}

class BedroomTextFieldInline extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String hint;
  final IconData icon;
  final String preffix;
  final String suffix;
  final bool isnumber;

  const BedroomTextFieldInline({
    super.key,
    this.controller,
    this.validator,
    required this.hint,
    required this.icon,
    required this.isnumber,
    required this.preffix,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double horizontalPadding = 17.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator, // 🌟 تفعيل الـ validator
        keyboardType: isnumber ? TextInputType.number : TextInputType.text,

        maxLines: isnumber ? 1 : null,
        minLines: isnumber ? null : 1,

        decoration: InputDecoration(
          // 1. Prefix (الأيقونة والنص)
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

          // 2. Suffix (الوحدة)
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

          // الحدود العادية (تظهر عند عدم التركيز)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5), width: 1.0),
          ),
          // حدود حالة التركيز
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
          ),
          // 🌟 حدود حالة الخطأ (تظهر باللون الأحمر عند فشل الـ validation)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          // 🌟 حدود حالة التركيز مع الخطأ
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
        ),
      ),
    );
  }
}
class TypeSelectorButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TypeSelectorButton({
    super.key,
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

// -------------------------------------------------------------------
// 9. كلاس PropertyTypeSelector
// -------------------------------------------------------------------

class PropertyTypeSelector extends StatefulWidget {
  final Function(String type)? onTypeSelected;

  const PropertyTypeSelector({super.key, this.onTypeSelected});

  @override
  State<PropertyTypeSelector> createState() => _PropertyTypeSelectorState();
}

class _PropertyTypeSelectorState extends State<PropertyTypeSelector> {

  final List<String> propertyTypes = [
    'Apartment',
    'Villa',
    'House',
    'Farm',
    'Country House',
  ];

  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = propertyTypes.first;
  }

  void _handleSelection(String type) {
    setState(() {
      _selectedType = type;
    });
    if (widget.onTypeSelected != null) {
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
          return TypeSelectorButton(
            text: type,
            isSelected: _selectedType == type,
            onTap: () => _handleSelection(type),
          );
        }).toList(),
      ),
    );
  }
}