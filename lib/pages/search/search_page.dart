import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/pages/search/widgets/movie_search.dart';
import 'package:movie_app/services/api_services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

const List<String> list = <String>['Select', 'Action', 'Comedy', 'Drama', 'Horror'];
List<Map<String, dynamic>> lista = [
  {'id': 00, 'nome': 'Select'},
  {'id': 28, 'nome': 'Action'},
  {'id': 35, 'nome': 'Comedy'},
  {'id': 18, 'nome': 'Drama'},
  {'id': 27, 'nome': 'Horror'}
];
String genero = "Action";

class _SearchPageState extends State<SearchPage> {
  ApiServices apiServices = ApiServices();
  TextEditingController searchController = TextEditingController();
  late Future<Result> result;

  void search(int ?id) {
    setState(() {
      if (id == 00) {
        setState(() {
          result = apiServices.getPopularMovies();
        });
      } else {
        setState(() {
          result = apiServices.getMoviesWithGenre(id);
        });
      }
    });
  }

  @override
  void initState() {
    result = apiServices.getPopularMovies();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  String dpValue = lista.first['nome'];
  int ?selectedId;
  @override
  Widget build(BuildContext context) {
    final searchTitle = searchController.text.isEmpty
        ? 'Top Searchs'
        : 'Search Result for ${searchController.text}';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DropdownButton<String>(
                    value: dpValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dpValue = value!;
                        for (var item in lista) {
                          if (item['nome'] == dpValue) {
                            selectedId = item['id']; 
                            print('ID selecionado: $selectedId');
                            break;
                          }
                        }
                        search(selectedId);
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              FutureBuilder<Result>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data?.movies;
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            searchTitle,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data!.length,
                            itemBuilder: (context, index) {
                              if (data[index].backdropPath.isEmpty) {
                                return const SizedBox();
                              }
                              return MovieSearch(movie: data[index]);
                            },
                          )
                        ]);
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
