
import 'package:intl/intl.dart';
import 'another_weather.dart';
import 'home_page.dart';
import 'info_page.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather{
    final int? max;
    final int? min;
    final int? current;
    final String? name;
    final String? day;
    final int? wind;
    final int? humidity;
    final int? chanceRain;
    final String? image;
    final String? time;
    final String? location;

    Weather(
        {
            this.max,
            this.min,
            this.current,
            this.name,
            this.day,
            this.wind,
            this.humidity,
            this.chanceRain,
            this.image,
            this.time,
            this.location,
        });
}


String appId = "13c344de8ad4c1b11ded4dde1b7f860c";

Future<List> fetchData(String lat, String lon, String city) async{
  var url = "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
  var response = await http.get(Uri.parse(url));
  DateTime date = DateTime.now();

  if(response.statusCode==200){
    var res = json.decode(response.body);

    //current Temp
    var current = res["current"];
    Weather currentTemp = Weather(
      current: current["temp"]?.round()??0,
      name: current["weather"][0]["main"].toString(),
      day: DateFormat("EEEE dd MMMM").format(date),
      wind: current["wind_speed"]?.round()??0,
      humidity: current["humidity"]?.round()??0,
      chanceRain: current["uvi"]?.round()??0,
      location: city,
      image: findIcon(current["weather"][0]["main"].toString(),true),
    );

    //today weather

    List<Weather> todayWeather =[];
    int hour = int.parse(DateFormat("hh").format(date));
    for(var i=0; i<4;i++){
      var temp = res["hourly"];
      var hourly = Weather(
          current: temp[i]["temp"]?.round()??0,
         image: findIcon(temp[i]["weather"][0]["main"].toString(), false),
        time: Duration(hours: hour+i+1).toString().toString().split(":")[0]+":00",
      );
      todayWeather.add(hourly);
    }

    //tomorrow weather
    var daily = res["daily"][0];
    Weather tomorrowTemp = Weather(
        min: daily["temp"]["min"]?.round()??0,
        max: daily["temp"]["max"]?.round()??0,
        image: findIcon(daily["weather"][0]["main"].toString(), true),
        name: daily["weather"][0]["main"].toString(),
        wind: daily["wind_speed"]?.round()??0,
        humidity: daily["humidity"]?.round()??0,
        chanceRain: daily["uvi"]?.round()??0,
    );
    //seven day weather
    List<Weather> sevenDay =[];
    for(var i=1;i<8; i++){
      String day = DateFormat("EEEE").format(DateTime(date.year,date.month,date.day+i+1)).substring(0,3);
      var temp = res["daily"][i];
      var hourly = Weather(
        min: temp["temp"]["min"]?.round()??0,
        max: temp["temp"]["max"]?.round()??0,
        image: findIcon(temp["weather"][0]["main"].toString(), false),
        name: temp["weather"][0]["main"].toString(),
        day: day,
      );
      sevenDay.add(hourly);
    }
    return[currentTemp, todayWeather, tomorrowTemp, sevenDay];
  }
  return[null, null, null, null];
}


//find icon
String findIcon(String name, bool type){
  if(type){
    switch(name){
      case "Clouds":
      return "assets/sunny_icon.jpg";
      break;

      case "Rain":
      return "assets/rain_icon.jpg";
      break;

      case "Drizzle":
      return "assets/rain_icon.jpg";
      break;

      case "Thunderstorm":
      return "assets/thundering_icon.jpg";
      break;

      case "Snow":
      return "assets/snow_icon.jpg";
      break;

      default:
        return "assets/sunny_icon.jpg";
    }
  }

  else{
    switch(name){
      case "Clouds":
        return "assets/sunny_icon.jpg";
        break;

      case "Rain":
        return "assets/rain_icon.jpg";
        break;

      case "Drizzle":
        return "assets/rain_icon.jpg";
        break;

      case "Thunderstorm":
        return "assets/thundering_icon.jpg";
        break;

      case "Snow":
        return "assets/snow_icon.jpg";
        break;

      default:
        return "assets/sunny_icon.jpg";
    }
  }
}

class City{
  final String? name;
  final String? lat;
  final String? lon;

  City({this.name, this.lat, this.lon});
}
var cityJson;
  Future<City?> fetchCity(String cityName) async{
    if(cityJson ==null){
      String link ="https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
      var response = await http.get(Uri.parse(link));
      if(response.statusCode ==200){
        cityJson = json.decode(response.body);
      }
    }
    for(var i=0;i<cityJson.length;i++){
      if(cityJson[i]["name"].toString().toLowerCase() == cityName.toLowerCase()){
        return cityJson(
            name:cityJson[i]["name"].toString(),
            lat: cityJson[i]["latitude"].toString(),
            lon: cityJson[i]["longitude"].toString()
        );
      }
    }
    return null;
  }

/*
  List<Weather> todayWeather = [
      Weather(current: 23, image: "assets/rain_icon.jpg", time: "10:00"),
      Weather(current: 21, image: "assets/thundering_icon.jpg", time: "11:00"),
      Weather(current: 22, image: "assets/rain_icon.jpg", time: "12:00"),
      Weather(current: 19, image: "assets/snow_icon.jpg", time: "01:00")
    ];
    Weather currentTemp = Weather(
        current: 21,
        image: "assets/thundering_icon.jpg",
        name: "Thunderstorm",
        day: "Monday, 10 January",
        wind: 13,
        humidity: 24,
        chanceRain: 87,
        location: "Colombo");

    Weather tomorrowTemp = Weather(
      max: 20,
      min: 17,
      image: "assets/sunny_icon.jpg",
      name: "Sunny",
      wind: 9,
      humidity: 31,
      chanceRain: 20,
    );

    List<Weather> sevenDay = [
      Weather(
          max: 20,
          min: 14,
          image: "assets/rain_icon.jpg",
          day: "Mon",
          name: "Rainy"),
      Weather(
          max: 22,
          min: 16,
          image: "assets/thundering_icon.jpg",
          day: "Tue",
          name: "Thunder"),
      Weather(
          max: 19,
          min: 13,
          image: "assets/rain_icon.jpg",
          day: "Wed",
          name: "Rainy"),
      Weather(
          max: 18, min: 12, image: "assets/snow_icon.jpg", day: "Thu", name: "Snow"),
      Weather(
          max: 23,
          min: 19,
          image: "assets/sunny_icon.jpg",
          day: "Fri",
          name: "Sunny"),
      Weather(
          max: 25,
          min: 17,
          image: "assets/rain_icon.jpg",
          day: "Sat",
          name: "Rainy"),
      Weather(
          max: 21,
          min: 18,
          image: "assets/thundering_icon.jpg",
          day: "Sun",
          name: "Thunder")
    ];

 */