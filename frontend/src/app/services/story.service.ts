import {Injectable, NgZone} from '@angular/core';
import {Http, Response} from "@angular/http";

@Injectable()
export class StoryService {

  private initialised: boolean = false;
  stories: object[] = [];

  constructor(private http: Http, private ngZone: NgZone) {}

  init() {
    if (!this.initialised) {
      this.fetch();
      this.initialised = true;
    }
  }

  private set(story) {
    const isPresent = this.stories.filter((s:any) => s.id === story.id).length > 0;

    if (isPresent) {
      this.stories.map((s:any) => s.id === story.id ? story : s);
    } else {
      this.stories.push(story);
    }
  }

  fetch() {
    this.http.get('http://localhost:8080/stories').subscribe((response: Response) => {
      this.ngZone.run(() => {
        this.stories = response.json();
      });
    });
  }

  save(story: any) {
    this.http[story.id ? 'put' : 'post']('http://localhost:8080/stories', story).subscribe((response: Response) => {
      this.set(response.json());
    });
  }
}
