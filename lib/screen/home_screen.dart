import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_applicaiton/controller/test_controller.dart';
import 'package:text_applicaiton/model/items_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductController productController = Get.put(ProductController());
  List<ItemsModel> items = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await productController.getAllProducts();
      items = productController.itemsList;
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          if (productController.isDataLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: FloatingActionButton(
                            onPressed: () {
                              _showAddNewItemModal(context);
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if (items[index].completed) {
                      productController.removeProduct(items[index]);
                      setState(() {
                        items.removeAt(index);
                      });
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(items[index].title),
                    value: items[index].completed,
                    onChanged: (bool? value) {
                      productController.updateCompletion(items[index], value!);
                    },
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }

  void _showAddNewItemModal(BuildContext context) {
    TextEditingController _textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Enter...',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_textController.text.isNotEmpty) {
                    ItemsModel newItem = ItemsModel(
                      userId: 0,
                      id: items.length + 1,
                      title: _textController.text,
                      completed: false,
                    );
                    productController.itemsList.add(newItem);
                    Navigator.of(context).pop();
                    _textController.clear();
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }
}
