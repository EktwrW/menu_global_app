import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:menu_global_app/src/bloc/login_bloc.dart';
import 'package:menu_global_app/src/bloc/provider.dart';
import 'package:menu_global_app/src/providers/usuario_provider.dart';
import 'package:menu_global_app/src/services/google_signin_service.dart';

import 'package:menu_global_app/src/utils/utils.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 160.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 40.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(246, 244, 230, 1.0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Ingresar', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 50.0),
                _crearEmail(bloc),
                SizedBox(height: 20.0),
                _crearPassword(bloc),
                SizedBox(height: 40.0),
                _crearBoton(bloc),
                SizedBox(height: 30.0),
                _accesoGoogle(bloc)
              ],
            ),
          ),
          FlatButton(
            child: Text('Crear una nueva cuenta'),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'registro'),
          ),
          SizedBox(height: 120.0)
        ],
      ),
    );
  }

  Widget _accesoGoogle(LoginBloc bloc) {
    return MaterialButton(
      elevation: 0,
      splashColor: Colors.transparent,
      height: 30,
      color: Color.fromRGBO(246, 244, 230, 1.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(FontAwesomeIcons.google), Text('  Acceder con Google')],
      ),
      onPressed: () {
        GoogleSignInService.signInWithGoogle();
      },
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(Icons.alternate_email,
                    color: Color.fromRGBO(65, 68, 75, 1.0)),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock_outline,
                    color: Color.fromRGBO(65, 68, 75, 1.0)),
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    // formValidStream
    // snapshot.hasData
    //  true ? algo si true : algo si false

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text(
                'Acceder',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 1.0,
            color: Color.fromRGBO(65, 68, 75, 1.0),
            textColor: Color.fromRGBO(245, 239, 56, 1.0),
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null);
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    Map info = await usuarioProvider.login(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondo = Container(
      height: size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
            Color.fromRGBO(65, 68, 75, 1.0),
            Color.fromRGBO(82, 87, 93, 1.0),
            Color.fromRGBO(246, 244, 230, 1.0),
          ])),
    );

    return SafeArea(
      child: Stack(
        children: <Widget>[
          fondo,
          Container(
            margin: EdgeInsets.only(top: 10),
            child: FadeIn(
                child: Container(
              width: double.infinity,
              height: 120,
              child: Image.asset(
                'assets/menu369.png',
                fit: BoxFit.fitHeight,
              ),
            )),
          ),
          Container(
            margin: EdgeInsets.only(top: 70.0),
            padding: EdgeInsets.only(top: 55.0),
            width: double.infinity,
            height: 100,
            child: Image.asset(
              'assets/wine-menu.png',
            ),
          ),
        ],
      ),
    );
  }
}
