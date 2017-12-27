<template>
    <section id="history-page">
        <h1>History</h1>

        <template v-for="sprint in sprints">
            <div :key="sprint.id">
                <h2>{{ sprint.name }}</h2>

                <table 
                    v-if="storiesInSprint(sprint.id).length" 
                    class="table table-striped">

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
import StoryItem from '@/components/elements/StoryItem';

export default {
    components: { StoryItem },
    data() {
        return {};
    },
    computed: {
        /**
         * All stories not in sprints, sorted by position
         * @returns {array}
         */
        backlog() {
            return this.$store.getters['stories/all']
                .filter(s => s.sprint_id === null)
                .sort((a, b) => a.position - b.position);
        },

        /**
         * All sprints, sorted by start date
         * @returns {array}
         */
        sprints() {
            return this.$store.getters['courses/allSprints']().slice().sort((a, b) => a.start_date.localeCompare(b.start_date));
        },
    },
    methods: {
        /**
         * All stories in a specific sprint
         * @param {int} sprintId
         * @returns {array}
         */
        storiesInSprint(sprintId) {
            return this.$store.getters['stories/find']('sprint_id', sprintId).sort((a, b) => a.position - b.position);
        },

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
