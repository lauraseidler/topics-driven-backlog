<template>
    <section id="sprint-planning-page">
        <h1>Sprint planning</h1>

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
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import SprintItem from '@/components/elements/SprintItem';

export default {
    components: { SprintItem, StoryForm, StoryItem, BButton },
    data() {
        return {
            showForm: false,
            newStory: {},
        };
    },
    computed: {
        /**
         * All stories not in sprint, sorted by position
         * @returns {array}
         */
        backlog() {
            return this.$store.getters['stories/all']
                .filter(s => s.sprint_id === null)
                .sort((a, b) => a.position - b.position);
        },

        /**
         * Next sprint depending on current date
         * @returns {object}
         */
        nextSprint() {
            const currentDate = moment().format('YYYY-MM-DD');

            return _.first(
                this.$store.getters['courses/allSprints']()
                    .filter(s => s.end_date >= currentDate)
                    .sort((a, b) => a.start_date.localeCompare(b.start_date))
            );
        },

        /**
         * Stories in next sprint
         * @returns {array}
         */
        storiesInSprint() {
            if (this.nextSprint) {
                return this.$store.getters['stories/find']('sprint_id', this.nextSprint.id)
                    .sort((a, b) => a.position - b.position);
            } else {
                return [];
            }
        },
    },
    methods: {
        /**
         * Save current form state as new story
         */
        save() {
            this.$store
                .dispatch('stories/save', {
                    story: this.newStory,
                })
                .then(() => {
                    this.newStory = {};
                });
        },

        /**
         * Save new position of dragged story
         * @param {Event} evt
         */
        saveOrder(evt) {
            const story = this.storiesInSprint[evt.oldIndex];

            if (!story) {
                return;
            }

            this.$store.dispatch('stories/patch', {
                id: story.id,
                field: 'position',
                value: evt.newIndex + 1, // act_as_list is 1-indexed
                fetch: true,
            });
        },

        /**
         * Add story to next sprint
         * @param {int} storyId
         */
        addToSprint(storyId) {
            if (!this.nextSprint) {
                return;
            }

            this.$store.dispatch('stories/patch', {
                id: storyId,
                field: 'sprint_id',
                value: this.nextSprint.id,
            });
        },

        /**
         * Remove story from next sprint
         * @param {int} storyId
         */
        removeFromSprint(storyId) {
            this.$store.dispatch('stories/patch', {
                id: storyId,
                field: 'sprint_id',
                value: null,
            });
        },
    },
};
</script>
