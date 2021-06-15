import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/customer_side/productDetailsScreen.dart';
import 'package:spain_project/models/search_bar_item_model.dart';
import 'package:spain_project/providers/product_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/offer_widget.dart';

class SearchProductScreen extends StatefulWidget {
  String proCatId;
  SearchProductScreen(this.proCatId);
  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  bool loading = true;
  setData() async {
    await Provider.of<ProductProvider>(context, listen: false)
        .getAndSetProducts(widget.proCatId);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  Future<List<SearchBarItemModel>> suggestionsCallback(String query) async {
    print("query selected $query");
    List<SearchBarItemModel> items = [];
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}searchProductsByProCat.php',
        form: {"keyword": query, "proCatId": widget.proCatId});

    Logger().i(response);
    for (var item in response['searchedProducts']) {
      items.add(SearchBarItemModel(
        proId: item['proId'].toString(),
        proImg: item['proImg'],
        proPrice: item['proPrice'].toString(),
        proName: item['proName'],
      ));
    }

    final lowerQuery = query.toLowerCase();
    return items
        .where((element) => (element.proName.toLowerCase()).contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(.5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadField<SearchBarItemModel>(
                          debounceDuration: Duration(milliseconds: 500),
                          hideSuggestionsOnKeyboardHide: true,
                          hideOnEmpty: true,
                          textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                  hintText:
                                      "What offer do you want to find?".tr(),
                                  hintStyle: TextStyle(
                                      color: kGreyTextColor,
                                      fontWeight: FontWeight.bold),

                                  // prefix: Icon(Icons.search_outlined,color: kGreyTextColor,),
                                  filled: true,
                                  fillColor: kGreyTextColor.withOpacity(.1),
                                  prefixIcon: Icon(
                                    Icons.search_outlined,
                                    color: kGreyTextColor,
                                    size: 28,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 13))),
                          itemBuilder:
                              (context, SearchBarItemModel suggestoin) {
                            final product = suggestoin;
                            return ListTile(
                              leading: Container(
                                height: 50,
                                width: 50,
                                child: Image.network(
                                  "${Utilities.baseImgUrl}${product.proImg}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                "${product.proName}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                "€${product.proPrice}",
                                style: TextStyle(fontSize: 18),
                              ),
                            );
                          },
                          suggestionsCallback: suggestionsCallback,
                          onSuggestionSelected:
                              (SearchBarItemModel suggestion) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: ProductDetailsScreen(
                                        suggestion.proId)));
                          },
                        ),
                      ),
                      // IconButton(onPressed: (){}, icon: Container(
                      //     height: 20,
                      //     width: 20,
                      //     child: Image.asset('assets/filter.png')))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Provider.of<ProductProvider>(context).productList.length == 0
                      ? Container(
                          child: Center(
                            child:
                                Text("There are no products on this category!"),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: Provider.of<ProductProvider>(context)
                              .productList
                              .length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: .8,
                                  mainAxisSpacing: 5),
                          itemBuilder: (BuildContext context, int index) {
                            Logger().i(Provider.of<ProductProvider>(context)
                                .productList[index]
                                .proId);
                            return OfferProductWidget(
                                Provider.of<ProductProvider>(context)
                                    .productList[index]);
                          },
                        )
                ],
              ),
            ),
    );
  }
}
