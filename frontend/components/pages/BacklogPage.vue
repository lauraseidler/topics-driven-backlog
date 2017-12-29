<template>
    <section id="backlog-page">
        <h1>Backlog</h1>

        <table class="table table-striped">
            <thead>
                <tr>
                    <th>&nbsp;</th>
                    <th>Identifier</th>
                    <th>Story</th>
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
import StoryItem from '@/components/elements/StoryItem';
import StoryForm from '@/components/forms/StoryForm';
import BButton from '@bootstrap/button/button';

export default {
    components: { StoryForm, StoryItem, BButton },
    data() {
        return {
            showForm: false,
            newStory: {},
        };
    },
    computed: {
        /**
         * All stories in backlog that are open and not already in sprints, sorted by position
         * @returns {array}
         */
        stories() {            
            return this.$store.getters['stories/all']
                .filter(s => !s.sprint_id && s.status === this.$store.state.stories.STATUS.OPEN)
                .sort((a, b) => a.position - b.position);
        },
    },
    methods: {
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
            const story = this.stories[evt.oldIndex];

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
    },
};
</script>