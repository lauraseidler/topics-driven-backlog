<template>
    <section id="sprint-planning-page">
        <template v-if="nextSprint">
            <h3 class="h5 text-muted mb-0">
                Next sprint
                <small>({{ nextSprint.start_date | displayDate }} - {{ nextSprint.end_date | displayDate }})</small>
            </h3>
            <h2>{{ nextSprint.name }}</h2>

            <StoryTable
                :columns="tableColumns.nextSprint"
                :rows="storiesInSprint"
                position-field="sprint_position"
                :sortable="true"
                view="planning-sprint"
            />
        </template>

        <p v-else>No sprint to plan!</p>

        <h2>Backlog</h2>

        <StoryTable
            :columns="tableColumns.backlog"
            :rows="backlog"
            position-field="project_position"
            view="planning-backlog"
        />

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
import * as _ from 'lodash';
import moment from 'moment';
import BButton from '@bootstrap/button/button';
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import SprintItem from '@/components/elements/SprintItem';
import StoryTable from '@/components/elements/StoryTable';

export default {
    components: { SprintItem, StoryForm, StoryItem, BButton, StoryTable },
    extends: BaseProjectAwarePage,
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
            tableColumns: {
                nextSprint: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story Points' },
                ],
                backlog: [
                    { field: 'project_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { name: 'Operations' },
                ]
            }
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
                    .sort((a, b) => a.project_position - b.project_position)
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
                        .filter(s => s.start_date > currentDate)
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
    },
};
</script>
