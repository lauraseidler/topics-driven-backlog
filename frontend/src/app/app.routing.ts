import {RouterModule, Routes} from "@angular/router";
import {StoriesViewComponent} from "./stories-view/stories-view.component";

const appRoutes: Routes = [
  { path: 'stories', component: StoriesViewComponent},
  { path: '**', redirectTo: 'stories' }
];

export const routing = RouterModule.forRoot(appRoutes);
