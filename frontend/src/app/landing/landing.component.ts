import { Component, inject } from '@angular/core';
import { WeatherforecastService } from '../weatherforecast.service';

@Component({
  selector: 'app-landing',
  imports: [],
  templateUrl: './landing.component.html',
  styleUrl: './landing.component.css'
})
export class LandingComponent {
  weatherforecastService = inject(WeatherforecastService);
  weathers: any[] = [];

  constructor(){
    this.weatherforecastService.getWeather().subscribe(datos => { //suscribirnos al observable que retorna el httpClient
      this.weathers = datos;
    }); 
  }
}