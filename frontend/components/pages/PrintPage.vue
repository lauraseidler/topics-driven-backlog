<template>
    <section id="print-page">
        <div class="alert alert-info hidden-print">
            <h5>
                <VIcon 
                    name="info-circle" 
                    class="mb-1 mr-1"/>

                About this page
            </h5>

            <p>
                This is the report view of your project. You can save your report as a PDF by using your browser's print
                functionality and then choosing "Save as PDF", "Print to PDF" or similar, depending on your browser
                and operating system.
            </p>

            <p class="mb-0">
                If you want to view your report in the context of a different period of time, you can choose the sprint
                that you want to be the "Next sprint" in the dropdown on the top right. By default, you're viewing the
                current state of your project.
            </p>
        </div>

        <BFormGroup
            horizontal
            class="float-right hidden-print"
            label="Next&nbsp;sprint"
            label-for="print-sprint">

            <BFormSelect
                class="float-right w-auto"
                id="print-sprint"
                v-model="chosenSprint">

                <option 
                    :value="null"
                    selected>
                    
                    By date (default)
                </option>

                <option
                    v-for="(sprint, index) in pastSprints"
                    :value="index"
                    :key="sprint.id">

                    {{ sprint.name }}
                </option>
            </BFormSelect>
        </BFormGroup>

        <h4 
            class="h4 text-muted" 
            v-if="course">

            {{ course.short_title }} <small>({{ course.title }})</small>
        </h4>

        <h1 v-if="project">{{ project.title }}: Report</h1>

        <h2>History</h2>

        <div v-if="pastSprints.length && chosenSprint !== 0 && chosenSprint !== 1">
            <template 
                v-for="(sprint, index) in pastSprints" 
                v-if="chosenSprint === null || index < chosenSprint - 1">

                <div 
                    :key="sprint.id" 
                    class="mb-4">

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

        <h3 
            class="h5" 
            v-else>
            
            No past sprints!
        </h3>

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


        <h3 
            class="h5" 
            v-else>
            
            No current sprint!
        </h3>

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


        <h3 
            class="h5" 
            v-else>
            
            No sprint to plan!
        </h3>

        <hr>

        <h2>Backlog</h2>

        <StoryTable 
            v-if="backlog.length"
            :columns="tableColumns"
            :rows="backlog"
            position-field="project_position"
            view="print"/>

        <h3 
            class="h5" 
            v-else>
            
            No stories in backlog!
        </h3>

    </section>
</template>

<script>
import '@icons/tasks';
import '@icons/signal';
import '@icons/info-circle';
import VIcon from 'vue-awesome/components/Icon';
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import BButton from '@bootstrap/button/button';
import StoryTable from '@/components/elements/StoryTable';
import CollapsingSection from '@/components/elements/CollapsingSection';
import BFormSelect from '@bootstrap/form-select/form-select';
import BFormGroup from '@bootstrap/form-group/form-group';
import { slugify } from '@/helper/util';

export default {
    name: 'PrintPage',
    components: { StoryForm, StoryItem, BButton, StoryTable, VIcon, CollapsingSection, BFormSelect, BFormGroup },
    extends: BaseProjectAwarePage,
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
                return this.$store.getters['sprints/current'](this.course.id, this.project.id)
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
                    : this.$store.getters['sprints/next'](this.course.id, this.project.id)
                : null;
        },

        /**
         * All past sprints in the project's course
         * @returns {array}
         */
        pastSprints() {
            return this.course
                ? this.$store.getters['sprints/past'](this.course.id, this.project.id)
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
                .sort((a, b) => a.sprint_position - b.sprint_position);
        },
    },
};
</script>
