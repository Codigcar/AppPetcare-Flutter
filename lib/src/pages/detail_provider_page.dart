import 'package:flutter/material.dart';
import 'package:petcare/src/models/product_model.dart';
import 'package:petcare/src/models/product_type_model.dart';
import 'package:petcare/src/models/provider_model.dart';
import 'package:petcare/src/pages/register_cita_page.dart';
import 'package:petcare/src/services/product_service.dart';
import 'package:petcare/src/services/product_type_service.dart';
import 'package:petcare/src/services/provider_join_product_type_service.dart';
import 'package:petcare/src/services/provider_service.dart';

class DetailProviderPage extends StatefulWidget {
  @override
  _DetailProviderPageState createState() => _DetailProviderPageState();
}

class _DetailProviderPageState extends State<DetailProviderPage> {
  final getProvider = new ProviderModel();
  final titleStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(46, 177, 185, 1.0));
  final subtitleStyle = TextStyle(fontSize: 18.0, color: Colors.grey);
  final colorPetCare = Color.fromRGBO(46, 177, 185, 1.0);
  final productTypeService = new ProductTypeService();
  List<ProductTypeModel> productsType = new List<ProductTypeModel>();
  final providerService = ProviderService();
  final providerJoinProductTypeService = new ProviderJoinProductTypeService();
  final productService = new ProductService();

  
  String _selectedOption = 'Servicios Generales';
  int _selectedProductType = 1 ;


  /* @override
  void initState() {
    super.initState();
    
    
    
    /* if(personProfileModel.photo == null){
      print("está null personProfileModel.phtoo");
    } */
    /* this.userId = _storage.userId; */
  }
 */
  @override
  Widget build(BuildContext context) {
    final ProviderModel getProvider = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _image(getProvider),
            _titleAndSubtitleAndStar(getProvider),
            _actions(),
            _descriptionText(),
            _dropDown(getProvider),
            _createListing(getProvider,_selectedProductType)
          ],
        ),
      ),
    );
  }

  Widget _image(ProviderModel provider) {
    return Container(
      width: double.infinity,
      child: Image(
           image: NetworkImage(/* provider.photo */ 'assets/no-image.png'), width: double.infinity,
           fit: BoxFit.cover,
           height: 200.0,
      ),
    );
    
  }

  Widget _titleAndSubtitleAndStar(ProviderModel provider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Row(
        children: <Widget>[
          _titleAndSubtitle(provider),
          Icon( Icons.star, color: Color.fromRGBO(46, 177, 185, 1.0), size: 30.0,),
          Text('7', style: TextStyle(fontSize: 20.0),)
        ],
      ),
    );
  }

  Widget  _titleAndSubtitle(ProviderModel provider){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(provider.businessName, style: titleStyle),
          SizedBox( height: 7.0 ),
          Text(provider.address, style: subtitleStyle),
        ],
      ),
    );
  }

  Widget _actions(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
      children: <Widget>[
        _action( Icons.call , 'Llamar'),
        _action( Icons.near_me , 'Ruta'),
        _action( Icons.share , 'Compartir'),
      ],
    );
  }

  Widget _action( IconData icon, String name ){
    return Column(
      children: <Widget>[
        Icon( icon, color: Color.fromRGBO(46, 177, 185, 1.0), size: 40.0,),
        SizedBox(height: 5.0),
        Text( name, style: TextStyle(fontSize: 15.0, color: Color.fromRGBO(46, 177, 185, 1.0)), ),
        
      ],
    );
  }

  Widget _descriptionText(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Text('Sunt adipisicing pariatur in ad qui qui proident aliquip ad eiusmod exercitation minim voluptate aute. Sunt aliquip quis fugiat id dolore dolor culpa exercitation nulla ut. Nostrud velit dolor dolore ullamco nulla dolor exercitation duis ullamco sit officia mollit est. Eiusmod do do ut veniam proident ad. Incididunt exercitation sit in est duis. Excepteur duis sint mollit eu incididunt.',
      textAlign: TextAlign.justify,),
      
      );
  }

  List<DropdownMenuItem<String>> getOptionsDropdown(List<ProductTypeModel> listproductsType) {
    List<DropdownMenuItem<String>> list = new List();
    listproductsType.forEach((element) {
      list.add(DropdownMenuItem(child: Text(element.name), value: element.name ,));
    });
    return list;
  }

  Widget _dropDown(ProviderModel provider){
    return FutureBuilder(
      future: providerJoinProductTypeService.getProductTypeByProviderId(provider.id),
      builder: (BuildContext context, AsyncSnapshot<List<ProductTypeModel>> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else {
          productsType = snapshot.data;
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 35.0,vertical: 0.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.select_all),
                DropdownButton(
                  value: _selectedOption,
                  items: getOptionsDropdown( productsType),
                  onChanged: (value) {
                    setState(() {
                      _selectedOption = value;
                      for (var i = 0; i < snapshot.data.length; i++) {
                        if(snapshot.data[i].name == _selectedOption){
                          print( snapshot.data[i].id);
                          _selectedProductType= snapshot.data[i].id;
                        }
                      }
                    
                    });
                  },)
              ],
            ),
          );
        }
      },
    );
  }

  Widget _item( BuildContext context,ProductModel product, ProviderModel provider){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: 180,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                      image: NetworkImage(/* product.photo */ 'assets/no-image.png'),
                      fit: BoxFit.cover,
                    ),
                    ),
                ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10.0,bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)
                ),
                color: colorPetCare,
              ),
              child: Column(
                children: <Widget>[/* 
                  Text(product.businessName),
                  Text(product.description), */
                  Expanded(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(product.description),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      child: Container(
                        child: Text('Solicitar Cita'),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                      textColor: Colors.white,
                      color: Colors.red,
                      onPressed: () {
                       /*  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCitaPage())); */
                        Navigator.pushNamed(context, 'register_cita' , arguments: [provider,product]);
                      },),
                  )
                ],
              ),
              
          ))
        ],
      ),
    );
  }

  Widget _createListing(ProviderModel provider, int _selectedProductType) {
    return FutureBuilder(
        future: productService.getAllProductsByProviderIdAndProductTypeId(provider.id, _selectedProductType),
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) =>
                    _item(context, products[index], provider));
          } else {
            return Center(child: CircularProgressIndicator());
          }
          
        });
  }
}