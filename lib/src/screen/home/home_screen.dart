import 'package:flutter/material.dart';
import 'package:flutter_view_app/src/models/user_model.dart';
import 'package:flutter_view_app/src/providers/user_provider.dart';
import 'package:flutter_view_app/src/screen/home/show_data_screen.dart';
import 'package:flutter_view_app/src/screen/update/update_page.dart';
import 'package:flutter_view_app/src/widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  User? user;
  @override
  void initState() {
    super.initState();
    loading();
  }

  void loading() async {
    Future.delayed(const Duration(seconds: 1), () {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _NavegacionModel(),
      child: isLoading
          ? const LoadingPage()
          : Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: SafeArea(
                  child: Column(
                    children: [
                      AppBar(
                        backgroundColor: Colors.grey[200],
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        title: Consumer<UserProvider>(
                          builder: (context, value, child) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bienvenido',
                                      style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black)),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      value.currentUser?.name ?? '',
                                      style: GoogleFonts.lato(
                                          textStyle: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: value.currentUser!.imageUrl == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                            'assets/img/profile.jpeg'),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              'assets/img/profile.jpeg'),
                                          image: NetworkImage(
                                              value.currentUser!.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.grey[200],
              body: _Paginas(),
              bottomNavigationBar: _Navegacion(),
            ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      onTap: (i) => navegacionModel.paginaActual = i,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: Colors.blue,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
            color: Colors.blue,
          ),
          label: 'Mi cuenta',
        ),
      ],
    );
  }
}

class _Paginas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<_NavegacionModel>(context);
    return PageView(
      controller: navegacionModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ShowDataScreen(),
        UpdatePage(),
      ],
    );
  }
}

class _NavegacionModel with ChangeNotifier {
  int _paginaActual = 0;
  final _pageController = PageController();

  int get paginaActual => _paginaActual;
  set paginaActual(int valor) {
    _paginaActual = valor;
    _pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  //aqui se hace los cambios de valor del _pageController
  PageController get pageController => _pageController;
}
