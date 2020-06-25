<template>
    <section id="project-page">
        <router-link 
            :to="`/courses/${course.id}-${slugify(course.title)}`" 
            class="btn btn-primary float-right ml-2" 
            v-if="course">

            Back to course
        </router-link>

        <router-link 
            :to="`/projects/${project.id}-${slugify(project.title)}/print`" 
            class="btn btn-primary float-right" 
            v-if="project">

            View report
        </router-link>

        <router-link 
            class="h4 text-muted" 
            :to="`/courses/${course.id}-${slugify(course.title)}`" 
            v-if="course">

            {{ course.short_title }} <small>({{ course.title }})</small>
        </router-link>

        <h1 v-if="project">{{ project.title }}: {{ currentView }}</h1>

        <hr>

        <CollapsingSection v-model="sections.history">
            <template slot="headline">
                <h2>History</h2>
            </template>

            <template slot="content">
                <div v-if="pastSprints.length">
                    <template v-for="sprint in pastSprints">
                        <div 
                            :key="sprint.id" 
                            class="mb-4">

                            <h3 class="h5">
                                {{ sprint.name }}
                                <small class="text-muted">({{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }})</small>
                                <BButton
                                    v-if="canOpenSprint()"
                                    class="float-right mb-3"
                                    size="sm"
                                    type="button"
                                    variant="outline-primary"
                                    v-confirm="{
                                        action: () => planningOpen(sprint.id),
                                        text: 'Do you want to make this sprint plannable again? It will moved to the next sprint section. The sprint previously marked as next sprint will become visible again once the planning for this sprint is marked complete again'
                                }">

                                    Open sprint
                                </BButton>
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

                <h3 
                    class="h5" 
                    v-else>
                    
                    No past sprints!
                </h3>
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
                        <BButton
                            v-if="canOpenSprint()"
                            class="float-right mb-3"
                            size="sm"
                            type="button"
                            variant="outline-primary"
                            v-confirm="{
                                        action: () => planningOpen(currentSprint.id),
                                        text: 'Do you want to make this sprint plannable again? It will moved to the next sprint section. The sprint previously marked as next sprint will become visible again once the planning for this sprint is marked complete again'
                                }">

                            Open sprint
                        </BButton>
                    </h3>

                    <StoryTable
                        :columns="tableColumns.currentSprint"
                        :rows="storiesInSprint(currentSprint.id)"
                        position-field="sprint_position"
                        view="sprint"/>
                </template>

                <h3 
                    class="h5" 
                    v-else>
                    
                    No current sprint!
                </h3>
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
                        <BButton
                            v-if="nextSprint && project.planned_sprint_ids.indexOf(nextSprint.id) < 0"
                            class="float-right mb-3"
                            size="sm"
                            type="button"
                            variant="primary"
                            v-confirm="{
                                action: planningComplete,
                                text: 'This action is irreversible. While you will continue to be able to change the scope of this sprint if/while it is still in the future, the sprint will advance to the next sprint stage automatically when the time comes, and you will no longer be able to make changes. Proceed?'
                            }">
                        
                            Mark sprint planning complete
                        </BButton>
                        {{ nextSprint.name }}
                        <small class="text-muted">({{ nextSprint.start_date | displayDate }} - {{ nextSprint.end_date | displayDate }})</small>
                    </h3>

                    <StoryTable
                        :columns="tableColumns.nextSprint"
                        :rows="storiesInSprint(nextSprint.id)"
                        position-field="sprint_position"
                        :sortable="true"
                        view="planning-sprint"/>
                </template>


                <h3 
                    class="h5" 
                    v-else>
                    
                    No sprint to plan!
                </h3>
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
                    :view="nextSprint && sections.nextSprint ? 'planning-backlog' : 'backlog'"
                    position-field="project_position"
                    :sortable="true"/>

                <StoryForm
                    ref="storyForm"
                    v-if="showForm"
                    v-model="newStory"
                    :project="project"
                    @cancel="cancelNew"
                    @submit="save"/>

                <BButton
                    v-else-if="project && project.permissions.stories.create"
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
import { slugify } from '@/helper/util';

export default {
    name: 'ProjectPage',
    components: { StoryForm, StoryItem, BButton, StoryTable, VIcon, CollapsingSection },
    extends: BaseProjectAwarePage,
    data() {
        return {
            showForm: false,
            newStory: this.$store.getters['stories/template'](),
            tableColumns: {
                history: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'ID' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { field: 'status', name: 'Status' },
                ],
                currentSprint: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'ID' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { field: 'status', name: 'Status' },
                ],
                nextSprint: [
                    { field: 'sprint_position', name: 'Position' },
                    { field: 'identifier', name: 'ID' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { name: '' },
                ],
                backlog: [
                    { field: 'project_position', name: 'Position' },
                    { field: 'identifier', name: 'ID' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic', name: 'Topic' },
                    { field: 'points', name: 'Story points' },
                    { name: '' },
                ],
            },
            sections: {
                history: false,
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
                    .map(this.resolveTopicId)
                    .sort((a, b) => a.project_position - b.project_position)
                : [];
        },

        /**
         * The current sprint in the project's course
         * @returns {object}
         */
        currentSprint() {
            return this.course && this.project
                ? this.$store.getters['sprints/current'](this.course.id, this.project.id)
                : null;
        },

        /**
         * The next sprint in the project's course
         * @returns {object}
         */
        nextSprint() {
            return this.course && this.project
                ? this.$store.getters['sprints/next'](this.course.id, this.project.id)
                : null;
        },

        /**
         * All past sprints in the project's course
         * @returns {array}
         */
        pastSprints() {
            return this.course && this.project
                ? this.$store.getters['sprints/past'](this.course.id, this.project.id)
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

        topics() {
            return this.course
                ? this.$store.getters['topics/all'](this.course.id)
                : [];
        },
    },
    methods: {
        slugify,

        /**
         * Stories in sprint with ID
         * @param {int} sprintId
         * @returns {array}
         */
        storiesInSprint(sprintId) {
            return this.$store.getters['stories/find'](this.project.id, 'sprint_id', sprintId)
                .map(this.resolveTopicId)
                .sort((a, b) => a.sprint_position - b.sprint_position);
        },

        /**
         * Resolve the topic ID in a story
         * @param {object} story
         * @returns {object}
         */
        resolveTopicId(story) {
            const topic = story.topic_id
                ? this.topics.find(t => t.id === story.topic_id)
                : null;

            return {
                topic: topic ? topic.title : null,
                ...story,
            };
        },

        /**
         * Save current form state as new story
         */
        async save() {
            try {
                await this.$store.dispatch('stories/create', {
                    parentId: this.project.id,
                    ...this.newStory,
                });
    
                this.newStory = this.$store.getters['stories/template']();
                this.showForm = false;
                this.$store.commit('resolvePendingChange');
                
                this.$nextTick(() => {
                    !this.$refs.storyForm || this.$refs.storyForm.$el.reset();
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Story creation failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },

        async planningComplete() {
            if (!this.nextSprint) {
                return;
            }

            try {
                await this.$store.dispatch('projects/planningComplete', {
                    courseId: this.course.id,
                    projectId: this.project.id,
                    sprintId: this.nextSprint.id,
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Sprint update failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
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

        canOpenSprint() {
            return this.$store.state.user.role === 1;
        },

        async planningOpen(sprintId) {
            try {
                await this.$store.dispatch('projects/planningOpen', {
                    courseId: this.course.id,
                    projectId: this.project.id,
                    sprintId: sprintId,
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Sprint update failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },
    },
};
</script>

<style scoped>

</style>