<template>
    <section id="backlog-page">
        <template v-if="currentSprint">
            <h3 class="h5 text-muted mb-0">
                Current sprint
                <small>({{ currentSprint.start_date | displayDate }} - {{ currentSprint.end_date | displayDate }})</small>
            </h3>
            <h2>{{ currentSprint.name }}</h2>

            <StoryTable
                :columns="tableColumns.currentSprint"
                :rows="storiesInSprint"
                position-field="sprint_position"
                view="sprint"/>
        </template>

        <h2>Backlog</h2>

        <StoryTable
            :columns="tableColumns.backlog"
            :rows="stories"
            view="backlog"
            position-field="project_position"
            :sortable="true"/>
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
import StoryTable from '@/components/elements/StoryTable';

export default {
    components: { StoryForm, StoryItem, BButton, StoryTable },
    extends: BaseProjectAwarePage,
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
            tableColumns: {
                currentSprint: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { field: 'status', name: 'Status' },
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
    },
};
</script>