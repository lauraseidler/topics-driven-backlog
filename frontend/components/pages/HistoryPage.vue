<template>
    <section id="history-page">
        <template v-for="sprint in sprints">
            <div :key="sprint.id" class="mb-4">
                <h3 class="h5 text-muted mb-0">
                    <small>{{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }}</small>
                </h3>
                <h2>{{ sprint.name }}</h2>

                <StoryTable
                    v-if="storiesInSprint(sprint.id).length"
                    :columns="tableColumns.sprints"
                    :rows="storiesInSprint(sprint.id)"
                    position-field="sprint_position"
                    view="history"
                />

                <p v-else>No stories in this sprint</p>
            </div>
        </template>

        <h2>Backlog</h2>
        <StoryTable
            :columns="tableColumns.backlog"
            :rows="backlog"
            position-field="project_position"
            view="history"
        />
    </section>
</template>

<script>
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';
import StoryTable from '@/components/elements/StoryTable';

export default {
    components: { StoryItem, StoryTable },
    extends: BaseProjectAwarePage,
    data() {
        return {
            tableColumns: {
                sprints: [
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
                    { field: 'status', name: 'Status' },
                ]
            }
        };
    },
    computed: {
        /**
         * All stories not in sprints, sorted by position
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
         * All sprints, sorted by start date
         * @returns {array}
         */
        sprints() {
            return this.course
                ? this.$store.getters['sprints/all'](this.course.id)
                    .sort((a, b) => a.start_date.localeCompare(b.start_date))
                : [];
        },
    },
    methods: {
        /**
         * All stories in a specific sprint
         * @param {int} sprintId
         * @returns {array}
         */
        storiesInSprint(sprintId) {
            return this.project
                ? this.$store.getters['stories/find'](this.project.id, 'sprint_id', sprintId)
                    .sort((a, b) => a.sprint_position - b.sprint_position)
                : [];
        },
    },
};
</script>
