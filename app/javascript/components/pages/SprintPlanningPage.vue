<template>
    <section id="backlog-page">
        <h1>Sprint planning</h1>

        <p>TBC</p>

        <h2>Backlog</h2>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Identifier</th>
                    <th>Story</th>
                    <th>Story&nbsp;points</th>
                    <th>Operations</th>
                </tr>
            </thead>
            <tbody >
                <tr is="story" v-for="story in backlog" :key="story.id" :data="story" view="planning"></tr>
            </tbody>
        </table>

        <story-form v-if="showForm" v-model="newStory" @cancel="showForm = false" @submit="save"></story-form>
        <b-button v-else type="button" variant="primary" @click="showForm = true">Add story</b-button>
    </section>
</template>

<script>
    import Story from "../elements/Story.vue";
    import StoryForm from "../forms/StoryForm.vue";
    import Sprint from "../elements/Sprint.vue";

    export default {
        components: {
            Sprint,
            StoryForm, Story},
        data() {
            return {
                showForm: false,
                newStory: {},
            };
        },
        computed: {
            backlog() {
                return this.$store.getters['stories/all']
                    .filter(s => s.status === this.$store.state.stories.STATUS.OPEN)
                    .sort((a, b) => a.position - b.position);
            },
        },
        methods: {
            /**
             * Save current form state as new story
             */
            save() {
                this.$store.dispatch('stories/save', {
                    story: this.newStory
                }).then(() => {
                    this.newStory = {};
                });
            },
        }
    };
</script>

<style scoped>

</style>
