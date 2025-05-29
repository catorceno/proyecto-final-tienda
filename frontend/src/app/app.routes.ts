import { Routes } from '@angular/router';
import { MenuComponent } from './menu/menu.component';
import { LandingComponent } from './landing/landing.component';
import { IndiceProductosComponent } from './indice-productos/indice-productos.component';
import { CrearClienteComponent } from './crear-cliente/crear-cliente.component';

export const routes: Routes = [
    { path: '', component: LandingComponent },
    { path: 'productos', component: IndiceProductosComponent },
    { path: 'productos/crear', component: CrearClienteComponent},
];
