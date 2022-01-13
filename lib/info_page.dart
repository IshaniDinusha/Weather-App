import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:my_weather_forecasting_app/info_page.dart';
import 'dataset.dart';
import 'another_weather.dart';

class InfoPage extends StatelessWidget {
  final Weather tomorrowTemp;
  final List<Weather> sevenDay;
  InfoPage(this.tomorrowTemp, this.sevenDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(children: [TommorrowWeather(tomorrowTemp), SevenDays(sevenDay)],
      ),
    );
  }
}
class TommorrowWeather extends StatelessWidget {
  final Weather tomorrowTemp;
  TommorrowWeather(this.tomorrowTemp);

  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      color: Colors.black26,
      glowColor:Colors.black12,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(60),
      ),
      child: Column(children: [
        Padding(padding: EdgeInsets.only(top: 50,right: 30, left: 30, bottom: 20,
        ),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back,
                color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                    color: Colors.white,
                  ),
                  Text("Seven Days",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(Icons.more_vert, color: Colors.white,),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/2.3,
                height: MediaQuery.of(context).size.height/2.3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(tomorrowTemp.image!)),),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Tomorrow",
                    style: TextStyle(fontSize: 30,height: 0.1),
                  ),
                  Container(
                    height: 90,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GlowText(
                          tomorrowTemp.max.toString(),
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                        Text("/"+tomorrowTemp.min.toString()+"\u00B0",
                        style: TextStyle(color: Colors.black.withOpacity(0.3),
                        fontSize: 40,
                          fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    
                  ),
                  Text(
                    ""+ tomorrowTemp.name!,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(
          bottom: 20, right: 40, left: 40,
        ),
          child: Column(
            children: [
              Divider(color: Colors.white),
              SizedBox(height: 10,),
              AnotherWeather(tomorrowTemp)
            ],
          ),
        ),
        
      ],),
    );
  }
}

class SevenDays extends StatelessWidget {
List<Weather> sevenDay;
SevenDays(this.sevenDay);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: ListView.builder(
    itemCount: sevenDay!.length,
        itemBuilder:(BuildContext context, int index){
      return Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20,),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(sevenDay[index].day!,
          style: TextStyle(fontSize: 15),
          ),
            Container(
              width: 135,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(image:AssetImage(sevenDay[index].image!),
                    width: 35,
                  ),
                  SizedBox(
                    width: 15),
                  Text(sevenDay[index].name!,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "+"+ sevenDay[index].max.toString() +"\u00B0",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 5),
                Text(
                  "+"+ sevenDay[index].min.toString() +"\u00B0",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      );

        }),
        );
  }
}
