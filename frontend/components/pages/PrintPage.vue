<template>
    <section id="print-page">

        <BFormGroup
                horizontal
                class="float-right hidden-print"
                label="Next&nbsp;sprint"
                label-for="print-sprint">
            <BFormSelect
                class="float-right w-auto"
                id="print-sprint"
                v-model="chosenSprint">

                <option :value="null" selected>By date (default)</option>

                <option
                        v-for="(sprint, index) in pastSprints"
                        :value="index"
                        :key="sprint.id">

                    {{ sprint.name }}
                </option>
            </BFormSelect>
        </BFormGroup>


        <h4 class="h4 text-muted" v-if="course">
            {{ course.short_title }} <small>({{ course.title}})</small>
        </h4>
        <h1 v-if="project">{{ project.title }}: Report</h1>

        <h2>History</h2>

        <div v-if="pastSprints.length && chosenSprint !== 0 && chosenSprint !== 1">
            <template v-for="(sprint, index) in pastSprints" v-if="chosenSprint === null || index < chosenSprint - 1">
                <div :key="sprint.id" class="mb-4">
                    <h3 class="h5">
                        {{ sprint.name }}
                        <small class="text-muted">({{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }})</small>
                    </h3>

                    <StoryTable
                        v-if="storiesInSprint(sprint.id).length"
                        :columns="tableColumns"
                        :rows="storiesInSprint(sprint.id)"
                        position-field="sprint_position"
                        view="print"/>

                    <p v-else>No stories in this sprint</p>
                </div>
            </template>
        </div>

        <h3 class="h5" v-else>No past sprints!</h3>

        <hr>

        <h2>Current sprint</h2>

        <template v-if="currentSprint">
            <h3 class="h5">
                {{ currentSprint.name }}
                <small class="text-muted">({{ currentSprint.start_date | displayDate }} - {{ currentSprint.end_date | displayDate }})</small>
            </h3>
            <StoryTable
                :columns="tableColumns"
                :rows="storiesInSprint(currentSprint.id)"
                position-field="sprint_position"
                view="print"/>
        </template>


        <h3 class="h5" v-else>No current sprint!</h3>

        <hr>

        <h2>Next sprint</h2>

        <template v-if="nextSprint">
            <h3 class="h5">
                {{ nextSprint.name }}
                <small class="text-muted">({{ nextSprint.start_date | displayDate }} - {{ nextSprint.end_date | displayDate }})</small>
            </h3>
            <StoryTable
                :columns="tableColumns"
                :rows="storiesInSprint(nextSprint.id)"
                position-field="sprint_position"
                view="print"/>
        </template>


        <h3 class="h5" v-else>No sprint to plan!</h3>

        <hr>

        <h2>Backlog</h2>
        <StoryTable v-if="backlog.length"
            :columns="tableColumns"
            :rows="backlog"
            position-field="project_position"
            view="print"/>
        <h3 class="h5" v-else>No stories in backlog!</h3>

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
    import BFormSelect from '@bootstrap/form-select/form-select';
    import BFormGroup from '@bootstrap/form-group/form-group';

    export default {
        name: 'PrintPage',
        extends: BaseProjectAwarePage,
        components: { StoryForm, StoryItem, BButton, StoryTable, VIcon, CollapsingSection, BFormSelect, BFormGroup },
        data() {
            return {
                tableColumns: [
                    { field: 'identifier', name: 'ID' },
                    { field: 'title', name: 'Story' },
                    { field: 'topic_id', name: 'Topic' },
                    { field: 'points', name: 'SP' },
                    { field: 'status', name: 'Status' },
                ],
                chosenSprint: null,
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
                if (!this.course || this.chosenSprint === 0) {
                    return null;
                }

                if (this.chosenSprint === null) {
                    return this.$store.getters['sprints/current'](this.course.id)
                }

                return this.$store.getters['sprints/byId'](this.pastSprints[this.chosenSprint - 1].id);
            },

            /**
             * The next sprint in the project's course
             * @returns {object}
             */
            nextSprint() {
                return this.course
                    ? this.chosenSprint !== null
                        ? this.$store.getters['sprints/byId'](this.pastSprints[this.chosenSprint].id)
                        : this.$store.getters['sprints/next'](this.course.id)
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

            slugify(text) {
                return text.toString().toLowerCase()
                    .replace(/\s+/g, '-')           // Replace spaces with -
                    .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
                    .replace(/\-\-+/g, '-')         // Replace multiple - with single -
                    .replace(/^-+/, '')             // Trim - from start of text
                    .replace(/-+$/, '');            // Trim - from end of text
            },
        }
    };
</script>

<style scoped>

</style>