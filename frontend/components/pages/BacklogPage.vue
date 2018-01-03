<template>
    <section id="backlog-page">
        <template v-if="currentSprint">
            <h3 class="h5 text-muted mb-0">
                Current sprint
                <small>({{ currentSprint.start_date | displayDate }} - {{ currentSprint.end_date | displayDate }})</small>
            </h3>
            <h2>{{ currentSprint.name }}</h2>

            <table class="table table-striped mb-4">
                <thead>
                <tr>
                    <th>Identifier</th>
                    <th>Story</th>
                    <th>Story&nbsp;points</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                    <tr
                        is="StoryItem"
                        v-for="story in storiesInSprint"
                        :key="story.id"
                        :data="story"
                        view="sprint"/>
                </tbody>
            </table>
        </template>

        <h2>Backlog</h2>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th>Identifier</th>
                    <th>Story</th>
                    <th>Topic</th>
                    <th>Story&nbsp;points</th>
                    <th>Operations</th>
                </tr>
            </thead>
            <tbody v-sortable="{handle: '.js-drag-drop', onEnd: saveOrder}" >
                <tr
                    is="StoryItem"
                    v-for="story in stories"
                    :key="story.id"
                    :data="story"
                    view="backlog"/>
            </tbody>
        </table>

        <StoryForm
            v-if="showForm"
            v-model="newStory"
            :project="project"
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
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import BButton from '@bootstrap/button/button';

export default {
    components: { StoryForm, StoryItem, BButton },
    extends: BaseProjectAwarePage,
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
        };
    },
    computed: {
        /**
         * All stories in backlog that are open and not already in sprints, sorted by position
         * @returns {array}
         */
        stories() {
            return this.project
                ? this.$store.getters['stories/all'](this.project.id)
                    .filter(s => !s.sprint_id && s.status === this.$store.state.stories.STATUS.OPEN)
                    .sort((a, b) => a.project_position - b.project_position)
                : [];
        },

        /**
         * Current sprint depending on current date
         * @returns {object}
         */
        currentSprint() {
            return this.course
                ? _.first(
                    this.$store.getters['sprints/all'](this.course.id)
                        .filter(s =>
                            s.start_date <= this.$store.state.currentDate
                            && s.end_date >= this.$store.state.currentDate
                        )
                        .sort((a, b) => a.start_date.localeCompare(b.start_date)))
                : null;
        },

        /**
         * Stories in current sprint
         * @returns {array}
         */
        storiesInSprint() {
            return this.currentSprint
                ? this.$store.getters['stories/find'](this.project.id, 'sprint_id', this.currentSprint.id)
                    .sort((a, b) => a.sprint_position - b.sprint_position)
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
                project_position: evt.newIndex + 1, // act_as_list is 1-indexed
            });

            await this.$store.dispatch('projects/fetch', {
                id: this.project.id,
                parentId: this.course.id
            });

            // TODO handle errors in UI
        },
    },
};
</script>