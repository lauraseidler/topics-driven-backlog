import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';

import {AppComponent} from './app.component';
import {StoriesViewComponent} from './stories-view/stories-view.component';
import {routing} from "./app.routing";
import {StoryService} from "./services/story.service";
import {Http, HttpModule} from "@angular/http";
import {ReactiveFormsModule} from "@angular/forms";

@NgModule({
  declarations: [
    AppComponent,
    StoriesViewComponent
  ],
  imports: [
    BrowserModule,
    HttpModule,
    ReactiveFormsModule,
    routing
  ],
  providers: [
    StoryService
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
}
