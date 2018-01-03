<template>
    <section id="sprint-planning-page">
        <h2 class="h4 text-muted" v-if="course">{{ course.title}} </h2>
        <h1>
            Sprint planning
            <small class="text-muted">{{ project.title}}</small>
        </h1>

        <template v-if="nextSprint">
            <p>
                Planning sprint: {{ nextSprint.name }} <br>
                Start: {{ nextSprint.start_date }} <br>
                End: {{ nextSprint.end_date }}
            </p>

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>&nbsp;</th>
                        <th>Identifier</th>
                        <th>Story</th>
                        <th>Story&nbsp;points</th>
                        <th>Operations</th>
                    </tr>
                </thead>
                <tbody v-sortable="{handle: '.js-drag-drop', onEnd: saveOrder}">
                    <tr 
                        is="StoryItem" 
                        v-for="story in storiesInSprint" 
                        :key="story.id" 
                        :data="story" 
                        view="planning-sprint" 
                        @removeFromSprint="removeFromSprint(story.id)"/>
                </tbody>
            </table>
        </template>

        <p v-else>No sprint to plan!</p>

        <h2>Backlog</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Identifier</th>
                    <th>Story</th>
                    <th>Story&nbsp;points</th>
                    <th>Operations</th>
                </tr>
            </thead>
            <tbody >
                <tr 
                    is="StoryItem" 
                    v-for="story in backlog" 
                    :key="story.id" 
                    :data="story" 
                    view="planning-backlog" 
                    @addToSprint="addToSprint(story.id)"/>
            </tbody>
        </table>

        <StoryForm 
            v-if="showForm" 
            v-model="newStory" 
            @cancel="showForm = false" 
            @submit="save"/>

        <BButton 
            v-else 
            type="button" 
            variant="primary" 
            @click="showForm = true">Add story</BButton>
    </section>
</template>

<script>
import * as _ from 'lodash';
import moment from 'moment';
import BButton from '@bootstrap/button/button';
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import SprintItem from '@/components/elements/SprintItem';

export default {
    components: { SprintItem, StoryForm, StoryItem, BButton },
    extends: BaseProjectAwarePage,
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
        };
    },
    computed: {
        /**
         * All stories not in sprint, sorted by position
         * @returns {array}
         */
        backlog() {
            return this.project
                ? this.$store.getters['stories/all'](this.project.id)
                    .filter(s => !s.sprint_id)
                    .sort((a, b) => a.position - b.position)
                : [];
        },

        /**
         * Next sprint depending on current date
         * @returns {object}
         */
        nextSprint() {
            const currentDate = moment().format('YYYY-MM-DD');

            return this.course
                ? _.first(
                    this.$store.getters['sprints/all'](this.course.id)
                        .filter(s => s.end_date >= currentDate)
                        .sort((a, b) => a.start_date.localeCompare(b.start_date)))
                : null;
        },

        /**
         * Stories in next sprint
         * @returns {array}
         */
        storiesInSprint() {                        
            return this.nextSprint
                ? this.$store.getters['stories/find'](this.project.id, 'sprint_id', this.nextSprint.id)
                    .sort((a, b) => a.position - b.position)
                : [];
        },
    },
    methods: {
        /**
         * Save current form state as new story
         */
        async save() {
            await this.$store.dispatch('stories/create', {
                parentId: this.project.id,
                ...this.newStory
            });

            this.newStory = this.$store.getters['stories/template']();

            // TODO handle errors in UI
        },

        /**
         * Save new position of dragged story
         * @param {Event} evt
         */
        async saveOrder(evt) {
            const story = this.stories[evt.oldIndex];

            if (!story) {
                return;
            }

            await this.$store.dispatch('stories/update', {
                id: story.id,
                parentId: this.project.id,
                position: evt.newIndex + 1, // act_as_list is 1-indexed
            });

            await this.$store.dispatch('projects/fetch', {
                id: this.project.id,
                parentId: this.course.id
            });

            // TODO handle errors in UI
        },

        /**
         * Add story to next sprint
         * @param {int} storyId
         */
        async addToSprint(storyId) {
            if (!this.nextSprint) {
                return;
            }

            await this.$store.dispatch('stories/update', {
                id: storyId,
                parentId: this.project.id,
                sprint_id: this.nextSprint.id,
            });

            // TODO handle errors in UI
        },

        /**
         * Remove story from next sprint
         * @param {int} storyId
         */
        async removeFromSprint(storyId) {
            await this.$store.dispatch('stories/update', {
                id: storyId,
                parentId: this.project.id,
                sprint_id: null,
            });

            // TODO handle errors in UI

        },
    },
};
</script>
