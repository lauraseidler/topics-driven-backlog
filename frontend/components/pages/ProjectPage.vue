<template>
    <section id="project-page">
        <h2 class="h4 text-muted" v-if="course">{{ course.short_title }} <small>({{ course.title}})</small></h2>
        <h1 v-if="project">{{ project.title }}: {{ currentView }}</h1>

        <hr>

        <CollapsingSection v-model="sections.history">
            <template slot="headline">
                <h2>History</h2>
            </template>
            <template slot="content">
                <div v-if="pastSprints.length">
                    <template v-for="sprint in pastSprints">
                        <div :key="sprint.id" class="mb-4">
                            <h3 class="h5">
                                {{ sprint.name }}
                                <small class="text-muted">({{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }})</small>
                            </h3>

                            <StoryTable
                                v-if="storiesInSprint(sprint.id).length"
                                :columns="tableColumns.history"
                                :rows="storiesInSprint(sprint.id)"
                                position-field="sprint_position"
                                view="history"
                            />

                            <p v-else>No stories in this sprint</p>
                        </div>
                    </template>
                </div>

                <h3 class="h5" v-else>No past sprints!</h3>
            </template>
        </CollapsingSection>

        <hr>

        <CollapsingSection v-model="sections.currentSprint">
            <template slot="headline">
                <h2>Current sprint</h2>
            </template>
            <template slot="content">
                <template v-if="currentSprint">
                    <h3 class="h5">
                        {{ currentSprint.name }}
                        <small class="text-muted">({{ currentSprint.start_date | displayDate }} - {{ currentSprint.end_date | displayDate }})</small>
                    </h3>
                    <StoryTable

                            :columns="tableColumns.currentSprint"
                            :rows="storiesInSprint(currentSprint.id)"
                            position-field="sprint_position"
                            view="sprint"
                    />
                </template>


                <h3 class="h5" v-else>No current sprint!</h3>
            </template>
        </CollapsingSection>

        <hr>

        <CollapsingSection v-model="sections.nextSprint">
            <template slot="headline">
                <h2>Next sprint</h2>
            </template>
            <template slot="content">
                <template v-if="nextSprint">
                    <h3 class="h5">
                        {{ nextSprint.name }}
                        <small class="text-muted">({{ nextSprint.start_date | displayDate }} - {{ nextSprint.end_date | displayDate }})</small>
                    </h3>
                    <StoryTable

                            :columns="tableColumns.nextSprint"
                            :rows="storiesInSprint(nextSprint.id)"
                            position-field="sprint_position"
                            :sortable="true"
                            view="planning-sprint"
                    />
                </template>


                <h3 class="h5" v-else>No sprint to plan!</h3>
            </template>
        </CollapsingSection>

        <hr>

        <CollapsingSection v-model="sections.backlog">
            <template slot="headline">
                <h2>Backlog</h2>
            </template>
            <template slot="content">
                <h3 class="h5">Stories not in any sprints</h3>
                <StoryTable
                        :columns="tableColumns.backlog"
                        :rows="backlog"
                        :view="sections.nextSprint ? 'planning-backlog' : 'backlog'"
                        position-field="project_position"
                        :sortable="true"/>

                <StoryForm
                        v-if="showForm"
                        v-model="newStory"
                        :project="project"
                        @cancel="cancelNew"
                        @submit="save"/>

                <BButton
                        v-else
                        type="button"
                        variant="primary"
                        @click="startNew">Add story</BButton>
            </template>
        </CollapsingSection>

        <hr>
    </section>
</template>

<script>
import '@icons/tasks';
import '@icons/signal';
import VIcon from 'vue-awesome/components/Icon';
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import BButton from '@bootstrap/button/button';
import StoryTable from '@/components/elements/StoryTable';
import bus from '@/helper/bus';
import CollapsingSection from '@/components/elements/CollapsingSection';

export default {
    name: 'ProjectPage',
    extends: BaseProjectAwarePage,
    components: { StoryForm, StoryItem, BButton, StoryTable, VIcon, CollapsingSection },
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
            tableColumns: {
                history: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { field: 'status', name: 'Status' },
                ],
                currentSprint: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { field: 'status', name: 'Status' },
                ],
                nextSprint: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { name: 'Operations' },
                ],
                backlog: [
                    { field: 'project_position', name: 'Position' },
                    { field: 'identifier', name: 'Identifier' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { name: 'Operations' },
                ]
            },
            sections: {
                currentSprint: true,
                nextSprint: false,
                backlog: true,
            },
        };
    },
    computed: {
        /**
         * All stories in backlog that are not already in sprints, sorted by position
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
         * The current sprint in the project's course
         * @returns {object}
         */
        currentSprint() {
            return this.course
                ? this.$store.getters['sprints/current'](this.course.id)
                : null;
        },

        /**
         * The next sprint in the project's course
         * @returns {object}
         */
        nextSprint() {
            return this.course
                ? this.$store.getters['sprints/next'](this.course.id)
                : null;
        },

        /**
         * All past sprints in the project's course
         * @returns {array}
         */
        pastSprints() {
            return this.course
                ? this.$store.getters['sprints/past'](this.course.id)
                : [];
        },

        currentView() {
            if (this.sections.history) {
                return 'History';
            }

            if (this.sections.nextSprint) {
                return 'Sprint planning';
            }

            return 'Backlog';
        },
    },
    methods: {
        /**
         * Stories in sprint with ID
         * @returns {array}
         */
        storiesInSprint(sprintId) {
            return this.$store.getters['stories/find'](this.project.id, 'sprint_id', sprintId)
                    .sort((a, b) => a.sprint_position - b.sprint_position);
        },

        /**
         * Save current form state as new story
         */
        async save() {
            await this.$store.dispatch('stories/create', {
                parentId: this.project.id,
                ...this.newStory
            });

            this.newStory = this.$store.getters['stories/template']();
            this.showForm = false;
            this.$store.commit('resolvePendingChange');

            // TODO handle errors in UI
        },

        startNew() {
            this.showForm = true;
            this.$store.commit('newPendingChange');
            bus.$on('saveAll', this.save);
        },

        cancelNew() {
            this.showForm = false;
            this.$store.commit('resolvePendingChange');
            bus.$off('saveAll', this.save);
        },

        saveAll() {
            bus.$emit('saveAll');
        },
    }
};
</script>

<style scoped>

</style>