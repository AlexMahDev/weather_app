import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weatherapp/WeatherRepo.dart';

class WeatherEvent extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class FetchWeather extends WeatherEvent{

}

class ResetWeather extends WeatherEvent{

}

class WeatherState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];

}


class SecondScreen extends WeatherState{

}

class WeatherIsLoading extends WeatherState{

}

class WeatherIsLoaded extends WeatherState{
  final _weather;

  WeatherIsLoaded(this._weather);

  //WeatherModel get getWeather => _weather;

  @override
  // TODO: implement props
  List<Object> get props => [_weather];
}

class WeatherIsNotLoaded extends WeatherState{

}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState>{

  WeatherRepo weatherRepo;

  WeatherBloc(this.weatherRepo);

  @override
  // TODO: implement initialState
  WeatherState get initialState => WeatherIsLoading();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchWeather){
      //yield WeatherIsLoading();

      try{
        final weather = await weatherRepo.getWeather();
        yield WeatherIsLoaded(weather);
      }catch(_){
        print(_);
        yield WeatherIsNotLoaded();
      }
    }else if(event is ResetWeather){
      yield SecondScreen();
    }
  }

}