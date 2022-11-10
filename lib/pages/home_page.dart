import 'dart:convert';
import 'package:codigo2_weatherapp/ui/widgets/item_forecast_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String cityName = "";
  String country = "";
  double temp = 0;

  final TextEditingController _searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    getDataLocation();
  }

  getData(String city) async {
    isLoading = true;
    setState(() {});

    Uri _url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=786b0a4bd84c7581caf0a3ce90598f33");
    http.Response response = await http.get(_url);
    if (response.statusCode == 200) {
      Map myMap = json.decode(response.body);
      temp = myMap["main"]["temp"];
      temp = temp - 273.15;
      cityName = myMap["name"];
      country = myMap["sys"]["country"];
      isLoading = false;
      setState(() {});
    }

    // //Nombre de la ciudad
    // print(myMap["name"]);
    // //Codigo pais
    // print(myMap["sys"]["country"]);
    // //Temp
    // print(myMap["main"]["temp"]);
    // print(myMap["weather"][0]["description"]);
  }

  getDataLocation() async{
    isLoading = true;
    setState(() {

    });
    Position position = await Geolocator.getCurrentPosition();
    print(position.latitude);
    print(position.longitude);
    Uri _url = Uri.parse("https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=786b0a4bd84c7581caf0a3ce90598f33");
    http.Response response = await http.get(_url);
    if(response.statusCode == 200){
      Map myMap = json.decode(response.body);
      temp = myMap["main"]["temp"];
      temp = temp - 273.15;
      cityName = myMap["name"];
      country = myMap["sys"]["country"];
      isLoading = false;
      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff232535),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "WeatherApp",
        ),
        actions: [
          IconButton(
            onPressed: () {
              getDataLocation();
            },
            icon: Icon(
              Icons.location_on,
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/dom.png',
                    height: 56.0,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        temp.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 80.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      const Text(
                        "°C",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$cityName, $country",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  TextFormField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      hintText: "Ingresa una ciudad",
                      hintStyle: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14.0,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton(
                      onPressed: () {
                        String city = _searchController.text;
                        getData(city);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFE6C6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: const Text(
                        "Buscar",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
                        ItemForecastWidget(),
                        ItemForecastWidget(),
                        ItemForecastWidget(),
                        ItemForecastWidget(),
                        ItemForecastWidget(),
                        ItemForecastWidget(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 32.0, horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "14 minutes ago",
                              style: TextStyle(
                                color: Colors.white60,
                              ),
                            ),
                            Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: -80,
                          right: 10,
                          child: Image.asset(
                            'assets/images/nube.png',
                            height: 100.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? Container(
            color: const Color(0xff232535).withOpacity(0.98),
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Color(0xffFE6C6D),
                  strokeWidth: 1.5,
                ),
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
