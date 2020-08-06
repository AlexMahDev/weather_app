class WeatherModel {
  String weatherModel(String time, String condition, String addCondition) {
    if (time == "18:00" || time == "21:00" || time == "00:00" || time == "03:00" || time == "06:00") {
      if (condition == "Clear")
        return "clearnight.png";
      else if (condition == "Clouds") {
        if (addCondition == "few clouds")
          return "fewcloudsnight.png";
        else if (addCondition == "scattered clouds")
          return "scatteredclouds.png";
        else return "clouds.png";
      }
      else if (condition == "Rain")
        return "rainnight.png";
      else if (condition == "Drizzle")
        return "drizzle.png";
      else if (condition == "Thunderstorm")
        return "thunderstorm.png";
      else if (condition == "Snow")
        return "snow.png";
      else return "atmosphere.png";
    }
    else if (condition == "Clear")
      return "clearday.png";
    else if (condition == "Clouds") {
      if (addCondition == "few clouds")
        return "fewcloudsday.png";
      else if (addCondition == "scattered clouds")
        return "scatteredclouds.png";
      else return "clouds.png";
    }
    else if (condition == "Rain")
      return "rainday.png";
    else if (condition == "Drizzle")
      return "drizzle.png";
    else if (condition == "Thunderstorm")
      return "thunderstorm.png";
    else if (condition == "Snow")
      return "snow.png";
    else return "atmosphere.png";
  }
}