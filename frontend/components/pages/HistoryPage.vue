<template>
    <section id="history-page">
        <template v-for="sprint in sprints">
            <div :key="sprint.id" class="mb-4">
                <h3 class="h5 text-muted mb-0">
                    <small>{{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }}</small>
                </h3>
                <h2>{{ sprint.name }}</h2>

                <table 
                    v-if="storiesInSprint(sprint.id).length" 
                    class="table table-striped">

                    <thead>
                        <tr>
                            <th>Identifier</th>
                            <th>Story</th>
                            <th>Topic</th>
                            <th>Story&nbsp;points</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr 
                            is="StoryItem" 
                            v-for="story in storiesInSprint(sprint.id)" 
                            :key="story.id" 
                            :data="story" 
                            view="history"/>
                    </tbody>
                </table>

                <p v-else>No stories in this sprint</p>
            </div>
        </template>

        <h2>Backlog</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Identifier</th>
                    <th>Story</th>
                    <th>Topic</th>
                    <th>Story&nbsp;points</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr 
                    is="StoryItem" 
                    v-for="story in backlog" 
                    :key="story.id" 
                    :data="story" 
                    view="history"/>
            </tbody>
        </table>
    </section>
</template>

<script>
import BaseProjectAwarePage from '@/components/pages/BaseProjectAwarePage';
import StoryItem from '@/components/elements/StoryItem';

export default {
    components: { StoryItem },
    extends: BaseProjectAwarePage,
    data() {
        return {};
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
                    .sort((a, b) => a.position - b.position)
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
                    .sort((a, b) => a.position - b.position)
                : [];
        },
    },
};
</script>
