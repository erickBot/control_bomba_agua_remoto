import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_view_app/src/models/user_model.dart';
import 'package:flutter_view_app/src/providers/user_provider.dart';
import 'package:flutter_view_app/src/services/authentication_service.dart';
import 'package:flutter_view_app/src/services/cloudinary_service.dart';
import 'package:flutter_view_app/src/services/user_service.dart';
import 'package:flutter_view_app/src/widgets/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  final AuthFirebaseProvider _authFirebaseProvider = AuthFirebaseProvider();
  final UserService _userService = UserService();
  final CloudinaryProvider _cloudinaryProvider = CloudinaryProvider();
  ProgressDialog? _progressDialog;

  bool isLoading = true;

  User? user;
  XFile? pickedFile;
  File? imageFile;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _progressDialog = ProgressDialog(context: context);

    getUser();
  }

  void getUser() async {
    user = Provider.of<UserProvider>(context, listen: false).currentUser;
    nameController.text = user?.name ?? '';
    lastnameController.text = user?.lastname ?? '';
    isLoading = false;
    imageUrl = user!.imageUrl;
    setState(() {});
  }

  void update() async {
    try {
      String name = nameController.text;
      String lastname = lastnameController.text;

      _progressDialog?.show(max: 100, msg: 'Espere un momento');

      if (imageFile != null) {
        imageUrl = await _cloudinaryProvider.subirImagen(imageFile!);
      }

      Map<String, dynamic> data = {
        'name': name,
        'lastname': lastname,
        'imageUrl': imageUrl,
      };

      await _userService.update(data, user!.id);

      user = await _userService.getByUserId(user!.id);
      Provider.of<UserProvider>(context, listen: false).setCurrentUser(user);
      //_prefs.save('user', user?.toJson());
      _progressDialog?.close();
      Fluttertoast.showToast(msg: 'Datos actualizados con exito!');
      //
    } catch (e) {
      _progressDialog?.close();
      Fluttertoast.showToast(msg: 'Ocurrio un error al actualizar!');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: isLoading
          ? const LoadingPage()
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Mi cuenta',
                    style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => showAlertDialogPhoto(context),
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                  image: FileImage(imageFile!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : user!.imageUrl == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Image(
                                        image: AssetImage(
                                            'assets/img/profile.jpeg')),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      placeholder: const AssetImage(
                                          'assets/img/profile.jpeg'),
                                      image: NetworkImage(user!.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _name(),
                _lastname(),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: update,
                    child: const Text('ACTUALIZAR'),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        _authFirebaseProvider.signOut();
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'login', (route) => false);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: const [
                            Text('Cerrar sesión '),
                            Icon(Icons.logout_outlined)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _name() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Nombres',
          hintText: 'Nombres',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon:
              Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
          hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _lastname() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: lastnameController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Apellidos',
          hintText: 'Apellidos',
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor),
          hintStyle: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Future imageSelectedPhoto(
      BuildContext context, ImageSource imageSource) async {
    Navigator.pop(context);
    try {
      pickedFile = await ImagePicker().pickImage(source: imageSource);
      if (pickedFile != null) {
        imageFile = File(pickedFile!.path);
      }

      setState(() {});
      //
    } catch (e) {
      _progressDialog?.close();
      Fluttertoast.showToast(msg: 'Ocurrio un error!');
      return;
    }
  }

  void showAlertDialogPhoto(BuildContext context) {
    Widget galleryButton = ElevatedButton(
      onPressed: () => imageSelectedPhoto(context, ImageSource.gallery),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: const Text('Galeria'),
    );
    Widget cameraButton = ElevatedButton(
      onPressed: () => imageSelectedPhoto(context, ImageSource.camera),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: const Text('Camara'),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
