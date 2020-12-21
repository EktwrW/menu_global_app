import 'package:flutter/material.dart';
import 'package:menu_global_app/src/bloc/productos_bloc.dart';
import 'package:menu_global_app/src/bloc/provider.dart';
import 'package:menu_global_app/src/models/producto_model.dart';
import 'package:slimy_card/slimy_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      backgroundColor: Color.fromRGBO(65, 68, 75, 1.0),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) =>
                _crearItem(context, productosBloc, productos[i]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) => productosBloc.borrarProducto(producto.id),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SlimyCard(
              borderRadius: 30,
              width: 380,
              topCardHeight: 200,
              color: Color.fromRGBO(82, 87, 93, 1.0),
              topCardWidget: (producto.fotoUrl == null)
                  ? Container(
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.5,
                          bottom: MediaQuery.of(context).size.width * 0.12),
                      height: 100,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Image(
                        image: AssetImage('assets/no-image.png'),
                        isAntiAlias: true,
                        fit: BoxFit.cover,
                      ))
                  : Container(
                      margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.5,
                          bottom: MediaQuery.of(context).size.width * 0.12),
                      height: 100,
                      width: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(6),
                        ),
                        child: FadeInImage(
                          image: NetworkImage(producto.fotoUrl),
                          placeholder: AssetImage('assets/RA3v.gif'),
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              bottomCardWidget: ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                //subtitle: Text(producto.id),
                subtitle: Text('Descripcion del producto'),
                onTap: () => Navigator.pushNamed(context, 'producto',
                        arguments: producto)
                    .then((value) {
                  setState(() {});
                }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'producto').then((value) {
            setState(() {});
          });
        });
  }
}
