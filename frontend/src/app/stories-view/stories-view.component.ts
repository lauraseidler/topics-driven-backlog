import {Component, OnInit} from '@angular/core';
import {StoryService} from "../services/story.service";
import {FormBuilder, FormGroup, Validators} from "@angular/forms";

@Component({
  selector: 'app-stories-view',
  templateUrl: './stories-view.component.html',
  styleUrls: ['./stories-view.component.css']
})
export class StoriesViewComponent implements OnInit {
  storyForm: FormGroup;

  constructor(public storyService: StoryService, private formBuilder: FormBuilder) {
  }

  ngOnInit() {
    this.storyService.init();
    this.storyForm = this.formBuilder.group({
      title: ['', Validators.required],
      description: ['']
    });
  }

  createStory() {
    this.storyService.save(this.storyForm.value);
    this.storyForm.reset();
  }
}
