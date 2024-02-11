import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class CloudinaryProvider {
  Future<String?> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/erickBot/image/upload?upload_preset=qxomeq1n');

    final mimeType = mime(imagen.path)!.split('/');

    ///image/jpg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url,
    );

    imageUploadRequest.fields['folder'] = 'Proyecto_Olmos';

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final stringResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(stringResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);

    print(respData['secure_url']);

    return respData['secure_url'];
  }
}
