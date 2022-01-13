import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:my_weather_forecasting_app/info_page.dart';
import 'dataset.dart';
import 'another_weather.dart';
import 'package:intl/intl.dart';


late Weather currentTemp;
late Weather tomorrowTemp;
late List<Weather> todayWeather;
late List<Weather> sevenDay;

 String lat = "53.9006";
 String lon = "27.5590";
 String city ="Belarus";

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  getData() async{
 fetchData(lat, lon, city).then((value) {
   currentTemp = value[0];
   todayWeather = value[1];
   tomorrowTemp = value[2];
   sevenDay = value[3];

   setState(() {

   });
 });


  }

  @override
  void initState(){
  super.initState();
  getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: currentTemp==null ? Center(
        child: CircularProgressIndicator(),
      ):Column(
        children: [
          CurrentWeather(getData), TodayWeather()],
      ),
    );
  }
}


class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  CurrentWeather(this.updateData);

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(searchBar){
          setState(() {
            searchBar = false;
          });
        }
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height-200,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.only(top: 50, left: 30, right: 30),
        glowColor: Colors.blueGrey.withOpacity(0.4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight:  Radius.circular(50),
        ),
        color: Colors.blueGrey,
        spreadRadius: 5,
        child: Column(

          children: <Widget>[
            Container(
              child: searchBar?
              TextField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.black12,
                  filled: true,
                  hintText: "Enter city name"
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) async{
                  City? temp = await fetchCity(value);
                  if(temp == null){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: Colors.grey,
                        title: Text("City not found"),
                        content: Text("Please check the city name"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          },
                              child: Text("Okay"))
                        ],
                      );
                    });
                    searchBar = false;
                    return;
                  }
                  city = temp.name!;
                  lat = temp.lat!;
                  lon = temp.lon!;
                  updating = true;
                  setState(() {
                  });
                  widget.updateData();
                  searchBar = false;
                  updating = false;
                  setState(() {
                  });
                },
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    CupertinoIcons.square_grid_2x2,
                    color: Colors.white,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(CupertinoIcons.map_fill,
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: (){
                          searchBar = true;
                          setState(() {

                          });
                          focusNode.requestFocus();
                        },
                        child: Text(

                          ""+city,
                          style:TextStyle(
                          fontWeight: FontWeight.bold,
                              fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 10,
              ),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.2,
                    color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                updating?"Updating": "Updated",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 5,
            ),
            Container(
              height: 220,
              child: Stack(
                children: <Widget>[
                  Image(image: AssetImage(currentTemp.image!),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          GlowText(
                            currentTemp.current.toString()+"\u00B0",
                            style: TextStyle(
                              height: 0.2,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                              currentTemp.name!,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            currentTemp.day!,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white,),
            SizedBox(height: 5),
            AnotherWeather(currentTemp),
            SizedBox(height: 50),

          ],
        ),
      ),
    );
  }
}

class TodayWeather extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 25,
          right: 25,
          top: 10,
      ),
      child: Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Today",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
           GestureDetector(
             onTap: (){
               Navigator.push(context,
                   MaterialPageRoute(builder:(BuildContext context){
                      return InfoPage(tomorrowTemp, sevenDay);
                   }));
             },
             child: Row(
             children: <Widget>[
               Text(
                 "Seven days ",
                 style: TextStyle(
                   fontSize: 17,
                   color: Colors.white,
                 ),
               ),
               Icon(
                 Icons.arrow_forward,
                 color: Colors.white,
                 size: 15,
               ),
             ],
           ),
           ),
          ],
        ),

        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 30,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             WeatherWidget(todayWeather[0]),
             WeatherWidget(todayWeather[1]),
             WeatherWidget(todayWeather[2]),
             WeatherWidget(todayWeather[3]),
           ],
          ),
        ),
      ],
      ),
    );
  }
}
class WeatherWidget extends StatelessWidget {
 final  Weather weather;
 WeatherWidget(this.weather);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
            width: 0.3,
            color: Colors.white,

        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: <Widget>[
          Text(
            weather.current.toString() +"\u00B0",
            style: TextStyle(
              fontSize: 20),
          ),
          SizedBox(
            height: 5),
          Image(
            image: AssetImage(weather.image!),
            width: 50,
            height: 50,
          ),
          SizedBox(
            height: 5,
          ),
          Text(weather.time!,
          style: TextStyle(
              fontSize: 15,
              color: Colors.grey
          ),
          ),
        ],

      ),
    );
  }
}
